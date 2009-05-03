//
//  PropertyTypeSearchController.h
//  ozEstate
//
//  Created by Anthony Mittaz on 8/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
// 

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"

@interface PropertyTypesSearchController : BaseTableViewController {
	NSArray *_content;
	NSNumber *_searchID;
	
	NSString *_selectedTypes;
}

@property (nonatomic, retain) NSArray *content;
@property (nonatomic, retain) NSNumber *searchID;
@property (nonatomic, retain) NSString *selectedTypes;

@end
