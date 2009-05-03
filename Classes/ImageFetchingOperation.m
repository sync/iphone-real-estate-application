//
//  SpotImageFetchingOperation.m
//  ozEstate
//
//  Created by Anthony Mittaz on 27/09/08.
//  Copyright 2008 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import "ImageFetchingOperation.h"
#import "RegexKitLite.h"


@implementation ImageFetchingOperation

@synthesize rowId=_rowId;
@synthesize rowName=_rowName;
@synthesize wantedSize=_wantedSize;
@synthesize cellView=_cellView;


#pragma mark -
#pragma mark This Is Where The Download And Processing Append:

// By the way the is a reason why this method 
// is not spitted into multiple files
- (void)main
{
	if ([self isCancelled])
	{
		return;	// user cancelled this operation
	}
	
	BOOL fetchAndParseSuccessful = FALSE;
	
	NSData *responseData = [self downloadUrl];
	
	if ([responseData length] != 0)  {
		
		UIImage *testImage = [UIImage imageWithData:responseData];
		if (!testImage) {
			/*
			 <html>
			 <head>
			 <META HTTP-EQUIV='refresh' content="0;URL=http://203.17.253.5/objects/props/5837/403775837ms1234805640.jpg" />
			 <title>Page Has Temporarily Moved</title></head>
			 <body>
			 <a href="http://203.17.253.5/objects/props/5837/403775837ms1234805640.jpg">Page Has Temporarily Moved Here</a></body>
			 <html>
			 */
			// It is most likely to be a redirection issue
			NSString *aRegexString = @"href=\"(.*?)\"";
			
			NSString *htmlRedirect = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
			
			NSRange   aRange = NSMakeRange(NSNotFound, 0);
			aRange = [htmlRedirect rangeOfRegex:aRegexString options:RKLCaseless inRange:NSMakeRange(0, [htmlRedirect length]) capture:1 error:nil];
			
			NSString *newUrlString = [htmlRedirect substringWithRange:aRange];
			newUrlString = [htmlRedirect substringWithRange:aRange];
			
			self.url = [NSURL URLWithString:newUrlString];
			[htmlRedirect release];
			
			responseData = [self downloadUrl];
		}

		
//		if (!CGSizeEqualToSize(self.wantedSize,CGSizeZero)) {
//			UIImage *thumbnail = [UIImage imageWithData:responseData];
//			if (thumbnail && !CGSizeEqualToSize(thumbnail.size,CGSizeZero)) {
//				thumbnail = [thumbnail _imageScaledToSize:self.wantedSize interpolationQuality:0.1];
//				responseData =  UIImageJPEGRepresentation(thumbnail, 0.5);
//			}
//		}
		fetchAndParseSuccessful = TRUE;
	}
	
	NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithCapacity:0];
	[tempDict setObject:[NSNumber numberWithBool:fetchAndParseSuccessful] forKey:@"fetchAndParseSuccessful"];
	[tempDict setValue:self.rowId forKey:@"rowId"];
	[tempDict setValue:self.rowName forKey:@"rowName"];
	[tempDict setValue:responseData forKey:@"image"];
	[tempDict setValue:self.cellView forKey:@"cellView"];
	
	[self performSelectorWithDictionary:[NSDictionary dictionaryWithDictionary:tempDict]];
	
}

#pragma mark -
#pragma mark Dealloc:

- (void)dealloc
{	
	[_cellView release];
	[_rowId release];
	[_rowName release];
	
	[super dealloc];
}

@end
