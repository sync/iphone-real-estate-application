//
//  RecentsController.m
//  ozEstate
//
//  Created by Anthony Mittaz on 12/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import "RecentsController.h"


@implementation RecentsController

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (NSString *)suburbNameForSection:(NSInteger)section
{
	NSString *suburb = [self.appDelegate.userdb stringForQuery:[NSString stringWithFormat:@"select distinct(suburb_name) from properties where favorite = ? and state_name = ? order by created_at DESC limit 1 offset %d", section], [NSNumber numberWithBool:[self isFavorite]], self.state];
	return suburb;
}

- (NSInteger)initialPositionForPropertyId:(NSNumber *)property_id
{
	FMResultSet *rs = [self.appDelegate.userdb executeQuery:[NSString stringWithFormat:@"select id from properties where favorite = ? order by created_at DESC"],  [NSNumber numberWithBool:[self isFavorite]]];
	NSInteger initialPosition = 0;
	NSNumber *tempProperty_id = nil;
	while ([rs next] && [self isFavorite]) {
		tempProperty_id = [NSNumber numberWithInteger:[rs intForColumn:@"id"]];
		if ([tempProperty_id isEqualToNumber:property_id]) {
			break;
		}
		initialPosition++;
	} 
	[rs close];
	
	return initialPosition;
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)dealloc {
    [super dealloc];
}


@end

