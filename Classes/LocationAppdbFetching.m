//
//  LocationAppdbFetching.m
//  ozEstate
//
//  Created by Anthony Mittaz on 7/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import "LocationAppdbFetching.h"


@implementation LocationAppdbFetching

@synthesize gpsRadius=_gpsRadius;
@synthesize lastLoadedIndex=_lastLoadedIndex;

- (void)main
{
	if ([self isCancelled])
	{
		return;	// user cancelled this operation
	}
	
	if (self.gpsRadius <= 0) {
		self.gpsRadius = 1500;
	}
	
	FMResultSet *rs = [self.appdb executeQuery:[NSString stringWithFormat:@"select id,name,latitude,longitude,state from suburbs order by name"]];
	NSMutableArray *content = [NSMutableArray arrayWithCapacity:0];
	NSString *state = nil;
	while ([rs next]) {
		NSMutableDictionary *suburb = [NSMutableDictionary dictionaryWithCapacity:0];
		NSNumber *suburb_id = [NSNumber numberWithInt:[rs intForColumn:@"id"]];
		NSString *name = [rs stringForColumn:@"name"];
		state = [rs stringForColumn:@"state"];
		CLLocation *location = [[CLLocation alloc]initWithLatitude:[rs doubleForColumn:@"latitude"] longitude:[rs doubleForColumn:@"longitude"]];
		CLLocationDistance distanceInMeters = [[self.infoDictionary valueForKey:@"currentLocation"] getDistanceFrom:location];
		[location release];
		if (distanceInMeters < self.gpsRadius) {
			if (name) {
				[suburb setValue:name forKey:@"name"];
				[suburb setValue:suburb_id forKey:@"id"];
				[content addObject:suburb];
			}
		} else {
			//DLog(@"name: %@, distance: %f", name, distanceInMeters);
		}
	}
	[rs close];
	
	if (state) {
		[self.userDefaults setObject:state forKey:State];
		[[NSNotificationCenter defaultCenter] postNotificationName:ShouldReloadSearchSuburbs object:nil];
	}
	
	// filter array
	NSInteger count = [content count];
	if (count > 16 + self.lastLoadedIndex) {
		count = 16;
	} else {
		count = count - self.lastLoadedIndex;
	}
	
	NSArray *filteredArray = [content subarrayWithRange:NSMakeRange(self.lastLoadedIndex, count)];
	
	NSMutableDictionary *dictToSend = [NSMutableDictionary dictionaryWithCapacity:0];
	[dictToSend setValue:filteredArray forKey:@"content"];
	[self performSelectorWithDictionary:dictToSend];
	
}

@end
