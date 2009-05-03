//
//  AddSearchTable.m
//  ozEstate
//
//  Created by Anthony Mittaz on 11/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
// 

#import "AddSearchTable.h"


@implementation AddSearchTable

- (void)up {
	// Search
	[db_ executeUpdate:@"create table searches ("
	 @"id integer primary key,"
	 @"state text,"
	 @"suburbs text,"
	 @"property_types text,"
	 @"price_min integer,"
	 @"price_max integer,"
	 @"bedroom_min integer,"
	 @"bedroom_max integer,"
	 @"bathroom_min integer,"
	 @"bathroom_max integer,"
	 @"garage_min integer,"
	 @"garage_max integer,"
	 @"created_at double"
	 @")"];
}

- (void)down {
	// Search
	[self dropTable:@"searches"];
}

@end
