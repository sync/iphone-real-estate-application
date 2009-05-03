//
//  StatesController.m
//  ozEstate
//
//  Created by Anthony Mittaz on 8/03/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import "StatesController.h"
#import "RecentsController.h"
#import "TransparentCell.h"
#import "ViewWithImage.h"

@implementation StatesController

@synthesize restoreArray=_restoreArray;

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
	
	NSInteger count = [self.appDelegate.userdb intForQuery:@"select count(distinct(state_name)) from properties where favorite = ?", [NSNumber numberWithBool:[self isFavorite]]];
	if (count == 1) {
		[self pushNextControllerWithTitle:[self statebNameForRow:0] animated:[NSNumber numberWithBool:FALSE]];
	}

    //self.navigationItem.title = @"Choose a State";
}

- (void)reloadContent
{
	[self.tableView reloadData];
//	NSInteger count = [self.appDelegate.userdb intForQuery:@"select count(distinct(state_name)) from properties where favorite = ?", [NSNumber numberWithBool:[self isFavorite]]];
//	if (count == 1) {
//		[self pushNextControllerWithTitle:[self statebNameForRow:0] animated:[NSNumber numberWithBool:FALSE]];
//	}
}

-(BOOL)isFavorite
{
	return FALSE;
}

- (void)pushNextControllerWithTitle:(NSString *)title animated:(NSNumber *)animated
{
	RecentsController *controller = [[RecentsController alloc] initWithNibName:@"RecentsController" bundle:nil];
	controller.state = title;
	controller.navigationItem.title = title;
	[self.navigationController pushViewController:controller animated:[animated boolValue]];
	if (self.restoreArray) {
		[controller restoreLevelWithSelectionArray:self.restoreArray];
		self.restoreArray = nil;
	}
	[controller release];
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

#pragma mark Table view methods

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	NSInteger count = [self.appDelegate.userdb intForQuery:@"select count(distinct(state_name)) from properties where favorite = ?", [NSNumber numberWithBool:[self isFavorite]]];
	if (count == 0) {
		self.tableView.sectionHeaderHeight = 73.0;
		CGRect cellFrame = CGRectMake(0.0, 0.0, 320.0, 73.0);
		// BackgroundView
		ViewWithImage *backgroundView = [ViewWithImage viewWithFrame:cellFrame andBackgroundImage:[self.appDelegate cachedImage:@"title_view.png"]];
		NSString *title = @"Nothing yet. Move Along.";
		backgroundView.title = title;
		return backgroundView;
	}
	self.tableView.sectionHeaderHeight = 10.0;
	return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger count = [self.appDelegate.userdb intForQuery:@"select count(distinct(state_name)) from properties where favorite = ?", [NSNumber numberWithBool:[self isFavorite]]];
	
	return count;
}

- (NSString *)statebNameForRow:(NSInteger)row
{
	NSString *state = [self.appDelegate.userdb stringForQuery:[NSString stringWithFormat:@"select distinct(state_name) from properties where favorite = ? order by state_name ASC limit 1 offset %d", row], [NSNumber numberWithBool:[self isFavorite]]];
	return state;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger count = [self.appDelegate.userdb intForQuery:@"select count(distinct(state_name)) from properties where favorite = ?", [NSNumber numberWithBool:[self isFavorite]]];
    
	UITableViewCellPosition position;
	NSString *cellIdentifier = nil;
	if (count == 1) {
		position = UITableViewCellPositionUnique;
		cellIdentifier = UniqueTransparentCell;
	} else {
		if (indexPath.row == 0) {
			position = UITableViewCellPositionTop;
			cellIdentifier = TopTransparentCell;
		} else if (indexPath.row == (count -1)) {
			position = UITableViewCellPositionBottom;
			cellIdentifier = BottomTransparentCell;
		} else {
			position = UITableViewCellPositionMiddle;
			cellIdentifier = MiddleTransparentCell;
		}
	}
	
	TransparentCell *cell = (TransparentCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [TransparentCell cellWithFrame:CGRectZero position:position andAccessoryType:UITableViewCellAccessoryDisclosureIndicator differentSelectedBackground:TRUE];
    }
	
	NSString *title = [self statebNameForRow:indexPath.row];
	
	[cell setTitle:title];
    
    // Set up the cell...
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self pushNextControllerWithTitle:[self statebNameForRow:indexPath.row] animated:[NSNumber numberWithBool:TRUE]];
	[self.appDelegate.savedLocation replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%d", indexPath.row]];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self loadAppDelegate];
	
	if (self.appDelegate.savedLocation != nil) {
		[self.appDelegate.savedLocation replaceObjectAtIndex:1 withObject:@"-1"];
	}
	
}

- (void)restoreLevelWithSelectionArray:(NSArray *)selectionArray
{	
	[self loadAppDelegate];
	
	NSInteger row = [[selectionArray objectAtIndex:0]integerValue];
	if (row != -1) {
		
		// narrow down the selection array for level 2
		NSArray *newSelectionArray = [selectionArray subarrayWithRange:NSMakeRange(1, [selectionArray count]-1)];
		self.restoreArray = newSelectionArray;
		[self pushNextControllerWithTitle:[self statebNameForRow:row] animated:[NSNumber numberWithBool:FALSE]];
	}
}


- (void)dealloc {
    [_restoreArray release];
	
	[super dealloc];
}


@end

