//
//  FavoritesStatesController.m
//  ozEstate
//
//  Created by Anthony Mittaz on 8/03/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import "FavoritesStatesController.h"
#import "FavoritesController.h"

@implementation FavoritesStatesController

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

-(BOOL)isFavorite
{
	return TRUE;
}

- (void)pushNextControllerWithTitle:(NSString *)title animated:(NSNumber *)animated
{
	FavoritesController *controller = [[FavoritesController alloc] initWithNibName:@"FavoritesController" bundle:nil];
	controller.state = title;
	controller.navigationItem.title = title;
	[self.navigationController pushViewController:controller animated:[animated boolValue]];
	if (self.restoreArray) {
		[controller restoreLevelWithSelectionArray:self.restoreArray];
		self.restoreArray = nil;
	}
	[controller release];
}


- (NSString *)statebNameForRow:(NSInteger)row
{
	NSString *state = [self.appDelegate.userdb stringForQuery:[NSString stringWithFormat:@"select distinct(state_name) from properties where favorite = ? order by state_name ASC limit 1 offset %d", row], [NSNumber numberWithBool:[self isFavorite]]];
	return state;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadContent) name:ShouldReloadFavoritesStatesController object:nil];
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
	
	[super dealloc];
}


@end

