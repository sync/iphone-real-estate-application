//
//  PropertyLocationSearchOperation.m
//  ozEstate
//
//  Created by Anthony Mittaz on 15/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
// 

#import "PropertyLocationSearchOperation.h"

@implementation PropertyLocationSearchOperation

@synthesize  properties=_properties;

- (void)main
{
	for (NSDictionary *property in self.properties) {
//		FMResultSet *rs = [self.appdb executeQuery:@"select name,latitude,longitude from streets where suburb = ?", [[property valueForKey:@"suburb_name"]lowercaseString]];
//		NSNumber *latitude = nil;
//		NSNumber *longitude = nil;
//		NSString *name = nil;
//		while ([rs next]) {
//			name = [rs stringForColumn:@"name"];
//			if (name && [name length] > 0 && [[[property valueForKey:@"street_name"] lowercaseString]hasSuffix:name]) {
//				latitude = [NSNumber numberWithDouble:[rs doubleForColumn:@"latitude"]];
//				longitude = [NSNumber numberWithDouble:[rs doubleForColumn:@"longitude"]];
//			}
//		}
//		[rs close];
		
//		if ([latitude doubleValue] == 0.0 && [longitude doubleValue] == 0.0) {
			FMResultSet *rs = [self.appdb executeQuery:@"select name,latitude,longitude from suburbs where name = ? and state = ?", [[property valueForKey:@"suburb_name"]capitalizedString], [[property valueForKey:@"state_name"]uppercaseString]];
			NSNumber *latitude = nil;
			NSNumber *longitude = nil;
			if ([rs next]) {
				latitude = [NSNumber numberWithDouble:[rs doubleForColumn:@"latitude"]];
				longitude = [NSNumber numberWithDouble:[rs doubleForColumn:@"longitude"]];
			}
			[rs close];
//		}
		
		if ([latitude doubleValue] != 0.0 && [longitude doubleValue] != 0.0) {
			NSMutableDictionary *dictToSend = [NSMutableDictionary dictionaryWithCapacity:0];
			[dictToSend setValue:[property valueForKey:@"property_id"] forKey:@"property_id"];
			[dictToSend setValue:latitude forKey:@"latitude"];
			[dictToSend setValue:longitude forKey:@"longitude"];
			[self performSelectorWithDictionary:dictToSend];
		}
	}

	
}

- (void)dealloc
{
	[_properties release];
	
	[super dealloc];
}

@end
