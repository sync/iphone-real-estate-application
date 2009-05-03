//
//  SearchParseMoreInfosOperation.m
//  ozEstate
//
//  Created by Anthony Mittaz on 28/06/08.
//  Copyright 2008 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#import "SearchParseMoreInfosOperation.h"
#import "RegexKitLite.h"


@implementation SearchParseMoreInfosOperation

@synthesize nextBalise, nextKey, nexElementName, takeText, previousBalise, houseAttributeName, shouldGoInside, previousHouseAttributeName, takeHouseAttributeName;

@synthesize houseID;

@synthesize elementWhereTakeText;

- (void)main
{
	if ([self isCancelled])
	{
		return;	// user cancelled this operation
	}
	
	NSData *responseData = [self downloadUrl];
//	NSString *responseString = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
//	NSLog(@"responseString: %@", responseString);
//	[responseString release];
	BOOL fetchAndParseSuccessful = FALSE;
	
	if ([responseData length] != 0)  {
		
		NSData *tidyData = [self tidyData:responseData];
//		NSString *tidyString = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
//		NSLog(@"tidyString: %@", tidyString);
//		tidyData = [tidyString dataUsingEncoding:NSUTF8StringEncoding];
//		[tidyString release];
		
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
				// Cool
				fetchAndParseSuccessful = TRUE;
			}
		}
	}
	
	[currentDict setObject:[NSNumber numberWithBool:fetchAndParseSuccessful] forKey:@"fetchAndParseSuccessful"];
	// get inspections array
	NSArray *inspectionTimes = [currentDict valueForKey:@"inspectionTimes"];
	[currentDict setValue:[inspectionTimes componentsJoinedByString:@", "] forKey:@"inspectionTimes"];
	[self performSelectorWithDictionary:currentDict];
}



- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    DLog(@"Error %i, Description: %@, Line: %i, Column: %i", [parseError code],[[parser parserError] localizedDescription], [parser lineNumber],[parser columnNumber]);
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	if (!currentDict && [elementName isEqualToString:@"div"]) {
		if ([attributeDict objectForKey:@"class"]) {
			if ([[attributeDict objectForKey:@"class"]isEqualToString:@"major"]) {
				if (!currentDict) {
					currentDict = [[NSMutableDictionary alloc]initWithCapacity:0];
					self.nexElementName = @"div";
					self.nextKey = @"class";
					self.nextBalise = @"majorImage";
					[currentDict setObject:self.houseID forKey:@"houseID"];
				}
			}
		}
	} else {
		if (!self.houseAttributeName){
			if ([elementName isEqualToString:self.nexElementName]) {
				if ([self.nextBalise isEqualToString:@"majorImage"]) {
					self.nexElementName = @"img";
					self.nextKey = nil;
					self.nextBalise = nil;
				} else if ([self.nexElementName isEqualToString:@"img"]) {
					self.nexElementName = @"div";
					self.nextKey = @"class";
					self.nextBalise = @"textual";
					if ([attributeDict objectForKey:@"src"]) {
						[currentDict setObject:[attributeDict objectForKey:@"src"] forKey:@"URLBigImageString"];
					}
				} else if ([self.nextBalise isEqualToString:@"textual"]) {
					self.nexElementName = @"h2";
					self.nextKey = nil;
					self.nextBalise = nil;
					self.houseAttributeName = @"title";
				} else if ([self.nexElementName isEqualToString:@"address"]) {
					self.nexElementName = @"div";
					self.nextKey = @"class";
					self.nextBalise = @"description";
					self.houseAttributeName = nil;
				} else if ([self.nexElementName isEqualToString:@"div"] && ([attributeDict valueForKey:@"class"] && [[attributeDict valueForKey:@"class"]isEqualToString:@"description"])) {
					self.nexElementName = nil;
					self.nextKey = nil;
					self.nextBalise =  nil;
					self.houseAttributeName = @"bigDescription";
					self.takeText = TRUE;
					self.elementWhereTakeText = elementName;
				}  else if ([self.nextBalise isEqualToString:@"inspectionTimes"]) {
					if ([attributeDict valueForKey:@"id"] && ![[attributeDict valueForKey:@"id"]isEqualToString:@"inspectionTimes"]) {
						self.nexElementName = @"dl";
						self.nextKey = nil;
						self.nextBalise = nil;
					} else {
						self.nexElementName = @"ul";
						self.nextKey = nil;
						self.nextBalise = nil;
					}
				} else if ([self.nexElementName isEqualToString:@"ul"]) {
					self.nexElementName = @"li";
					self.nextKey = nil;
					self.nextBalise = nil;
					self.houseAttributeName = @"inspectionTimes";
				} else if ([self.nextBalise isEqualToString:@"propertySummary"]) {
					self.nexElementName = @"dl";
					self.nextKey = nil;
					self.nextBalise = nil;
				} else if ([self.nexElementName isEqualToString:@"dl"]) {
					self.nexElementName = @"dt";
					self.nextKey = nil;
					self.nextBalise = nil;
				} else if ([self.nexElementName isEqualToString:@"dt"]) {
					self.nexElementName = @"dt";
					self.nextKey = nil;
					self.nextBalise = nil;
					self.takeHouseAttributeName = TRUE;
				} else if ([self.nexElementName isEqualToString:@"div"]) {
					if ([attributeDict valueForKey:@"id"] && [[attributeDict valueForKey:@"id"]isEqualToString:@"agentCollapsed"]) {
						self.nexElementName = @"a";
						self.nextKey = nil;
						self.nextBalise = nil;
					}
				} else if ([self.nexElementName isEqualToString:@"a"]) {
					if ([attributeDict objectForKey:@"href"]) {
						[currentDict setObject:[[attributeDict objectForKey:@"href"]lastPathComponent] forKey:@"agencyID"];
					}
					self.nexElementName = @"h4";
					self.nextKey = nil;
					self.nextBalise = nil;
				} else if ([self.nexElementName isEqualToString:@"h4"]) {
					self.nexElementName = nil;
					self.nextKey = nil;
					self.nextBalise = nil;
					self.houseAttributeName = @"agencyName";
				}
			}
		} else {
			self.takeText = TRUE;
			if (![elementName isEqualToString:@"br"] && ![elementName isEqualToString:@"span"]) {
				self.elementWhereTakeText = elementName;
			}
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
		
		if ([houseAttributeName isEqualToString:@"bigDescription"]) {
			if (string) {
				for (NSString *aRegexString in [NSArray arrayWithObjects:@"^(\n)+", @"(\n)+$", nil]) {
					string = [string stringByReplacingOccurrencesOfRegex:aRegexString withString:@"" options:RKLCaseless range:NSMakeRange(0, [string length]) error:nil];
				}
				for (NSString *aRegexString in [NSArray arrayWithObjects:@"\n([a-z])",nil]) {
					string = [string stringByReplacingOccurrencesOfRegex:aRegexString withString:@" $1" options:RKLCaseless range:NSMakeRange(0, [string length]) error:nil];
				}
			}
			[currentDict setObject:string forKey:houseAttributeName];
		} else if ([houseAttributeName isEqualToString:@"agencyName"]) {
			if (string) {
				for (NSString *aRegexString in [NSArray arrayWithObjects:@"^(\n)+", @"(\n)+$", nil]) {
					string = [string stringByReplacingOccurrencesOfRegex:aRegexString withString:@"" options:RKLCaseless range:NSMakeRange(0, [string length]) error:nil];
				}
				for (NSString *aRegexString in [NSArray arrayWithObjects:@"\n([a-z])",nil]) {
					string = [string stringByReplacingOccurrencesOfRegex:aRegexString withString:@" $1" options:RKLCaseless range:NSMakeRange(0, [string length]) error:nil];
				}
			}
			[currentDict setObject:string forKey:houseAttributeName];
		} else if ([houseAttributeName isEqualToString:@"inspectionTimes"]) {
			if (![string isEqualToString:@"\n"]) {
				NSMutableArray *inspectionTimes = [[NSMutableArray alloc]initWithCapacity:0];
				if ([currentDict valueForKey:@"inspectionTimes"]) {
					[inspectionTimes addObjectsFromArray:[currentDict valueForKey:@"inspectionTimes"]];
				}
				
				[inspectionTimes addObject:string];
				[currentDict setObject:inspectionTimes forKey:@"inspectionTimes"];
				[inspectionTimes release];
			}
		}else if ([houseAttributeName isEqualToString:@"availability"]) {
			if (![string isEqualToString:@"\n"]) {
				string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
				if (([[string lowercaseString] isEqualToString:@"monday"] || [[string lowercaseString] isEqualToString:@"tuesday"] || [[string lowercaseString] isEqualToString:@"wednesday"] || [[string lowercaseString] isEqualToString:@"thursday"] || [[string lowercaseString] isEqualToString:@"friday"] || [[string lowercaseString] isEqualToString:@"saturday"] || [[string lowercaseString] isEqualToString:@"sunday"])) {
					DLog(@"found: %@", string);
					// do nothing
				} else {
					NSDate *date;
					if ([[string lowercaseString] isEqualToString:@"now"]) {
						date = [NSDate date];
						[currentDict setValue:date forKey:self.houseAttributeName];
					} else { 
						
						//27-Sep-08
						NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc]init]autorelease];
						[dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
						[dateFormatter setDateFormat:@"d-MMM-yy"];
						
						date = [dateFormatter dateFromString:string];
						
						if (date) {
							[currentDict setValue:date forKey:self.houseAttributeName];
						} else {
							DLog(@"missed date: %@", string);
						}
						
						if (date) {
							[currentDict setValue:date forKey:self.houseAttributeName];
						} else {
							DLog(@"missed date: %@", string);
						}
					}
					DLog(@"availability: %@", string);
				}
			}
		} else if ([houseAttributeName isEqualToString:@"bond"]) {
			if (string && ![string isEqualToString:@""] && ![string isEqualToString:@"\n"]) {
				NSRange dollarsR = [string rangeOfString:@"$"];
				if (dollarsR.location != NSNotFound) {
					string = [string substringWithRange:NSMakeRange(dollarsR.location, [string length]-dollarsR.location)];
				}
				NSString *aPrice = @"";
				NSCharacterSet *digits = [NSCharacterSet decimalDigitCharacterSet];
				NSMutableString *originalWord = [string mutableCopy];
				NSRange r = [originalWord rangeOfCharacterFromSet:digits];
				while (r.location != NSNotFound) {
					aPrice = [aPrice stringByAppendingString:[originalWord substringWithRange:r]];
					[originalWord deleteCharactersInRange:r];
					r = [originalWord rangeOfCharacterFromSet:digits];
				}
				[currentDict setValue:[NSNumber numberWithInteger:[aPrice integerValue]] forKey:houseAttributeName];
				[originalWord release];
			}
		} else {
			[currentDict setObject:string forKey:houseAttributeName];
		}
	} else if (self.takeHouseAttributeName) {
		if ([string isEqualToString:@"Category:"]) {
			self.houseAttributeName = @"houseType";
			self.takeHouseAttributeName = FALSE;
		} else if ([string isEqualToString:@"Bedrooms:"]) {
			self.houseAttributeName = nil;
			self.takeHouseAttributeName = FALSE;
		} else if ([string isEqualToString:@"Bathrooms:"]) {
			self.houseAttributeName = nil;
			self.takeHouseAttributeName = FALSE;
		} else if ([string isEqualToString:@"Garage:"]) {
			self.houseAttributeName = nil;
			self.takeHouseAttributeName = FALSE;
		} else if ([string isEqualToString:@"Carport:"]) {
			self.houseAttributeName = nil;
			self.takeHouseAttributeName = FALSE;
		} else if ([string isEqualToString:@"Available:"]) {
			self.houseAttributeName = @"availability";
			self.takeHouseAttributeName = FALSE;
		} else if ([string isEqualToString:@"Bond:"]) {
			self.houseAttributeName = @"bond";
			self.takeHouseAttributeName = FALSE;
		} else if ([string isEqualToString:@"Land:"]) {
			self.houseAttributeName = @"land";
			self.takeHouseAttributeName = FALSE;
		} else if ([string isEqualToString:@"Close to:"]) {
			self.houseAttributeName = @"closeTo";
			self.takeHouseAttributeName = FALSE;
		} else if ([string isEqualToString:@"Features:"]) {
			self.houseAttributeName = @"features";
			self.takeHouseAttributeName = FALSE;
		} else if ([string isEqualToString:@"Municipality:"]) {
			self.houseAttributeName = @"municipality";
			self.takeHouseAttributeName = FALSE;
		} else if ([string isEqualToString:@"Energy Efficiency Rating:"]) {
			self.houseAttributeName = @"energyEfficiencyRating";
			self.takeHouseAttributeName = FALSE;
		} else if ([string isEqualToString:@"Building:"]) {
			self.houseAttributeName = @"building";
			self.takeHouseAttributeName = FALSE;
		}
		
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if (self.takeText && self.elementWhereTakeText && [self.elementWhereTakeText isEqual:elementName]) {
		self.previousHouseAttributeName = self.houseAttributeName;
		self.houseAttributeName = nil;
		self.takeText = FALSE;
	}
	
	if ([self.nexElementName isEqualToString:@"h2"] && [elementName isEqualToString:@"h2"]) {
		self.nexElementName = @"address";
		self.nextKey = nil;
		self.nextBalise = nil;
	} else if ([self.previousHouseAttributeName isEqualToString:@"bigDescription"] && [elementName isEqualToString:@"div"]) {
		self.nexElementName = @"div";
		self.nextKey = @"id";
		self.nextBalise = @"inspectionTimes";
	} else if ([self.previousHouseAttributeName isEqualToString:@"inspectionTimes"] && [elementName isEqualToString:@"li"]) {
		self.nexElementName = @"li";
		self.nextKey = nil;
		self.nextBalise = nil;
	} else if ( [self.previousHouseAttributeName isEqualToString:@"inspectionTimes"] && [elementName isEqualToString:@"div"])  {
		self.nexElementName = @"div";
		self.nextKey = @"id";
		self.nextBalise = @"propertySummary";
	} else if ([self.houseAttributeName isEqualToString:@"availability"] && [elementName isEqualToString:@"dd"]) {
		self.previousHouseAttributeName = self.houseAttributeName;
		self.takeText = FALSE;
	} else if (self.takeHouseAttributeName) {
		self.nexElementName = nil;
		self.nextKey = nil;
		self.nextBalise = nil;
	} else if ([elementName isEqualToString:@"dl"] && ([self.previousHouseAttributeName isEqualToString:@"availability"] || 
													   [self.previousHouseAttributeName isEqualToString:@"houseType"] || 
													   [self.previousHouseAttributeName isEqualToString:@"bond"] ||
													   [self.previousHouseAttributeName isEqualToString:@"energyEfficiencyRating"] ||
													   [self.previousHouseAttributeName isEqualToString:@"land"] ||
													   [self.previousHouseAttributeName isEqualToString:@"building"] ||
													   [self.previousHouseAttributeName isEqualToString:@"municipality"] ||
													   [self.previousHouseAttributeName isEqualToString:@"closeTo"] ||
													   [self.previousHouseAttributeName isEqualToString:@"features"])) {
		self.nexElementName = @"div";
		self.nextKey = @"id";
		self.nextBalise = @"agentCollapsed";
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
	[houseID release];
	[currentDict release];
	
	[super dealloc];
}

@end
