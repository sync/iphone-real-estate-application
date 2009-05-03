//
//  PropertyController.h
//  ozEstate
//
//  Created by Anthony Mittaz on 5/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"

@interface PropertyController : BaseTableViewController <UITableViewDataSource, UITableViewDelegate>{
	NSArray *_content;
	BOOL _favorite;
	
	NSNumber *_property_id;
	NSInteger _pageIndex;
}

@property (nonatomic, retain) NSArray *content;
@property (nonatomic) BOOL favorite;
@property (nonatomic, retain) NSNumber *property_id;
@property (nonatomic) NSInteger pageIndex;

- (IBAction)openMap:(id)sender;
- (IBAction)pushPhotoViewController:(id)sender;
- (IBAction)pushMoreInfosController:(id)sender;
- (IBAction)pushAgencyController:(id)sender;

- (NSString *)urlEncodeValue:(NSString *)string;

- (void)fetchDb;
- (void)reloadPropertyForPropertyId:(id)sender;

@end
