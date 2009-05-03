//
//  AddSalesAttributesToPropertiesUserTable.m
//  ozEstate
//
//  Created by Anthony Mittaz on 25/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import "AddSalesAttributesToPropertiesUserTable.h"


@implementation AddSalesAttributesToPropertiesUserTable

- (void)up {
	[db_ executeUpdate:@"ALTER TABLE properties ADD COLUMN energy_efficiency_rating text"];
	[db_ executeUpdate:@"ALTER TABLE properties ADD COLUMN land text"];
	[db_ executeUpdate:@"ALTER TABLE properties ADD COLUMN municipality text"];
	[db_ executeUpdate:@"ALTER TABLE properties ADD COLUMN close_to text"];
	[db_ executeUpdate:@"ALTER TABLE properties ADD COLUMN features text"];
	[db_ executeUpdate:@"ALTER TABLE properties ADD COLUMN building text"];
}

- (void)down {
	// sqlile limitation Cannot drop a column ??
}

@end
