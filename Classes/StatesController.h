//
//  StatesController.h
//  ozEstate
//
//  Created by Anthony Mittaz on 8/03/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"


@interface StatesController : BaseTableViewController {
	NSArray *_restoreArray;
}

@property (nonatomic, retain) NSArray *restoreArray;

-(BOOL)isFavorite;

- (NSString *)statebNameForRow:(NSInteger)row;

- (void)pushNextControllerWithTitle:(NSString *)title animated:(NSNumber *)animated;

- (void)reloadContent;

@end
