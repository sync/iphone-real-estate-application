//
//  SearchParseMoreImagesOperation.m
//  ozEstate
//
//  Created by Anthony Mittaz on 13/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import "SearchParseMoreImagesOperation.h"
#import "RegexKitLite.h"

@implementation SearchParseMoreImagesOperation

@synthesize URLMoreHouseImages;
@synthesize isMain;

@synthesize nextBalise, nextKey, nexElementName, takeText, previousBalise, houseAttributeName, shouldGoInside, previousHouseAttributeName, takeHouseAttributeName;

@synthesize houseID, currentLetter;

@synthesize wantedSize=_wantedSize;

- (id)initWithURL:(NSURL *)anUrl target:(id)aTarget action:(SEL)anAction needRefreshInterface:(BOOL)aNeedRefreshInterface infoDictionary:(NSDictionary *)anInfoDictionary
{
	retryCount = 0;
	return [super initWithURL:anUrl target:aTarget action:anAction needRefreshInterface:aNeedRefreshInterface infoDictionary:anInfoDictionary];
}

- (void)main
{
	if ([self isCancelled])
	{
		return;	// user cancelled this operation
	}
	
	BOOL fetchAndParseSuccessful = FALSE;
	
	fetchAndParseSuccessful = [self downloadAndParseData];
	
	if (fetchAndParseSuccessful) {
		DLog(@"success");
	} else {
		DLog(@"fail");
		fetchAndParseSuccessful = [self downloadAndParseData];
		if (fetchAndParseSuccessful) {
			DLog(@"success");
		} else {
			DLog(@"fail");
			fetchAndParseSuccessful = [self downloadAndParseData];
			if (fetchAndParseSuccessful) {
				DLog(@"success");
			} else {
				DLog(@"fail");
			}
		}
	}
	
//	while (![self downloadAndParseData]) {
//		DLog(@"while loop running...");
//	}
		
	[currentDict setObject:[NSNumber numberWithBool:fetchAndParseSuccessful] forKey:@"fetchAndParseSuccessful"];
	[currentDict setObject:currentLetter forKey:@"currentLetter"];
	[currentDict setObject:[NSNumber numberWithBool:isMain] forKey:@"isMain"];
	[currentDict setObject:[NSNumber numberWithBool:FALSE] forKey:@"preview"];
	[currentDict setObject:self.houseID forKey:@"houseID"];
	[self performSelectorWithDictionary:[NSDictionary dictionaryWithDictionary:currentDict]];
}

