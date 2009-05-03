//
//  LoginOperation.m
//  ozEstate
//
//  Created by Anthony Mittaz on 8/08/08.
//  Copyright 2008 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
// 

#import "DefaultOperation.h"
#import "Base64.h"
#import "NSHTTPCookieAdditions.h"
#import "buffio.h"
#import <CFNetwork/CFNetwork.h>

@implementation DefaultOperation

@synthesize url;
@synthesize target;
@synthesize action;
@synthesize needRefreshInterface;
@synthesize infoDictionary;
@synthesize peformedSelectorOnce;
@synthesize user;
@synthesize password;
@synthesize bodyData;
@synthesize requestMethod;
@synthesize contentType;
@synthesize accept;
@synthesize responseStatusCode;
@synthesize tmpFilePath=_tmpFilePath;
@synthesize tmpFileHandle=_tmpFileHandle;


#pragma mark -
#pragma mark Initialisation:

- (id)initWithURL:(NSURL *)anUrl target:(id)aTarget action:(SEL)anAction needRefreshInterface:(BOOL)aNeedRefreshInterface infoDictionary:(NSDictionary *)anInfoDictionary
{
	self = [super init];
	
	self.url = anUrl;
	self.target = aTarget;
	self.action = anAction;
	self.needRefreshInterface = aNeedRefreshInterface;
	self.infoDictionary = anInfoDictionary;
	self.peformedSelectorOnce = FALSE;
	self.requestMethod = @"GET";
	self.contentType = @"text/html; charset=utf-8";
	
	// Buffer
	// downloaded daa gets offloaded to the filesystem immediately, to get it out of memory
	NSString * path = [NSTemporaryDirectory() stringByAppendingPathComponent: @"Quatermain"];
	[[NSFileManager defaultManager] createDirectoryAtPath: path attributes: nil];
	
	char buf[PATH_MAX];
	[path getCString: buf maxLength: PATH_MAX encoding: NSASCIIStringEncoding];
	NSString *uniqueString = [NSString stringWithFormat:@"/tmp.%@", [[NSProcessInfo processInfo]globallyUniqueString]];
	strlcat(buf, [uniqueString UTF8String], PATH_MAX);
	
	int fd = mkstemp(buf);
	NSString *tmpFilePath = [[NSString alloc] initWithCString: buf encoding: NSASCIIStringEncoding];
	self.tmpFilePath = tmpFilePath;
	[tmpFilePath release];
	NSFileHandle *tmpFileHandle = [[NSFileHandle alloc] initWithFileDescriptor: fd closeOnDealloc: YES];
	self.tmpFileHandle = tmpFileHandle;
	[tmpFileHandle release];
	
    return self;
}

#pragma mark -
#pragma mark This Is Where The Download And Processing Append:

// By the way the is a reason why this method 
// is not spitted into multiple files
- (void)main
{
	if ([self isCancelled])
	{
		return;  // user cancelled this operation
	}
	
	NSData *responseData = [self downloadUrl];
	
	if ([responseData length] != 0)  {
        
		if (![self isCancelled])
		{
			BOOL success;
			NSXMLParser *anXMLParser = [[[NSXMLParser alloc] initWithData:responseData]autorelease];
			[anXMLParser setDelegate:self];
			[anXMLParser setShouldProcessNamespaces:NO];
			[anXMLParser setShouldReportNamespacePrefixes:NO];
			[anXMLParser setShouldResolveExternalEntities:NO];
			success = [anXMLParser parse]; // return value not used
			if (success) {
				[self performSelectorWithDictionary:nil];
			}
		}
	}
}

