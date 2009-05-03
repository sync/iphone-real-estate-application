//
//  SearchController.m
//  ozEstate
//
//  Created by Anthony Mittaz on 6/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import "SuburbsSearchController.h"
#import "TransparentCell.h"
#import <CoreLocation/CoreLocation.h>
#import "LocationAppdbFetching.h"
#import "SuburbsSearchFetching.h"
#import "ShowNextResultView.h"
#import "StatesSearchController.h"

@implementation SuburbsSearchController

@synthesize tableView=_tableView;
@synthesize searchBar=_searchBar;
@synthesize content=_content;
@synthesize fetchingQueue=_fetchingQueue;
@synthesize lastLoadedIndex=_lastLoadedIndex;
@synthesize selectedSuburbs=_selectedSuburbs;
@synthesize searchID=_searchID;
@synthesize selectorToUse=_selectorToUse;
@synthesize stateButton=_stateButton;
@synthesize currentState=_currentState;

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
	
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stateChanged:) name:ShouldReloadSearchSuburbs object:nil];
	
	NSString *state = [self.appDelegate.userDefaults valueForKey:State];
	[self.stateButton setTitle:state forState:UIControlStateNormal];
	[self.stateButton setTitle:state forState:UIControlStateHighlighted];
	[self.stateButton setTitle:state forState:UIControlStateDisabled];
	[self.stateButton setTitle:state forState:UIControlStateSelected];
	self.currentState = state;
	
	NSOperationQueue *fetchingQueue = [[NSOperationQueue alloc]init];
	self.fetchingQueue = fetchingQueue;
	[fetchingQueue release];
	
	// add clear button
	UIBarButtonItem *clearButton = [[UIBarButtonItem alloc]initWithTitle:@"Clear" 
																   style:UIBarButtonItemStylePlain
																  target:self 
																  action:@selector(clearSearch:)];
	self.navigationItem.rightBarButtonItem = clearButton;
	[clearButton release];
	
	self.content = [NSMutableArray arrayWithCapacity:0];
	
	self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	self.searchBar.placeholder = [NSString stringWithFormat:@"Ex. %@, Suburb Name", state];
	self.searchBar.tintColor = [UIColor brownColor];
	
	self.tableView.backgroundColor = [UIColor clearColor];
	
	self.navigationItem.title = @"Select Suburb(s)";
	
	self.tableView.sectionHeaderHeight = 18.0;
	
	self.lastLoadedIndex = 0;
	
	FMResultSet *rs = [self.appDelegate.userdb executeQuery:[NSString stringWithFormat:@"select suburbs from searches where id = ? limit 1 offset 0"], self.searchID];
	
	if ([rs next]) {
		self.selectedSuburbs = [rs stringForColumn:@"suburbs"];
	}
	[rs close];
	
	if (!self.selectedSuburbs || [self.selectedSuburbs length] == 0) {
		self.selectedSuburbs = @"";
	}
}

- (void)stateChanged:(id)sender
{
	NSString *state = [self.appDelegate.userDefaults valueForKey:State];
	if (![state isEqualToString:self.currentState]) {
		[self.stateButton setTitle:state forState:UIControlStateNormal];
		[self.stateButton setTitle:state forState:UIControlStateHighlighted];
		[self.stateButton setTitle:state forState:UIControlStateDisabled];
		[self.stateButton setTitle:state forState:UIControlStateSelected];
		
		self.searchBar.placeholder = [NSString stringWithFormat:@"Ex. %@, Suburb Name", state];
		
		[self.content removeAllObjects];
		self.lastLoadedIndex = 0;
		self.selectorToUse = @selector(searchDB:);
		
		self.selectedSuburbs = @"";
		[self reloadTableContent:self];
		self.currentState = state;
	}
}

- (IBAction)showStateSelection:(id)sender
{
	StatesSearchController *controller = [[StatesSearchController alloc]initWithNibName:@"StatesSearchController" bundle:nil];
	[self.navigationController pushViewController:controller animated:TRUE];
	[controller release];
}


- (void)clearSearch:(id)sender
{
	self.selectedSuburbs = @"";
	[self.tableView reloadData];
}


// - (void)viewWillAppear:(BOOL)animated {
//	 
//	 
//	 [super viewWillAppear:animated];
// }

//- (void)viewWillAppear:(BOOL)animated
//{
//	[super viewWillAppear:animated];
//	
//	
//}


 - (void)viewDidAppear:(BOOL)animated {
	 [super viewDidAppear:animated];
	 //[self.appDelegate addNavigationOverlayInRect:CGRectMake(0.0, 107.0, 320.0, 9.0)];
	 [self.searchBar becomeFirstResponder];
 }


 - (void)viewWillDisappear:(BOOL)animated {
	 [super viewWillDisappear:animated];
	 [self.searchBar resignFirstResponder];
	 [self.appDelegate.userdb executeUpdate:@"UPDATE searches SET suburbs = ? where id = ?", self.selectedSuburbs, self.searchID];
 }


// - (void)viewDidDisappear:(BOOL)animated {
//	 [self.appDelegate addNavigationOverlayInRect:CGRectMake(0.0, 63.0, 320.0, 9.0)];
//	 
//	 [super viewDidDisappear:animated];
// }


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
	
	NSString *title = [[self.content objectAtIndex:indexPath.row]valueForKey:@"name"];
	
	


