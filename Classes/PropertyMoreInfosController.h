//
//  PropertyMoreInfosController.h
//  ozEstate
//
//  Created by Anthony Mittaz on 8/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface PropertyMoreInfosController : BaseViewController {
	UIView *_resizableView;
	NSNumber *_property_id;
}

@property (nonatomic, retain) IBOutlet UIView *resizableView;
@property (nonatomic, retain) NSNumber *property_id;

- (void)reloadTableView:(id)sender;

- (void)fetchDb;

- (void)openInBrowser:(id)sender;

@end
