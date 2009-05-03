//
//  GPSRadiusController.m
//  ozEstate
//
//  Created by Anthony Mittaz on 14/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import "GPSRadiusController.h"
#import "TransparentCell.h"

@implementation GPSRadiusController

@synthesize content=_content;

/*
 - (id)initWithStyle:(UITableViewStyle)style {
 // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 if (self = [super initWithStyle:style]) {
 }
 return self;
 }
 */

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self loadAppDelegate];
	
}


- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"GPS Radius";
	self.content = [NSArray arrayWithObjects:@"1.5", @"3", @"5", @"10", @"15", @"20", @"30", nil];
	
	self.tableView.sectionHeaderHeight = 18.0;
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.content count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger count = [self.content count];
    
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
        cell = [TransparentCell cellWithFrame:CGRectZero position:position andAccessoryType:UITableViewCellAccessoryNone differentSelectedBackground:FALSE];
    }
	
	NSString *title = [self.content objectAtIndex:indexPath.row];
	NSString *gpsRadius = [self.appDelegate.userDefaults valueForKey:GPSRadius];
	
	if ([title isEqual:gpsRadius]) {
		[cell setShowCheckmark:TRUE];
	} else {
		[cell setShowCheckmark:FALSE];
	}
	
	title = [NSString stringWithFormat:@"Within %@ km", title];
	
	[cell setTitle:title];
    
    // Set up the cell...
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TransparentCell *cell = (TransparentCell *)[tableView cellForRowAtIndexPath:indexPath];
	[cell setShowCheckmark:TRUE];
	NSString *title = [self.content objectAtIndex:indexPath.row];
	[self.appDelegate.userDefaults setObject:title forKey:GPSRadius];
	[self.tableView reloadData];
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


- (void)dealloc {
    [_content release];
	
	[super dealloc];
}



@end

