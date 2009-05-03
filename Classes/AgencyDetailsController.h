//
//  AgencyDetailsController.h
//  ozEstate
//
//  Created by Anthony Mittaz on 9/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"


@interface AgencyDetailsController : BaseTableViewController {
	NSMutableArray *_content;
	NSNumber *_agency_id;
	NSNumber *_property_id;
	
	NSString *_state;
}

@property (nonatomic, retain) NSMutableArray *content;
@property (nonatomic, retain) NSNumber *agency_id;
@property (nonatomic, retain) NSNumber *property_id;
@property (nonatomic, retain) NSString *state;

- (void)fetchDb;

@end
