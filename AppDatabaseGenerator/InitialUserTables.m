//
//  InitialUserTables.m
//  Surfline
//
//  Created by Anthony Mittaz on 9/09/08.
//  Copyright 2008 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import "InitialUserTables.h"


@implementation InitialUserTables

- (void)up {
	// Suburbs
	[db_ executeUpdate:@"create table generated_suburbs ("
	 @"id integer primary key,"
	 @"postcode text,"
	 @"name text,"
	 @"latitude double,"
	 @"longitude double,"
	 @"state text"
	 @")"];
	
	[db_ executeUpdate:@"create table suburbs ("
	 @"id integer primary key,"
	 @"postcode text,"
	 @"name text,"
	 @"latitude double,"
	 @"longitude double,"
	 @"state text,"
	 @"full_address text"
	 @")"];
	
//	// Streets
//	[db_ executeUpdate:@"create table streets ("
//	 @"id integer primary key,"
//	 @"name text,"
//	 @"latitude double,"
//	 @"longitude double,"
//	 @"suburb text"
//	 @")"];
	
	// Property types
	[db_ executeUpdate:@"create table property_types ("
	 @"id integer primary key,"
	 @"name"
	 @")"];
	// *** SHOW ALL TYPES ***,Houses,Townhouses,Acreage/Semi-Rural,Block of Units
}

- (void)down {
	// Suburbs
	[self dropTable:@"suburbs"];
	// Images
	[self dropTable:@"images"];
}

@end
