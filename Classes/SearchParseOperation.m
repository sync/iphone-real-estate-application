//
//  SearchParseOperation.m
//  ozEstate
//
//  Created by Anthony Mittaz on 18/06/08.
//  Copyright 2008 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import "SearchParseOperation.h"
#import "RegexKitLite.h"



@implementation SearchParseOperation

@synthesize numberHousesAdded;
@synthesize state;

@synthesize nextBalise, nextKey, nexElementName, takeText, previousBalise, houseAttributeName, shouldGoInside;

@synthesize minBathroom, maxBathroom;
@synthesize minGarage, maxGarage;

@synthesize streetAbbreviations;
@synthesize ifSkippedHouseAttributeName,ifSkippedElementName;

@synthesize properties=_properties;

@synthesize elementWhereTakeText;

- (void)loadAbbreviation
{
	if (!streetAbbreviations) {
		streetAbbreviations = [[NSMutableSet alloc]initWithCapacity:0];
		
		NSString *aString = [[NSString alloc]initWithContentsOfFile:[self bundlePathForRessource:@"Street_Abbreviation" ofType:@"txt"]];
		NSArray *suburbsArray = [aString componentsSeparatedByString:@"\n"];
		for (NSString *abString in suburbsArray) {
			NSArray *anotherArray = [abString componentsSeparatedByString:@","];
			if ([anotherArray count] >= 3) {
				NSDictionary *aDict = [[NSDictionary alloc]initWithObjects:[NSArray arrayWithObjects:[anotherArray objectAtIndex:0], [anotherArray objectAtIndex:1], [anotherArray objectAtIndex:2],nil] forKeys:[NSArray arrayWithObjects:@"string", @"abbreviation1", @"abbreviation2", nil]];
				[streetAbbreviations addObject:aDict];
				[aDict release];
			}
		}
		[aString release];
	}
}



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
			[anXMLParser setDelegate:self];
			[anXMLParser setShouldProcessNamespaces:NO];
			[anXMLParser setShouldReportNamespacePrefixes:NO];
			[anXMLParser setShouldResolveExternalEntities:NO];
			self.takeText = FALSE;
			self.houseAttributeName = nil;
			self.shouldGoInside = FALSE;
			houseAdded = FALSE;
			canSkipNextElementNameTest = FALSE;
			self.previousBalise = nil;
			canGoNext = FALSE;
			self.properties = [NSMutableArray arrayWithCapacity:0];
			success = [anXMLParser parse]; // return value not used
			if (success) {
				// everyone's happy loading loading view
				fetchAndParseSuccessful = TRUE;
			}
		}
	}
	
	NSMutableDictionary *dictToSend = [NSMutableDictionary dictionaryWithCapacity:0];
	[dictToSend setObject:[NSNumber numberWithBool:fetchAndParseSuccessful] forKey:@"fetchAndParseSuccessful"];
	[dictToSend setValue:[NSNumber numberWithBool:houseAdded] forKey:@"houseAdded"];
	[dictToSend setValue:[NSArray arrayWithArray:self.properties] forKey:@"properties"];
	[dictToSend setValue:[NSNumber numberWithBool:canGoNext] forKey:@"canGoNext"];
	[self performSelectorWithDictionary:dictToSend];
	
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    DLog(@"Error %i, Description: %@, Line: %i, Column: %i", [parseError code],[[parser parserError] localizedDescription], [parser lineNumber],[parser columnNumber]);
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	if (currentDict  && canSkipNextElementNameTest && [elementName isEqualToString:@"h5"]) {
		self.ifSkippedElementName = nil;
		self.ifSkippedHouseAttributeName = nil;
		canSkipNextElementNameTest = FALSE;
	}
	
	if (!currentDict && [elementName isEqualToString:@"div"]) {
		if ([attributeDict objectForKey:@"class"]) {
			if ([[attributeDict objectForKey:@"class"]isEqualToString:@"propOverview"] || 
				[[attributeDict objectForKey:@"class"]isEqualToString:@"propOverview featureProperty"]) {
				if (!currentDict && canStartParsing) {
					if (!currentDict) {
						currentDict = [[NSMutableDictionary alloc]initWithCapacity:0];
					}
					self.nexElementName = @"div";
					self.nextKey = @"class";
					self.nextBalise = @"header";
				}
			} else if ([[attributeDict objectForKey:@"class"]isEqualToString:@"message error"]) {
				self.nexElementName = nil;
				self.nextKey = nil;
				self.nextBalise = nil;
				//[anXMLParser abortParsing];
			}
		} else if ([attributeDict objectForKey:@"id"]) {
			if ([[attributeDict objectForKey:@"id"]isEqualToString:@"searchResults"]) {
				canStartParsing = TRUE;
			}
		}
	} else if (!currentDict && [elementName isEqualToString:@"li"]) {
		if ([attributeDict objectForKey:@"class"]) {
			if ([[attributeDict objectForKey:@"class"]isEqualToString:@"next"]) {
				canGoNext = TRUE;
			}
		}
	} else if (currentDict && [elementName isEqualToString:(!canSkipNextElementNameTest)?self.nexElementName:self.ifSkippedElementName]) {
		if (!self.houseAttributeName){
			if (([attributeDict objectForKey:self.nextKey] &&[[attributeDict objectForKey:self.nextKey]isEqualToString:self.nextBalise]) || self.shouldGoInside){
				if ([self.nextBalise isEqualToString:@"header"]) {
					self.nexElementName = @"h2";
					self.nextKey = nil;
					self.nextBalise = nil;
					self.houseAttributeName = @"suburb";
				} else if ([self.nextBalise isEqualToString:@"beds"]) {
					self.nexElementName = @"dd";
					self.nextKey = nil;
					self.nextBalise = nil;
					self.houseAttributeName = @"bedroom";
				} else if ([self.nextBalise isEqualToString:@"baths"]) {
					self.nexElementName = @"dd";
					self.nextKey = nil;
					self.nextBalise = nil;
					self.houseAttributeName = @"bathroom";
				} else if ([self.nextBalise isEqualToString:@"cars"]) {
					self.nexElementName = @"dd";
					self.nextKey = nil;
					self.nextBalise = nil;
					self.houseAttributeName = @"garage";
				} else if ([self.nextBalise isEqualToString:@"content"]) {
					self.nexElementName = @"a";
					self.nextKey = @"class";
					self.nextBalise = @"photo";
				} else if ([self.nextBalise isEqualToString:@"photo"]) {
					self.nexElementName = @"img";
					self.nextKey = nil;
					self.nextBalise = nil;
					self.shouldGoInside = TRUE;
					if ([attributeDict objectForKey:@"href"]) {
						[currentDict setValue:[attributeDict objectForKey:@"href"] forKey:@"websiteLink"];
						for (NSString *aString in [[attributeDict objectForKey:@"href"] componentsSeparatedByString:@"&"]) {
							for (NSString *secondString in [aString componentsSeparatedByString:@"="]) {
								if ([secondString isEqualToString:@"id"]) {
									NSString *houseID = [[aString componentsSeparatedByString:@"="]objectAtIndex:1];
									[currentDict setValue:houseID forKey:@"houseID"];
									break;
								}
							}
						}
						//NSString *houseID = [[[[[attributeDict objectForKey:@"href"] componentsSeparatedByString:@"&"]objectAtIndex:1]componentsSeparatedByString:@"="]objectAtIndex:1];
						
					}
				} else if ([self.nexElementName isEqualToString:@"img"]) {
					self.nexElementName = @"h4";
					self.nextKey = nil;
					self.nextBalise = nil;
					self.houseAttributeName = @"title";
					self.shouldGoInside = FALSE;
					if ([attributeDict objectForKey:@"src"]) {
						[currentDict setValue:[attributeDict objectForKey:@"src"] forKey:@"URLImageString"];
					}
				}
			}
		} else {
			self.takeText = TRUE;
			self.elementWhereTakeText = elementName;
		}
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if (self.takeText) {
		id previousString = [currentDict valueForKey:self.houseAttributeName];
		if (previousString && [NSStringFromClass([previousString class])isEqual:@"NSCFString"]) {
			if (!previousString) {
				previousString = @"";
			} else {
				string = [previousString stringByAppendingString:string];
			}
		}
		
		if (![self.ifSkippedHouseAttributeName isEqualToString:@"shortDescription"]) {
			if ([houseAttributeName isEqualToString:@"price"] && ![string isEqualToString:@""] && ![string isEqualToString:@"\n"]) {
				//NSString * myString; // derived from NSTextView content
				NSRange dollarsR = [string rangeOfString:@"$"];
				if (dollarsR.location != NSNotFound) {
					string = [string substringWithRange:NSMakeRange(dollarsR.location, [string length]-dollarsR.location)];
				}
				NSRange floatR = [string rangeOfString:@"."];
				if (floatR.location != NSNotFound) {
					string = [string substringWithRange:NSMakeRange(0, floatR.location)];
				}
				NSArray *pricesFromRange = [string componentsSeparatedByString:@"-"];
				NSInteger i=0;
				if ([pricesFromRange count] >= 2) {
					for (NSString *aString in [NSArray arrayWithObjects:[pricesFromRange objectAtIndex:0], [pricesFromRange objectAtIndex:1], nil]) {
						NSString *aPrice = @"";
						NSCharacterSet *digits = [NSCharacterSet decimalDigitCharacterSet];
						NSMutableString *originalWord = [aString mutableCopy];
						NSRange r = [originalWord rangeOfCharacterFromSet:digits];
						while (r.location != NSNotFound) {
							aPrice = [aPrice stringByAppendingString:[originalWord substringWithRange:r]];
							[originalWord deleteCharactersInRange:r];
							r = [originalWord rangeOfCharacterFromSet:digits];
						}
						[currentDict setValue:aPrice forKey:(i==0)? @"minPrice": @"maxPrice"];
						[originalWord release];
						i++;
					}
				} else {
					if (string) {
						NSString *aPrice = @"";
						NSCharacterSet *digits = [NSCharacterSet decimalDigitCharacterSet];
						NSMutableString *originalWord = [string mutableCopy];
						NSRange r = [originalWord rangeOfCharacterFromSet:digits];
						while (r.location != NSNotFound) {
							aPrice = [aPrice stringByAppendingString:[originalWord substringWithRange:r]];
							[originalWord deleteCharactersInRange:r];
							r = [originalWord rangeOfCharacterFromSet:digits];
						}
						[currentDict setValue:aPrice forKey:houseAttributeName];
						[originalWord release];
					}
				}
			} else if ([houseAttributeName isEqualToString:@"bedroom"] || [houseAttributeName isEqualToString:@"bathroom"] || [houseAttributeName isEqualToString:@"garage"]) {
				[currentDict setValue:string forKey:houseAttributeName];
			} else if ([houseAttributeName isEqualToString:@"street"]) {
				[self loadAbbreviation];
				if (string) {
					for (NSDictionary *aDict in streetAbbreviations) {
						string = [string stringByReplacingOccurrencesOfRegex:[NSString stringWithFormat:@"%@$", [aDict valueForKey:@"abbreviation1"]] withString:[aDict valueForKey:@"string"] options:RKLCaseless range:NSMakeRange(0, [string length]) error:nil];
						string = [string stringByReplacingOccurrencesOfRegex:[NSString stringWithFormat:@"%@$", [aDict valueForKey:@"abbreviation2"]] withString:[aDict valueForKey:@"string"] options:RKLCaseless range:NSMakeRange(0, [string length]) error:nil];
						
					}
				}
				[currentDict setValue:string forKey:houseAttributeName];
			} else if ([houseAttributeName isEqualToString:@"shortDescription"] || [houseAttributeName isEqualToString:@"title"]) {
				if (string) {
					for (NSString *aRegexString in [NSArray arrayWithObjects:@"^(\n)+", @"(\n)+$", nil]) {
						string = [string stringByReplacingOccurrencesOfRegex:aRegexString withString:@"" options:RKLCaseless range:NSMakeRange(0, [string length]) error:nil];
					}
					//NSString *essai = @"Essai artichaud";
					for (NSString *aRegexString in [NSArray arrayWithObjects:@"\n([a-z])",nil]) {
						string = [string stringByReplacingOccurrencesOfRegex:aRegexString withString:@" $1" options:RKLCaseless range:NSMakeRange(0, [string length]) error:nil];
					}
				}
				[currentDict setValue:string forKey:houseAttributeName];
			} else {
				[currentDict setValue:string forKey:self.houseAttributeName];
			}
		} else {
			[currentDict setValue:string forKey:self.ifSkippedHouseAttributeName];
		}
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if (self.elementWhereTakeText && [self.elementWhereTakeText isEqual:elementName]) {
		self.houseAttributeName = nil;
		self.takeText = FALSE;
	}
	
	if ([elementName isEqualToString:self.nexElementName] || canSkipNextElementNameTest) {
		if ([elementName isEqualToString:@"h2"]) {
			self.nexElementName = @"h3";
			self.nextKey = nil;
			self.nextBalise = nil;
			self.houseAttributeName = @"price";
			//Log(@"attributeDict: %@", attributeDict);
		} else if ([elementName isEqualToString:@"h3"]) {
			self.nexElementName = @"dt";
			self.nextKey = @"class";
			self.nextBalise = @"beds";
		} else if ([elementName isEqualToString:@"dd"]) {
			self.nexElementName = @"dt";
			self.nextKey = @"class";
			if (!self.previousBalise) { 
				self.nextBalise = @"baths";
			} else if ([self.previousBalise isEqualToString:@"baths"]) {
				self.nextBalise = @"cars";
			} else if ([self.previousBalise isEqualToString:@"cars"]) {
				self.nexElementName = @"div";
				self.nextKey = @"class";
				self.nextBalise = @"content";
			}
			self.previousBalise = self.nextBalise;
		} else if ([elementName isEqualToString:@"h4"]) {
			self.nexElementName = @"h5";
			self.nextKey = nil;
			self.nextBalise = nil;
			self.houseAttributeName = @"street";
			canSkipNextElementNameTest = TRUE;
			self.ifSkippedElementName = @"p";
			self.ifSkippedHouseAttributeName = @"shortDescription";
		} else if ([elementName isEqualToString:@"h5"]) {
			self.nexElementName = @"p";
			self.nextKey = nil;
			self.nextBalise = nil;
			self.houseAttributeName = @"shortDescription";
			self.ifSkippedHouseAttributeName = nil;
			canSkipNextElementNameTest = FALSE;
		} else if ([elementName isEqualToString:@"p"]) {
			canSkipNextElementNameTest = FALSE;
			self.ifSkippedHouseAttributeName = nil;
			self.nexElementName = nil;
			self.nextKey = nil;
			self.nextBalise = nil;
			
			//[currentDict setValue:[NSNumber numberWithBool:FALSE] forKey:@"favorite"];

			[currentDict setValue:self.state forKey:@"state"];
			[currentDict setValue:@"© realestate.com.au" forKey:@"copyright"];
			
			// Bathroom
			NSInteger houseBathrooms = [[currentDict valueForKey:@"bathroom"] integerValue];
			BOOL hasEnoughtBathroom = FALSE;
			if ((self.minBathroom?houseBathrooms >= [self.minBathroom integerValue]:TRUE) && (self.maxBathroom?houseBathrooms <= [self.maxBathroom integerValue]:TRUE)) {
				hasEnoughtBathroom = TRUE;
			}
			
			// Garage
			NSInteger houseGarages = [[currentDict valueForKey:@"garage"] integerValue];
			BOOL hasEnoughtGarage = FALSE;
			if ((self.minGarage?houseGarages >= [self.minGarage integerValue]:TRUE) && (self.maxGarage?houseGarages <= [self.maxGarage integerValue]:TRUE)) {
				hasEnoughtGarage = TRUE;
			}
			
			if (hasEnoughtBathroom && hasEnoughtGarage) {
				NSDictionary *dictToSend = [NSDictionary dictionaryWithDictionary:currentDict];
				[self.properties addObject:dictToSend];
				self.numberHousesAdded += 1;
				houseAdded = TRUE;
			}
			
			[currentDict removeAllObjects];
			[currentDict release];
			currentDict = nil;
			self.takeText = FALSE;
			self.houseAttributeName = nil;
			self.shouldGoInside = FALSE;
			self.previousBalise = nil;
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
	[minBathroom release];
	[maxBathroom release];
	[minGarage release];
	[maxGarage release];
	[streetAbbreviations release];
	[ifSkippedHouseAttributeName release];
	[ifSkippedElementName release];
	[state release];
	[_properties release];

	[super dealloc];
}

@end
