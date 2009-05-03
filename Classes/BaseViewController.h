//
//  BaseViewController.h
//  ozEstate
//
//  Created by Anthony Mittaz on 6/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import <UIKit/UIKit.h>


@interface BaseViewController : UIViewController {
	ozEstateAppDelegate *_appDelegate;
}

@property (nonatomic, retain) ozEstateAppDelegate *appDelegate;

- (void)loadAppDelegate;

- (void)restoreLevelWithSelectionArray:(NSArray *)selectionArray;

@end
