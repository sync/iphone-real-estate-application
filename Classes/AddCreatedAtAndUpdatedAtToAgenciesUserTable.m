//
//  AddCreatedAtAndUpdatedAtToAgenciesUserTable.m
//  ozEstate
//
//  Created by Anthony Mittaz on 13/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#import "AddCreatedAtAndUpdatedAtToAgenciesUserTable.h"


@implementation AddCreatedAtAndUpdatedAtToAgenciesUserTable

- (void)up {
	[db_ executeUpdate:@"ALTER TABLE agencies ADD COLUMN created_at double"];
	[db_ executeUpdate:@"ALTER TABLE agencies ADD COLUMN updated_at double"];
}

- (void)down {
	// sqlile limitation Cannot drop a column ??
}

@end