- (NSData *)downloadUrl
{
	// empty file
	[_tmpFileHandle truncateFileAtOffset: 0];
	
	if (!self.url || [[self.url absoluteString] length] == 0) {
		return nil;
	}
	
	// new way
	CFURLRef _uploadURL = CFURLCreateWithString(kCFAllocatorDefault, (CFStringRef)[url absoluteString], NULL);
	CFHTTPMessageRef _request = CFHTTPMessageCreateRequest(kCFAllocatorDefault, (CFStringRef)(self.requestMethod), _uploadURL, kCFHTTPVersion1_1);
	CFRelease(_uploadURL);
	_uploadURL = NULL;
	
	
	// authentification
	if (user != nil && password != nil) {
		Boolean result = CFHTTPMessageAddAuthentication(_request,    // Request
														nil,      // AuthenticationFailureResponse
														(CFStringRef)user,
														(CFStringRef)password,
														kCFHTTPAuthenticationSchemeBasic,
														FALSE);      // ForProxy
		if (result) {
			DLog(@"added authentication for url %@", self.url);
		} else {
			DLog(@"failed to add authentication!");
		}
	}
	
	CFHTTPMessageSetHeaderFieldValue(_request, CFSTR("Content-Type"), (CFStringRef)(self.contentType));
	if (self.accept) {
		CFHTTPMessageSetHeaderFieldValue(_request, CFSTR("Accept"), (CFStringRef)(self.accept));
	}
	CFHTTPMessageSetHeaderFieldValue(_request, CFSTR("User-Agent"), CFSTR("Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_6; en-us) AppleWebKit/528.10+ (KHTML, like Gecko) Version/4.0 Safari/528.1"));
	// autorisation
	if (user != nil && password != nil) {
		NSString *loginString = [NSString stringWithFormat:@"%@:%@", self.user, self.password];
		NSData *loginStringAsData = [loginString dataUsingEncoding:NSUTF8StringEncoding];
		NSString *base64LoginString = [loginStringAsData base64Encoding];
		NSString *autorisationString = [NSString stringWithFormat:@"Basic (%@)", base64LoginString];
		
		CFHTTPMessageSetHeaderFieldValue(_request, CFSTR("Authorization"), (CFStringRef)(autorisationString));
	}
	
	//  // Add cookies from the persistant (mac os global) store
	//  NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url];
	//  
	//  // Apply request cookies
	//  if ([cookies count] > 0) {
	//    NSHTTPCookie *cookie;
	//    NSString *cookieHeader = nil;
	//    for (cookie in cookies) {
	//      if (!cookieHeader) {
	//        cookieHeader = [NSString stringWithFormat: @"%@=%@",[cookie name],[cookie encodedValue]];
	//      } else {
	//        cookieHeader = [NSString stringWithFormat: @"%@; %@=%@",cookieHeader,[cookie name],[cookie encodedValue]];
	//      }
	//    }
	//    if (cookieHeader) {
	//      CFHTTPMessageSetHeaderFieldValue(_request, CFSTR("Cookie"), (CFStringRef)(cookieHeader));
	//    }
	//  }
	
	if (self.bodyData) {
		CFHTTPMessageSetHeaderFieldValue(_request, CFSTR("Content-Length"), (CFStringRef)[NSString stringWithFormat: @"%d", [self.bodyData length]]);
		CFHTTPMessageSetBody(_request, (CFDataRef)self.bodyData);
	}
	
	
	CFReadStreamRef _readStream = CFReadStreamCreateForHTTPRequest(kCFAllocatorDefault, _request);
	// Follow redirect
	CFReadStreamSetProperty(_readStream, kCFStreamPropertyHTTPShouldAutoredirect, kCFBooleanTrue);
	CFReadStreamOpen(_readStream);
	
	CFIndex numBytesRead;
	long bytesWritten, previousBytesWritten = 0;
	UInt8 buf[1024];
	BOOL doneUploading = NO;
	
	NSDate *downloadStartedAt = [NSDate date];
	NSTimeInterval timeOutSeconds = 30.0;
	while (!doneUploading) {
		NSMutableData *responseData =  [NSMutableData dataWithLength:0];
		NSDate *now = [NSDate date];
		
		// See if we need to timeout
		if (downloadStartedAt && timeOutSeconds > 0 && [now timeIntervalSinceDate:downloadStartedAt] > timeOutSeconds) {
			DLog(@"timeout at url: %@", self.url); 
			doneUploading = YES;
		}
		
		if ([self isCancelled])
		{
			DLog(@"canceled at url: %@", self.url); 
			doneUploading = YES;
		}
		
		CFNumberRef cfSize = CFReadStreamCopyProperty(_readStream, kCFStreamPropertyHTTPRequestBytesWrittenCount);
		CFNumberGetValue(cfSize, kCFNumberLongType, &bytesWritten);
		CFRelease(cfSize);
		cfSize = NULL;
		
		if (bytesWritten > previousBytesWritten) {
			previousBytesWritten = bytesWritten;
		}
		
		if (!CFReadStreamHasBytesAvailable(_readStream)) {
			usleep(3600);
			continue;
		}
		
		numBytesRead = CFReadStreamRead(_readStream, buf, 1024);
		if (numBytesRead < 1024)
			buf[numBytesRead] = 0;      
		[responseData appendBytes:buf length:numBytesRead];
		
		[self.tmpFileHandle writeData:responseData];
		
		if (CFReadStreamGetStatus(_readStream) == kCFStreamStatusAtEnd) doneUploading = YES;
	}
	
	CFHTTPMessageRef headers = (CFHTTPMessageRef)CFReadStreamCopyProperty(_readStream, kCFStreamPropertyHTTPResponseHeader);
	if (headers) {
		if (CFHTTPMessageIsHeaderComplete(headers)) {
			CFDictionaryRef responseHeaders = CFHTTPMessageCopyAllHeaderFields(headers);
			self.responseStatusCode = CFHTTPMessageGetResponseStatusCode(headers);
			CFRelease(responseHeaders);
			responseHeaders = NULL;
			//DLog(@"response status code: %d for url: %@", responseStatusCode, self.url);
			//    
			//    // Handle cookies
			//    NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:responseHeaders forURL:url];
			//    //[self setResponseCookies:cookies];
			//    [responseHeaders release];
			//    
			//    // Store cookies in global persistent store
			//    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:cookies forURL:url mainDocumentURL:nil];
		}
		CFRelease(headers);
		headers = NULL;
	}
	
	CFReadStreamClose(_readStream);
	CFRelease(_request);
	_request = NULL;
	CFRelease(_readStream);
	_readStream = NULL;
	// end new way
	
	return [NSData dataWithContentsOfMappedFile:self.tmpFilePath];
}

