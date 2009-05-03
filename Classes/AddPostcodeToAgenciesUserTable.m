//
//  AddPostcodeToAgenciesUserTable.m
//  ozEstate
//
//  Created by Anthony Mittaz on 13/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
// 

#import "AddPostcodeToAgenciesUserTable.h"


@implementation AddPostcodeToAgenciesUserTable

- (void)up {
	[db_ executeUpdate:@"ALTER TABLE agencies ADD COLUMN postcode text"];
}

- (void)down {
	// sqlile limitation Cannot drop a column ??
}

@end
