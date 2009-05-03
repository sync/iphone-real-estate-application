//
//  PropertyTypeSearchController.m
//  ozEstate
//
//  Created by Anthony Mittaz on 8/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import "PropertyTypesSearchController.h"
#import "TransparentCell.h"

@implementation PropertyTypesSearchController


@synthesize content=_content;
@synthesize searchID=_searchID;
@synthesize selectedTypes=_selectedTypes;

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
	
	self.navigationItem.title = @"Select Property Type(s)";
	
	// *** SHOW ALL TYPES ***,Houses,Townhouses,Acreage/Semi-Rural,Block of Units
	self.content = [NSArray arrayWithObjects:@"Show All", @"Houses", @"Townhouses", @"Apartments", @"Acreage", @"Block Units", nil];
	
	self.tableView.sectionHeaderHeight = 18.0;
	
	FMResultSet *rs = [self.appDelegate.userdb executeQuery:[NSString stringWithFormat:@"select property_types from searches where id = ? limit 1 offset 0"], self.searchID];
	
	if ([rs next]) {
		self.selectedTypes = [rs stringForColumn:@"property_types"];
	}
	[rs close];
	
	if (!self.selectedTypes || [self.selectedTypes length] == 0) {
		self.selectedTypes = @"";
	}
	
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
	[cell setTitle:title];
	
	NSRange range = [self.selectedTypes rangeOfString:title];
	if (range.location != NSNotFound) {
		[cell setShowCheckmark:TRUE];
	} else {
		[cell setShowCheckmark:FALSE];
	}
    
    // Set up the cell...
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TransparentCell *cell = (TransparentCell *)[tableView cellForRowAtIndexPath:indexPath];
	
	NSString *title = [self.content objectAtIndex:indexPath.row];
	
	if (![[title lowercaseString] isEqual:@"show all"]) {
		if (cell.accessoryView) {
			NSString *comma = @",";
			if ([self.selectedTypes length] == [title length] || [self.selectedTypes hasPrefix:title]) {
				comma = @"";
			}
			
			self.selectedTypes = [self.selectedTypes stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@%@", comma, title] withString:@""];
			
			NSRange range = [self.selectedTypes rangeOfString:@","];
			if (range.location == 0) {
				self.selectedTypes = [self.selectedTypes substringFromIndex:range.length];
			}
			
		} else {
			NSString *comma = @"";
			if ([self.selectedTypes length] > 0) {
				comma = @",";
			}
			self.selectedTypes = [NSString stringWithFormat:@"%@%@%@", self.selectedTypes, comma, title];
			self.selectedTypes = [self.selectedTypes stringByReplacingOccurrencesOfString:@"Show All" withString:@""];
			self.selectedTypes = [self.selectedTypes stringByReplacingOccurrencesOfString:@",Show All" withString:@""];
			[self.tableView reloadData];
		}
		
	} else {
		if (cell.accessoryView) {
			self.selectedTypes = @"";
		} else {
			self.selectedTypes = @"Show All";
		}
		[self.tableView reloadData];
	}
	
	NSRange range = [self.selectedTypes rangeOfString:@","];
	if (range.location == 0) {
		self.selectedTypes = [self.selectedTypes substringFromIndex:range.length];
	}
	
	[cell setShowCheckmark:TRUE];
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

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.appDelegate.userdb executeUpdate:@"UPDATE searches SET property_types = ? where id = ?", self.selectedTypes, self.searchID];
}


- (void)dealloc {
    [_selectedTypes release];
	[_searchID release];
	[_content release];
	
	[super dealloc];
}


@end

