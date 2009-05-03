//
//  SuburbsSearchFetching.m
//  ozEstate
//
//  Created by Anthony Mittaz on 7/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
// 

#import "SuburbsSearchFetching.h"


@implementation SuburbsSearchFetching

@synthesize searchString=_searchString;
@synthesize lastLoadedIndex=_lastLoadedIndex;

- (void)main
{
	if ([self isCancelled])
	{
		return;	// user cancelled this operation
	}
	
	NSString *state = [self.userDefaults valueForKey:State];
	
	FMResultSet *rs = [self.appdb executeQuery:[NSString stringWithFormat:@"select id,name from suburbs where state = ? and full_address like \"%%%@%%\" order by name limit 16 offset %d", self.searchString, self.lastLoadedIndex], state];
	NSMutableArray *content = [NSMutableArray arrayWithCapacity:0];
	while ([rs next]) {
		NSMutableDictionary *suburb = [NSMutableDictionary dictionaryWithCapacity:0];
		NSString *name = [rs stringForColumn:@"name"];
		NSNumber *suburb_id = [NSNumber numberWithInt:[rs intForColumn:@"id"]];
		if (name) {
			[suburb setValue:name forKey:@"name"];
			[suburb setValue:suburb_id forKey:@"id"];
			[content addObject:suburb];
		}
	}
	[rs close];
	
	NSMutableDictionary *dictToSend = [NSMutableDictionary dictionaryWithCapacity:0];
	[dictToSend setValue:content forKey:@"content"];
	[self performSelectorWithDictionary:dictToSend];
	
}

- (void)dealloc
{
	[_searchString release];
	
	[super dealloc];
}

@end
