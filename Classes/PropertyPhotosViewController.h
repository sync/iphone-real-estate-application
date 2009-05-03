//
//  PropertyPhotosView.h
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

@interface PropertyPhotosViewController : BaseViewController {
	UIScrollView *_scrollView;
	UIView *_photosView;
	NSNumber *_property_id;
	
	NSInteger _retryCount;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIView *photosView;
@property (nonatomic, retain) NSNumber *property_id;
@property (nonatomic) NSInteger retryCount;

- (IBAction)pushBigPhotosController:(id)sender;

- (void)reloadTableView:(id)sender;
- (void)fetchDb;
- (void)refreshPhotos:(id)sender;

@end
