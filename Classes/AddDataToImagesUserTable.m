//
//  AddDataToImagesUserTable.m
//  ozEstate
//
//  Created by Anthony Mittaz on 12/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
// 

#import "AddDataToImagesUserTable.h"


@implementation AddDataToImagesUserTable

- (void)up {
	[db_ executeUpdate:@"ALTER TABLE images ADD COLUMN data blob"];
}

- (void)down {
	// sqlile limitation Cannot drop a column ??
}

@end