//	NSRange range = [self.selectedSuburbs rangeOfString:title];
//	if (range.location != NSNotFound) {
//		[cell setShowCheckmark:TRUE];
//	} else {
//		[cell setShowCheckmark:FALSE];
//	}
//	
	NSArray *arraySelected = [self.selectedSuburbs componentsSeparatedByString:@","];
	BOOL found = FALSE;
	for (NSString *suburbName in arraySelected) {
		if ([suburbName isEqual:title]) {
			found = TRUE;
		}
	}
	
	[cell setShowCheckmark:found];
	
	[cell setTitle:title];
	
    // Set up the cell...
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TransparentCell *cell = (TransparentCell *)[tableView cellForRowAtIndexPath:indexPath];
	
	
	NSString *title = [[self.content objectAtIndex:indexPath.row]valueForKey:@"name"];
	if (![[title lowercaseString] isEqual:@"show all"]) {
		if (cell.accessoryView) {
			NSString *comma = @",";
			if ([self.selectedSuburbs length] == [title length] || [self.selectedSuburbs hasPrefix:title]) {
				comma = @"";
			}
			
			self.selectedSuburbs = [self.selectedSuburbs stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@%@", comma, title] withString:@""];
		
		} else {
			NSString *comma = @"";
			if ([self.selectedSuburbs length] > 0) {
				comma = @",";
			}
			self.selectedSuburbs = [NSString stringWithFormat:@"%@%@%@", self.selectedSuburbs, comma, title];
			self.selectedSuburbs = [self.selectedSuburbs stringByReplacingOccurrencesOfString:@"Show All" withString:@""];
			self.selectedSuburbs = [self.selectedSuburbs stringByReplacingOccurrencesOfString:@",Show All" withString:@""];
			[self.tableView reloadData];
		}
	} else {
		if (cell.accessoryView) {
			self.selectedSuburbs = @"";
		} else {
			self.selectedSuburbs = @"Show All";
		}
		[self.tableView reloadData];
	}
	
	NSRange range = [self.selectedSuburbs rangeOfString:@","];
	if (range.location == 0) {
		self.selectedSuburbs = [self.selectedSuburbs substringFromIndex:range.length];
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	[self.searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[self.searchBar resignFirstResponder];
	[self.content removeAllObjects];
	self.lastLoadedIndex = 0;
	self.selectorToUse = @selector(searchDB:);
	[self searchDB:searchBar];
}

- (void)searchDB:(id)sender
{
	[self.appDelegate addLoadingView];
	
	SuburbsSearchFetching *operation = [[SuburbsSearchFetching alloc]initWithTarget:self
																			 action:@selector(reloadTableContent:) 
															   needRefreshInterface:TRUE 
																	 infoDictionary:nil
																			  queue:self.fetchingQueue];
	operation.searchString = [self.searchBar text];
	operation.lastLoadedIndex = self.lastLoadedIndex;
	
	[self.fetchingQueue addOperation:operation];
	[operation release];
	
	[self.tableView reloadData];
	
}

- (IBAction)findLocation:(id)sender;
{
	[self.searchBar resignFirstResponder];
	[self.content removeAllObjects];
	self.lastLoadedIndex = 0;
	self.selectorToUse = @selector(searchLocation:);
	[self searchLocation:self];
}

- (void)searchLocation:(id)sender
{
	[self.appDelegate addLoadingView];
	
	CLLocation *currentLocation = [self.appDelegate currentLocation];
	NSDictionary *infoDict = [NSMutableDictionary dictionaryWithCapacity:0];
	[infoDict setValue:currentLocation forKey:@"currentLocation"];
	
	LocationAppdbFetching *operation = [[LocationAppdbFetching alloc]initWithTarget:self
																			 action:@selector(reloadTableContent:) 
															   needRefreshInterface:TRUE 
																	 infoDictionary:infoDict
																			  queue:self.fetchingQueue];
	operation.gpsRadius = [self.appDelegate.userDefaults floatForKey:GPSRadius]*1000;
	operation.lastLoadedIndex = self.lastLoadedIndex;
	[self.fetchingQueue addOperation:operation];
	[operation release];
	
	[self.tableView reloadData];
}



- (void)reloadTableContent:(id)sender
{
	NSArray *content = [sender valueForKey:@"content"];
	for (NSDictionary *suburb in content) {
		[self.content addObject:suburb];
	}
	
	if ([content count] > 15) {
		// should show view with more
		ShowNextResultView *footerView = [[ShowNextResultView alloc]initWithFrame:CGRectMake(0.0, 0.0, 320.0, 30.0)];
		footerView.title = @"Click for more...";
		footerView.target = self;
		footerView.selector = self.selectorToUse;
		self.tableView.tableFooterView = footerView;
		[footerView release];
		self.lastLoadedIndex += 16;
	} else {
		self.tableView.tableFooterView = nil;
		self.lastLoadedIndex += [content count];
	}
	
	
	[self.appDelegate removeLoadingView];
	[self.tableView reloadData];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
	[_currentState release];
	[_stateButton release];
	[_searchID release];
	[_selectedSuburbs release];
	[_fetchingQueue release];
	[_content release];
	[_searchBar release];
	[_tableView release];
	
	[super dealloc];
}

@end