- (NSData *)tidyData:(NSData *)responseData
{
	//tidy
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
	NSString *tidyText;
	// use a FRESH TidyDocument each time to cover up some issues with it.
	TidyDoc newTidy = tidyCreate();    // this is the TidyDoc will will really process. Eventually will be prefDoc.
	//tidyOptCopyConfig( newTidy, prefDoc );  // put our preferences into the working copy newTidy.
	
	// setup the output buffer to copy to an NSString instead of writing to stdout
	TidyBuffer *outBuffer = malloc(sizeof(TidyBuffer));
	tidyBufInit( outBuffer );
	
	// setup the error buffer to catch errors here instead of stdout
	tidyOptSetBool( newTidy, TidyXhtmlOut, yes );
	tidySetAppData( newTidy, (uint*)self );          // so we can send a message from outside ourself to ourself.
	//tidySetReportFilter( newTidy, (TidyReportFilter)&tidyCallbackFilter);  // the callback will go to this out-of-class C function.
	//[errorArray removeAllObjects];            // clear out all of the previous errors.
	TidyBuffer *errBuffer = malloc(sizeof(TidyBuffer));        // allocate a buffer for our error text.
	tidyBufInit( errBuffer );              // init the buffer.
	tidySetErrorBuffer( newTidy, errBuffer );          // and let tidy know to use it.
	
	// parse the workingText and clean, repair, and diagnose it.
	//tidyOptSetValue( newTidy, TidyCharEncoding, [@"utf8" cString] );          // set all internal char-encoding to UTF8.
	//tidyOptSetValue( newTidy, TidyInCharEncoding, [@"utf8" cString] );          // set all internal char-encoding to UTF8.
	//tidyOptSetValue( newTidy, TidyOutCharEncoding, [@"utf8" cString] );          // set all internal char-encoding to UTF8.
	//    tidyParseBuffer(newTidy, (void*)[[workingText dataUsingEncoding:NSUTF8StringEncoding] bytes]);  // parse the original text into the TidyDoc  
	tidyParseString(newTidy, [responseData bytes]);              // parse the original text into the TidyDoc  
	tidyCleanAndRepair( newTidy );                  // clean and repair
	tidyRunDiagnostics( newTidy );                  // runs diagnostics on the document for us.
	
	// save the tidy'd text to an NSString
	tidySaveBuffer( newTidy, outBuffer );        // save it to the buffer we set up above.
	//[tidyText release];              // release the current tidyText.
	if (outBuffer->size > 0) {            // case the buffer to an NSData that we can use to set the NSString.
		tidyText = [[NSString alloc] initWithCString:(const char *)outBuffer->bp];  // make a string from the data.
	} else
		tidyText = @"";              // set to null string -- no output.
	
	// give the Tidy general info at the bottom.
	tidyErrorSummary (newTidy);
	tidyGeneralInfo( newTidy );
	
	// copy the error buffer into an NSString -- the errorArray is built using
	// callbacks so we don't need to do anything at all to build it right here.
	//[errorText release];
	//    if (errBuffer->size > 0) {
	//      errorText =[[NSString alloc] initWithCString:(const char *)errBuffer->bp];
	//    } else {
	//      errorText = @"";
	//    }
	//[errorText release];
	
	
	tidyBufFree(outBuffer);    // free the output buffer.
	tidyBufFree(errBuffer);    // free the error buffer.
	free(outBuffer);
	free(errBuffer);
	tidyRelease(newTidy);
	[pool release];
	
	[_tmpFileHandle truncateFileAtOffset: 0];
	
	NSData *aData = [tidyText dataUsingEncoding:NSUTF8StringEncoding];
	
	[_tmpFileHandle writeData: aData];
	
	[tidyText release];
	
	return [NSData dataWithContentsOfMappedFile:self.tmpFilePath];
}

