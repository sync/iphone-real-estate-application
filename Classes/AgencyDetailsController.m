//
//  AgencyDetailsController.m
//  ozEstate
//
//  Created by Anthony Mittaz on 9/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import "AgencyDetailsController.h"
#import "TransparentCell.h"
#import "AgencyTopView.h"

@implementation AgencyDetailsController

@synthesize content=_content;
@synthesize agency_id=_agency_id;
@synthesize property_id=_property_id;
@synthesize state=_state;

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
	
	self.navigationItem.title = @"Agency";
	
	self.tableView.sectionHeaderHeight = 18.0;
	
    self.tableView.sectionHeaderHeight = 18.0;
	
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadTableView:) name:ShouldReloadAgencyTableView object:nil];
	
	[self fetchDb];
	
}


- (void)reloadTableView:(id)sender
{
	[self fetchDb];
}

- (void)fetchDb
{
	if ([self.agency_id intValue] == 0) {
		self.agency_id = [NSNumber numberWithInteger:[self.appDelegate.userdb intForQuery:@"select agency_id from properties where id = ?", self.property_id]];
	}
	if ([self.agency_id intValue] == 0) {
		NSString *website_id = [self.appDelegate.userdb stringForQuery:@"select website_id from properties where id = ?", self.property_id];
		if (website_id) {
			[self.appDelegate.dataFetcher getPropertyMoreInfosWithPropertyId:website_id];
		}
	} else {
		FMResultSet *rs = [self.appDelegate.userdb executeQuery:[NSString stringWithFormat:@"select agencies.updated_at,agencies.website_link,agencies.website_id,agencies.name,agencies.phone_number,agencies.street_name,agencies.suburb_name,agencies.state_name,properties.website_id as property_website_id from agencies,properties where agencies.id = ? and properties.agency_id=agencies.id"],  self.agency_id];
		NSDate *updated_at = nil;
		NSString *website_id = nil;
		NSString *website_link = nil;
		NSString *name = nil;
		NSString *phone_number = nil;
		NSString *street_name = nil;
		NSString *suburb_name = nil;
		NSString *state_name = nil;
		NSString *property_website_id = nil;
		
		if ([rs next]) {
			updated_at = [rs dateForColumn:@"updated_at"];
			website_id = [rs stringForColumn:@"website_id"];
			website_link = [rs stringForColumn:@"website_link"];
			name = [rs stringForColumn:@"name"];
			phone_number = [rs stringForColumn:@"phone_number"];
			street_name = [rs stringForColumn:@"street_name"];
			suburb_name = [rs stringForColumn:@"suburb_name"];
			state_name = [rs stringForColumn:@"state_name"];
			property_website_id = [rs stringForColumn:@"property_website_id"];
		}
		[rs close];
		
		// Updated_at
		NSTimeInterval timeDiff = 60*60*24+100;
		if (updated_at) {
			timeDiff = [[NSDate date] timeIntervalSinceDate:updated_at];
		}
		
		if (timeDiff > 60*60*24) {
			if (website_id) {
				[self.appDelegate.dataFetcher getAgencyMoreInfosWithAgencyId:website_id andPropertyWebsiteId:property_website_id];
			} else {
				if (website_id) {
					[self.appDelegate.dataFetcher getPropertyMoreInfosWithPropertyId:property_website_id];
				}
			}
		} else {
			if (!name || [name length] == 0) {
				name = @"n/a";
			}
			if (!street_name || [street_name length] == 0) {
				street_name = @"";
			} else {
				street_name = [street_name stringByReplacingOccurrencesOfString:@"," withString:@""];
				street_name = [NSString stringWithFormat:@"%@, ", street_name];
			}
			if (!suburb_name || [suburb_name length] == 0) {
				suburb_name = @"";
			} else {
				suburb_name = [suburb_name stringByReplacingOccurrencesOfString:@"," withString:@""];
				suburb_name = [NSString stringWithFormat:@"%@, ", suburb_name];
			}
			if (!state_name || [state_name length] == 0) {
				state_name = self.state;
			} else {
				state_name = [state_name stringByReplacingOccurrencesOfString:@"," withString:@""];
			}
			
			AgencyTopView *backgroundView = (AgencyTopView *)self.tableView.tableHeaderView;
			if (!backgroundView) {
				CGRect cellFrame = CGRectMake(0.0, 0.0, 320.0, 255.0);
				backgroundView = [AgencyTopView viewWithFrame:cellFrame selected:FALSE];
				self.tableView.tableHeaderView = backgroundView;
			}
			
			// BackgroundView
			[backgroundView setTitle:name];
			[backgroundView setTextToSend:[NSString stringWithFormat:@"Regarding property %@,\nI am very interested in this property and would like to view it at the earliest possible time.", property_website_id]];
			[backgroundView setStreetName:[NSString stringWithFormat:@"%@%@%@", street_name, suburb_name, state_name]];
			//[backgroundView setDistance:@"3.2 km"];
			[backgroundView setNeedsDisplay];
			
			if (!self.content) {
				self.content = [NSMutableArray arrayWithCapacity:0];
			}
			
			[self.content removeAllObjects];
			
			[self.content addObject:@"Send"];
			
			//if (!website_link || [website_link length] == 0) {
	//			[self.content addObject:@"Website"];
	//		}
			if (phone_number && [phone_number length] > 0) {
				[self.content addObject:phone_number];
			}
			
			[self.tableView reloadData];
			
		}
	}
	
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
        cell = [TransparentCell cellWithFrame:CGRectZero position:position andAccessoryType:UITableViewCellAccessoryDisclosureIndicator differentSelectedBackground:TRUE];
    }
	
	NSString *title = [self.content objectAtIndex:indexPath.row];
	
	NSString *imageName = nil;
	if ([title isEqual:@"Send"]) {
		imageName = @"mail_icon.png";
	} else {
		imageName = @"phone_icon.png";
	}
	
	[cell setImage:[self.appDelegate cachedImage:imageName]];
	
	[cell setTitle:title];
    
    // Set up the cell...
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *title = [self.content objectAtIndex:indexPath.row];
	if (![title isEqual:@"Send"]) {
		[[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",title]]];
	} else {
		// enquire realestate
		NSString *website_id = [self.appDelegate.userdb stringForQuery:@"select website_id from properties where id = ?", self.property_id];
		NSString *comment = [NSString stringWithFormat:@"Regarding property %@,\nI am very interested in this property and would like to view it at the earliest possible time.", website_id];
		[self.appDelegate.dataFetcher sendMessageInfosRequestWithPropertyId:self.property_id andComment:comment];
	}
	[self.tableView deselectRowAtIndexPath:indexPath animated:TRUE];
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
    [[NSNotificationCenter defaultCenter]removeObserver:self];
	
	[_property_id release];
	[_agency_id release];
	[_content release];
	
	[super dealloc];
}

@end