- (BOOL)downloadAndParseData
{
	DLog(@"loading url: %@", self.url);
	NSData *responseData = [self downloadUrl];
	
	if ([responseData length] != 0)  {
		
		NSData *tidyData = [self tidyData:responseData];
		
		if (![self isCancelled])
		{
			BOOL success;
			NSXMLParser *anXMLParser = [[[NSXMLParser alloc] initWithData:tidyData]autorelease];
			//anXMLParser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL fileURLWithPath:@"/Users/aspeed/Desktop/NewEssaiNew.xhtml"]];
			[anXMLParser setDelegate:self];
			[anXMLParser setShouldProcessNamespaces:NO];
			[anXMLParser setShouldReportNamespacePrefixes:NO];
			[anXMLParser setShouldResolveExternalEntities:NO];
			self.takeText = FALSE;
			self.houseAttributeName = nil;
			self.shouldGoInside = FALSE;
			self.takeHouseAttributeName = FALSE;
			self.previousBalise = nil;
			success = [anXMLParser parse]; // return value not used
			if (success) {
				NSString *mediumURL = nil;
				for (NSString *urlString in URLMoreHouseImages) {
					[currentDict setObject:urlString forKey:@"url"];
					
					if (![urlString hasSuffix:@".gif"]) {
						NSString *aRegexString = @"[0-9]+([a-zA-Z]+)[0-9]+";
						
						NSRange   aRange = NSMakeRange(NSNotFound, 0);
						aRange = [urlString rangeOfRegex:aRegexString options:RKLCaseless inRange:NSMakeRange(0, [urlString length]) capture:1 error:nil];
						
						mediumURL = [urlString stringByReplacingCharactersInRange:aRange withString:[NSString stringWithFormat:@"%@m", currentLetter]];
						
						if (aRange.location != NSNotFound) {
						} else {
							DLog(@"begin range not fund");
							DLog(@"urlbig: %@ \n urlMedium: %@", urlString, mediumURL);
							DLog(@"end range not fund");
						}
					} else {
						DLog(@"%@", self.url);
					}
				}
				if (mediumURL) {
					[currentDict setObject:mediumURL forKey:@"url"];
				}
			} else {
				return FALSE;
			}
			
			// download image
			if ([currentDict valueForKey:@"url"]) {
				self.url = [NSURL URLWithString:[currentDict valueForKey:@"url"]];
				
				NSData *imageData = [self downloadUrl];
				if (imageData) {
					UIImage *testImage = [UIImage imageWithData:imageData];
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
						
						imageData = [self downloadUrl];
					}
					
					if ([[currentDict valueForKey:@"url"] hasSuffix:@".jpeg"] || [[currentDict valueForKey:@"url"] hasSuffix:@".jpg"]) {
						if (!CGSizeEqualToSize(self.wantedSize,CGSizeZero)) {
							UIImage *thumbnail = [UIImage imageWithData:imageData];
							if (thumbnail && !CGSizeEqualToSize(thumbnail.size,CGSizeZero)) {
								thumbnail = [thumbnail _imageScaledToSize:self.wantedSize interpolationQuality:0.3];
								imageData =  UIImageJPEGRepresentation(thumbnail, 0.3);
								if (!imageData) {
									DLog(@"url of empty image: %@", self.url);
								}
							}
						}
					}
					
					[currentDict setObject:[NSData dataWithData:imageData] forKey:@"data"];
					return TRUE;
				}
			}
			
		}
		return FALSE;
	}
	return FALSE;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    DLog(@"Error %i, Description: %@, Line: %i, Column: %i", [parseError code],[[parser parserError] localizedDescription], [parser lineNumber],[parser columnNumber]);
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	if (!currentDict && [elementName isEqualToString:@"li"]) {
		if ([attributeDict objectForKey:@"id"]) {
			if ([[attributeDict objectForKey:@"id"]isEqualToString:@"photoNextIm"]) {
				if (!currentDict) {
					currentDict = [[NSMutableDictionary alloc]initWithCapacity:0];
					self.nexElementName = @"div";
					self.nextKey = @"id";
					self.nextBalise = @"photoContentAUNZ";
					//[currentDict setObject:self.currentHouse.houseID forKey:@"houseID"];
					URLMoreHouseImages = [[NSMutableArray alloc]initWithCapacity:0];
				}
			} else if ([[attributeDict objectForKey:@"id"]isEqualToString:@"photoNextImGrey"]) {
				if (!currentDict) {
					currentDict = [[NSMutableDictionary alloc]initWithCapacity:0];
					self.nexElementName = @"div";
					self.nextKey = @"id";
					self.nextBalise = @"photoContentAUNZ";
					//[currentDict setObject:self.currentHouse.houseID forKey:@"houseID"];
					[currentDict setValue:[NSNumber numberWithBool:FALSE] forKey:@"goNextLetter"];
					URLMoreHouseImages = [[NSMutableArray alloc]initWithCapacity:0];
				}
			}
		}
	} else {
		if (!self.houseAttributeName){
			if ([elementName isEqualToString:self.nexElementName]) {
				if ([self.nextBalise isEqualToString:@"photoContentAUNZ"]) {
					self.nexElementName = @"img";
					self.nextKey = nil;
					self.nextBalise = nil;
					//self.houseAttributeName = @"URLBigImageString";
				} else if ([self.nexElementName isEqualToString:@"img"]) {
					self.nexElementName = nil;
					self.nextKey = nil;
					self.nextBalise = nil;
					if ([attributeDict objectForKey:@"src"]) {
						[URLMoreHouseImages addObject:[attributeDict objectForKey:@"src"]];
						//[currentDict setObject:[attributeDict objectForKey:@"src"] forKey:@"URLMoreImageString"];
						//[currentHouse setValue:[attributeDict objectForKey:@"src"] forKey:@"URLImageString"];
					}
				}
			}  else if ([elementName isEqualToString:@"a"] && [attributeDict valueForKey:@"title"] && [[attributeDict valueForKey:@"title"]isEqualToString:@"Next Image"]) {
				[currentDict setValue:[NSNumber numberWithBool:TRUE] forKey:@"goNextLetter"];
				// get next letter
				// http://www.realestate.com.au/cgi-bin/rsearch?a=depi&id=105553341&width=&height=&img=floorplan-1&t=res
				NSString *aRegexString = @"&img=(.*?)&";
				
				NSString *href = [attributeDict valueForKey:@"href"];
				
				NSRange   aRange = NSMakeRange(NSNotFound, 0);
				aRange = [href rangeOfRegex:aRegexString options:RKLCaseless inRange:NSMakeRange(0, [href length]) capture:1 error:nil];
				
				NSString *nextLetter = [href substringWithRange:aRange];
				
				[currentDict setValue:nextLetter  forKey:@"nextLetter"];
			}
		} else {
			self.takeText = TRUE;
		}
	}
}

- (void)dealloc
{
	[nexElementName release];
	[nextKey release];
	[nextBalise release];
	[previousBalise release];
	[houseAttributeName release];
	[previousHouseAttributeName release];
	[houseID release];
	[currentDict release];
	[currentLetter release];
	[URLMoreHouseImages release];
	
	[super dealloc];
}

@end