//
//  SearchParseMoreInfosAgencyOperation.m
//  ozEstate
//
//  Created by Anthony Mittaz on 11/08/08.
//  Copyright 2008 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
// 

#import "SearchParseMoreInfosAgencyOperation.h"


@implementation SearchParseMoreInfosAgencyOperation

@synthesize nextBalise, nextKey, nexElementName, takeText, previousBalise, houseAttributeName, shouldGoInside, previousHouseAttributeName, takeHouseAttributeName;

@synthesize agencyID;

@synthesize elementWhereTakeText;

- (void)main
{
	if ([self isCancelled])
	{
		return;	// user cancelled this operation
	}
	
	
	NSData *responseData = [self downloadUrl];
	
	BOOL fetchAndParseSuccessful = FALSE;
	
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
				// Youpi
				fetchAndParseSuccessful = TRUE;
			}
		}
	}
	[currentDict setObject:[NSNumber numberWithBool:fetchAndParseSuccessful] forKey:@"fetchAndParseSuccessful"];
	[currentDict setValue:agencyID forKey:@"agencyID"];
	[self performSelectorWithDictionary:currentDict];
}


- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    DLog(@"Error %i, Description: %@, Line: %i, Column: %i", [parseError code],[[parser parserError] localizedDescription], [parser lineNumber],[parser columnNumber]);
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	if (!currentDict && [elementName isEqualToString:@"dl"]) {
		if ([attributeDict objectForKey:@"class"]) {
			if ([[attributeDict objectForKey:@"class"]isEqualToString:@"contactDetails"]) {
				if (!currentDict) {
					currentDict = [[NSMutableDictionary alloc]initWithCapacity:0];
					self.nexElementName = @"dt";
					self.nextKey = @"id";
					self.nextBalise = @"agentAddressT";
				}
			}
		}
	} else {
		if (!self.houseAttributeName){
			if ([elementName isEqualToString:self.nexElementName]) {
				if (self.nextKey) {
					if ([attributeDict objectForKey:self.nextKey] && [[attributeDict objectForKey:self.nextKey]isEqualToString:self.nextBalise]) {
						if ([self.nextBalise isEqualToString:@"agentAddressT"]) {
							self.nexElementName = @"dt";
							self.nextKey = @"id";
							self.nextBalise = @"agentTelT";
							self.houseAttributeName = @"street";
						} else if ([self.nextBalise isEqualToString:@"agentTelT"]) {
							self.nexElementName = @"dt";
							self.nextKey = @"id";
							self.nextBalise = @"agentFaxT";
							self.houseAttributeName = @"phone";
						} else if ([self.nextBalise isEqualToString:@"agentFaxT"]) {
							self.nexElementName = nil;
							self.nextKey = nil;
							self.nextBalise = nil;
							self.houseAttributeName = @"fax";
						}
					}
				}
			}
		} else {
			self.takeText = TRUE;
		}
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if (self.takeText) {
		if ([houseAttributeName isEqualToString:@"street"]) {
			[currentDict setValue:string forKey:houseAttributeName];
			self.houseAttributeName = @"suburb";
		} else if ([houseAttributeName isEqualToString:@"phone"] || [houseAttributeName isEqualToString:@"fax"]) {
			NSString *aNumber = @"";
			NSCharacterSet *digits = [NSCharacterSet decimalDigitCharacterSet];
			NSMutableString *originalWord = [string mutableCopy];
			NSRange r = [originalWord rangeOfCharacterFromSet:digits];
			while (r.location != NSNotFound) {
				aNumber = [aNumber stringByAppendingString:[originalWord substringWithRange:r]];
				[originalWord deleteCharactersInRange:r];
				r = [originalWord rangeOfCharacterFromSet:digits];
			}
			[originalWord release];
			
			if (aNumber) {
				[currentDict setValue:aNumber forKey:houseAttributeName];
			}
			self.houseAttributeName = nil;
			self.takeText = FALSE;
		} else if ( [houseAttributeName isEqualToString:@"suburb"]) {
			NSString *aZip = @"";
			NSCharacterSet *digits = [NSCharacterSet decimalDigitCharacterSet];
			NSMutableString *originalWord = [string mutableCopy];
			NSRange r = [originalWord rangeOfCharacterFromSet:digits];
			while (r.location != NSNotFound) {
				aZip = [aZip stringByAppendingString:[originalWord substringWithRange:r]];
				[originalWord deleteCharactersInRange:r];
				r = [originalWord rangeOfCharacterFromSet:digits];
			}
			[originalWord release];
			
			if (aZip) {
				[currentDict setValue:aZip forKey:@"zip"];
			}
			
			string = [string stringByReplacingOccurrencesOfString:aZip withString:@""];
			string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			
			[currentDict setValue:string forKey:houseAttributeName];
			
			self.houseAttributeName = nil;
			self.takeText = FALSE;
		}
	}
}

- (void)dealloc
{
	[elementWhereTakeText release];
	[nexElementName release];
	[nextKey release];
	[nextBalise release];
	[previousBalise release];
	[houseAttributeName release];
	[previousHouseAttributeName release];
	[agencyID release];
	[currentDict release];
	
	[super dealloc];
}

@end