#pragma mark -
#pragma mark NSXMLParser Delegate:

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    DLog(@"Error %i, Description: %@, Line: %i, Column: %i", [parseError code],[[parser parserError] localizedDescription], [parser lineNumber],[parser columnNumber]);
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	
}

#pragma mark -
#pragma mark If Operation Not Cancelled Send The Resut To The Associated Taarget:

- (void)performSelectorWithDictionary:(NSDictionary *)aDict
{
	if (![self isCancelled])
	{
		// user cancelled this operation
		[target performSelectorOnMainThread:action
								 withObject:aDict
							  waitUntilDone:NO
									  modes:[NSArray arrayWithObject:NSDefaultRunLoopMode]];
		
	}
	self.peformedSelectorOnce = TRUE;
}

// Permits to retrive the path for the given file on the application ressources dir
- (NSString *)bundlePathForRessource:(NSString *)aRessource ofType:(NSString *)aType
{
	NSBundle *bundle = [NSBundle mainBundle];
	NSString *path = [bundle pathForResource:aRessource ofType:aType];
	return path;
}

#pragma mark -
#pragma mark Dealloc:

- (void)dealloc
{
	[_tmpFileHandle release];
	[_tmpFilePath release];
	[accept release];
	[contentType release];
	[user release];
	[password release];
	[url release];
	[target release];
	[infoDictionary release];
	[bodyData release];
	[requestMethod release];
	
	[super dealloc];
}

@end
