//
//  PropertiesController.h
//  ozEstate
//
//  Created by Anthony Mittaz on 12/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import "BaseTableViewController.h"


@interface PropertiesController : BaseTableViewController {
	NSString *_state;
}

@property (nonatomic, retain) NSString *state;


-(BOOL)isFavorite;

- (NSString *)suburbNameForSection:(NSInteger)section;

- (void)reloadTableView:(id)sender;

- (void)restoreLevelWithSelectionArray:(NSArray *)selectionArray;

- (void)clear:(id)sender;

- (void)addOrRemoveClearButton;

- (NSInteger)initialPositionForPropertyId:(NSNumber *)property_id;

@end
