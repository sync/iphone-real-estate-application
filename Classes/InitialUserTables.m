//
//  InitialUserTables.m
//  ozEstate
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
	// Properties
	[db_ executeUpdate:@"create table properties ("
	 @"id integer primary key,"
	 @"created_at double,"
	 @"updated_at double,"
	 @"price integer,"
	 @"bathroom_number integer,"
	 @"bedroom_number integer,"
	 @"garage_number integer,"
	 @"latitude double,"
	 @"longitude double,"
	 @"street_name text,"
	 @"suburb_name text,"
	 @"description text,"
	 @"title text,"
	 @"state_name text,"
	 @"agency_id integer,"
	 @"website_link text,"
	 @"website_id text,"
	 @"favorite bool,"
	 @"availability double,"
	 @"bond integer,"
	 @"property_type text"
	 @")"];
	
	// Images
	[db_ executeUpdate:@"create table images ("
	 @"id integer primary key,"
	 @"url text,"
	 @"preview bool,"
	 @"property_id integer"
	 @")"];
	
	// Agencies
	[db_ executeUpdate:@"create table agencies ("
	 @"id integer primary key,"
	 @"website_link text,"
	 @"website_id text,"
	 @"name text,"
	 @"phone_number text,"
	 @"fax_number text,"
	 @"street_name text,"
	 @"suburb_name text,"
	 @"state_name text,"
	 @"email text"
	 @")"];
}

- (void)down {
	// Properties
	[self dropTable:@"properties"];
	// Images
	[self dropTable:@"images"];
	// Agencies
	[self dropTable:@"agencies"];
}

@end
