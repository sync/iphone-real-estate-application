//
//  PropertiesController.m
//  ozEstate
//
//  Created by Anthony Mittaz on 12/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import "PropertiesController.h"
#import "ListingCell.h"
#import "ViewWithImage.h"
#import "PropertyControllerContainer.h"
#import <CoreLocation/CoreLocation.h>

@implementation PropertiesController

@synthesize state=_state;

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
	return FALSE;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self loadAppDelegate];
	
	if (self.appDelegate.savedLocation != nil) {
		[self.appDelegate.savedLocation replaceObjectAtIndex:2 withObject:@"-1"];
	}
	
}

- (void)restoreLevelWithSelectionArray:(NSArray *)selectionArray
{	
	[self loadAppDelegate];
	
	if ([selectionArray count] > 1) {	
		NSArray *offsetArray = [[selectionArray objectAtIndex:1]componentsSeparatedByString:@","];
		if ([offsetArray count] > 1) {
			NSInteger section = [[offsetArray objectAtIndex:0]integerValue];
			NSInteger row = [[offsetArray objectAtIndex:1]integerValue];
			if (section != -1 && row != -1) {
				NSString *title = [self suburbNameForSection:section];
				NSNumber *property_id = [NSNumber numberWithInteger:[self.appDelegate.userdb intForQuery:[NSString stringWithFormat:@"select id from properties where favorite = ? and properties.suburb_name = ? and properties.state_name = ? limit 1 offset %d", row],  [NSNumber numberWithBool:[self isFavorite]], title, self.state]];
				if (property_id && [property_id integerValue] != 0) {	
					NSInteger initialPosition = [self initialPositionForPropertyId:property_id];
				
					PropertyControllerContainer *viewController = [[PropertyControllerContainer alloc] initWithNibName:@"PropertyControllerContainer" bundle:nil];
					viewController.initialPosition = initialPosition;
					viewController.property_id = property_id;
					viewController.favorite = [self isFavorite];
					viewController.state = self.state;
					[self.navigationController pushViewController:viewController animated:FALSE];
					[viewController release];
				}
			}
		}
	}
}


- (void)viewDidLoad {
	[super viewDidLoad];
	
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadTableView:) name:ShouldReloadPropertiesTableView object:nil];
	
	self.tableView.sectionHeaderHeight = 73.0;
	self.tableView.sectionFooterHeight = 10.0;
	self.tableView.rowHeight = 130.0;
	
	[self addOrRemoveClearButton];
	
	self.navigationItem.title = self.state;
}

- (void)addOrRemoveClearButton
{
	// add clear button
	NSInteger count = [self.appDelegate.userdb intForQuery:@"select count(distinct(suburb_name)) from properties where favorite = ? and state_name = ?", [NSNumber numberWithBool:[self isFavorite]], self.state];
	if (count > 0) {
		UIBarButtonItem *clearButton = [[UIBarButtonItem alloc]initWithTitle:@"Clear" 
																	   style:UIBarButtonItemStylePlain
																	  target:self 
																	  action:@selector(clear:)];
		[self.navigationItem setRightBarButtonItem:clearButton animated:FALSE];
		[clearButton release];
	} else {
		[self.navigationItem setRightBarButtonItem:nil animated:FALSE];
	}
}

- (void)clear:(id)sender
{
	[self.appDelegate.userdb executeUpdate:@"delete from images where property_id in (select id from properties where favorite = ? and state_name = ?)", [NSNumber numberWithBool:[self isFavorite]], self.state];
	[self.appDelegate.userdb executeUpdate:@"delete from properties where favorite = ? and state_name = ?", [NSNumber numberWithBool:[self isFavorite]], self.state];
	[self reloadTableView:self];
	[self.navigationController popToRootViewControllerAnimated:FALSE];
	[[NSNotificationCenter defaultCenter] postNotificationName:ShouldReloadFavoritesStatesController object:nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:ShouldReloadRecentsStatesController object:nil];
}

- (void)reloadTableView:(id)sender
{
	[self.tableView reloadData];
	[self addOrRemoveClearButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark Table view methods

- (NSString *)suburbNameForSection:(NSInteger)section
{
	NSString *suburb = [self.appDelegate.userdb stringForQuery:[NSString stringWithFormat:@"select distinct(suburb_name) from properties where favorite = ? and state_name = ? order by suburb_name ASC limit 1 offset %d", section], [NSNumber numberWithBool:[self isFavorite]], self.state];
	return suburb;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = [self.appDelegate.userdb intForQuery:@"select count(distinct(suburb_name)) from properties where favorite = ? and state_name = ?", [NSNumber numberWithBool:[self isFavorite]], self.state];
	if (count == 0) {
		return 1;
	}
	return count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	CGRect cellFrame = CGRectMake(0.0, 0.0, 320.0, 73.0);
	// BackgroundView
	ViewWithImage *backgroundView = [ViewWithImage viewWithFrame:cellFrame andBackgroundImage:[self.appDelegate cachedImage:@"title_view.png"]];
	NSString *title = [self suburbNameForSection:section];
	if (!title) {
		title = @"Nothing yet. Move Along.";
	}
	backgroundView.title = title;
	return backgroundView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	//	CGRect cellFrame = CGRectMake(0.0, 0.0, 320.0, 41.0);
	//	// BackgroundView
	//	ViewWithImage *backgroundView = [ViewWithImage viewWithFrame:cellFrame andBackgroundImage:[(ozEstateAppDelegate *)[[UIApplication sharedApplication]delegate] cachedImage:@"section_footer_background.png"]];
	//	return backgroundView;
	return nil;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//	return @"KELVIN GROVE";
//}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSString *title = [self suburbNameForSection:section];
	if (!title) {
		return 0;
	}
	NSInteger count = [self.appDelegate.userdb intForQuery:[NSString stringWithFormat:@"select count(id) from properties where favorite = ? and suburb_name = ? and state_name = ?", section], [NSNumber numberWithBool:[self isFavorite]], title, self.state];
	
	return count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ListingCell *cell = (ListingCell *)[tableView dequeueReusableCellWithIdentifier:NormalListingCell];
    if (cell == nil) {
        cell = [[[ListingCell alloc] initWithFrame:CGRectZero reuseIdentifier:NormalListingCell] autorelease];
    }
	
	NSString *title = [self suburbNameForSection:indexPath.section];
	
	FMResultSet *rs = [self.appDelegate.userdb executeQuery:[NSString stringWithFormat:@"select properties.state_name,properties.suburb_name,properties.id as property_id,properties.price,properties.bathroom_number,properties.bedroom_number,properties.garage_number,properties.latitude,properties.longitude,properties.street_name,images.data,images.url,images.id from properties,images where properties.favorite = ? and properties.suburb_name = ? and properties.state_name = ? and properties.id=images.property_id and images.preview = ? limit 1 offset %d", indexPath.row],  [NSNumber numberWithBool:[self isFavorite]], title, self.state, [NSNumber numberWithBool:TRUE]];
	NSString *bedroom = nil;
	NSString *bathroom = nil;
	NSString *garage = nil;
	NSString *price = nil;
	NSString *street = nil;
	NSString *suburb = nil;
	NSString *state = nil;
	NSString *imageURL = nil;
	NSData *imageData = nil;
	NSNumber *imageId = nil;
	NSNumber *property_id = nil;
	CLLocation *location = nil;
	if ([rs next]) {
		bedroom = [rs stringForColumn:@"bedroom_number"];
		bathroom = [rs stringForColumn:@"bathroom_number"];
		garage = [rs stringForColumn:@"garage_number"];
		price = [rs stringForColumn:@"price"];
		street = [rs stringForColumn:@"street_name"];
		suburb = [rs stringForColumn:@"suburb_name"];
		state = [rs stringForColumn:@"state_name"];
		imageURL = [rs stringForColumn:@"url"];
		imageData = [rs dataForColumn:@"data"];
		imageId = [NSNumber numberWithInteger:[rs intForColumn:@"id"]];
		property_id = [NSNumber numberWithInteger:[rs intForColumn:@"property_id"]];
		location = [[CLLocation alloc]initWithLatitude:[rs doubleForColumn:@"latitude"] longitude:[rs doubleForColumn:@"longitude"]];
	}
	[rs close];
	
	if (!bedroom || [bedroom length] == 0) {
		bedroom = @"-";
	} else if ([[bedroom lowercaseString] isEqual:@"studio"]) {
		bedroom = @"st";
	}
	if (!bathroom || [bathroom length] == 0) {
		bathroom = @"-";
	}
	if (!garage || [garage length] == 0) {
		garage = @"-";
	}
	if (!price || [price length] == 0) {
		price = @"n/a";
	} else {
		CFLocaleRef currentLocale = CFLocaleCopyCurrent();
		CFNumberFormatterRef customCurrencyFormatter = CFNumberFormatterCreate
		(NULL, currentLocale, kCFNumberFormatterCurrencyStyle);
		CFNumberFormatterSetFormat(customCurrencyFormatter, CFSTR("#,##0;n/a;($#,##0)"));
		
		CGFloat floatNumer = [price floatValue];
		CFNumberRef number = CFNumberCreate(NULL, kCFNumberFloatType, &floatNumer);
		
		CFStringRef formattedStringNumber = CFNumberFormatterCreateStringWithNumber(NULL, customCurrencyFormatter, number);
		
		NSString *stringWithFormat = [NSString stringWithString:(NSString *)formattedStringNumber];
		
		// Memory management
		CFRelease(currentLocale);
		CFRelease(customCurrencyFormatter);
		CFRelease(number);
		CFRelease(formattedStringNumber);
		
		price = stringWithFormat;		
	}
	if (!street || [street length] == 0) {
		street = @"n/a";
	} else {
		street = [street capitalizedString];
	}
	
	if (!location || (location.coordinate.longitude == 0.0 && location.coordinate.latitude == 0.0)) {
		NSMutableArray *propertiesForCoordinates = [NSMutableArray arrayWithCapacity:0];
		NSMutableDictionary *aDict = [NSMutableDictionary dictionaryWithCapacity:0];
		[aDict setValue:property_id forKey:@"property_id"];
		[aDict setValue:street forKey:@"street_name"];
		[aDict setValue:suburb forKey:@"suburb_name"];
		[aDict setValue:state forKey:@"state_name"];
		[propertiesForCoordinates addObject:aDict];
		// add coordinates
		[self.appDelegate.dataFetcher addCoordinatesToProperties:propertiesForCoordinates];
	} else {	
		if (location && self.appDelegate.currentLocation && !(location.coordinate.longitude == 0.0 && location.coordinate.latitude == 0.0)) {
			CLLocationDistance distanceInMeters = [self.appDelegate.currentLocation getDistanceFrom:location];
			
			// Round number to one decimal
			NSDecimalNumber *aDistanceDecimal = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",distanceInMeters/1000]];
			NSDecimalNumberHandler *handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain
																									 scale:1
																						  raiseOnExactness:NO
																						   raiseOnOverflow:NO
																						  raiseOnUnderflow:NO
																					   raiseOnDivideByZero:NO];
			aDistanceDecimal = [aDistanceDecimal decimalNumberByRoundingAccordingToBehavior:handler];
			
			NSString *distanceString = [NSString stringWithFormat:@"%@ km", aDistanceDecimal];
			[cell setDistance:distanceString];
		}
	}
	
	[location release];
	
	[cell setBedroomNumber:bedroom];
	[cell setBathroomNumber:bathroom];
	[cell setGarageNumber:garage];
	[cell setPrice:price];
	[cell setStreetName:street];
	
	if (!imageData || [imageData length] == 0) {
		if (imageURL && imageId) {
			[self.appDelegate.dataFetcher downloadImageForRowName:@"data" withId:imageId atURL:imageURL forCellView:(ListingCellView *)[cell viewWithTag:LISTING_CELL_VIEW]];
		}
	} else {
		UIImage *image = [[UIImage alloc]initWithData:imageData];
		CGSize imageSize = image.size;
		
		BOOL redownload = FALSE;
		
		if (!image) {
			redownload = TRUE;
		}
		
		if (CGSizeEqualToSize(imageSize,CGSizeZero)) {
			redownload = TRUE;
		}
		if (redownload) {
			if (imageURL && imageId) {
				[self.appDelegate.dataFetcher downloadImageForRowName:@"data" withId:imageId atURL:imageURL forCellView:(ListingCellView *)[cell viewWithTag:LISTING_CELL_VIEW]];
			}
		}
		[cell setPropertyImage:image];
		[image release];
	}
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	NSString *title = [self suburbNameForSection:indexPath.section];
	NSNumber *property_id = [NSNumber numberWithInteger:[self.appDelegate.userdb intForQuery:[NSString stringWithFormat:@"select id from properties where favorite = ? and properties.suburb_name = ? and properties.state_name = ? limit 1 offset %d", indexPath.row],  [NSNumber numberWithBool:[self isFavorite]], title, self.state]];
	if (property_id && [property_id integerValue] != 0) {	
		NSInteger initialPosition = [self initialPositionForPropertyId:property_id];
		
		PropertyControllerContainer *viewController = [[PropertyControllerContainer alloc] initWithNibName:@"PropertyControllerContainer" bundle:nil];
		viewController.initialPosition = initialPosition;
		viewController.property_id = property_id;
		viewController.favorite = [self isFavorite];
		viewController.state = self.state;
		[self.navigationController pushViewController:viewController animated:TRUE];
		[viewController release];
	}
	
	[self.appDelegate.savedLocation replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%d,%d", indexPath.section, indexPath.row]];
}

- (NSInteger)initialPositionForPropertyId:(NSNumber *)property_id
{
	return 0;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//	if (editingStyle == UITableViewCellEditingStyleDelete) {
//		NSString *title =[self suburbNameForSection:indexPath.section];
//		NSNumber *property_id = [NSNumber numberWithInteger:[self.appDelegate.userdb intForQuery:[NSString stringWithFormat:@"select id from properties where favorite = ? and properties.suburb_name = ? limit 1 offset %d", indexPath.row],  [NSNumber numberWithBool:[self isFavorite]], title]];
//		
//		[self.appDelegate.userdb executeUpdate:@"delete from images where property_id = ?", property_id];
//		[self.appDelegate.userdb executeUpdate:@"delete from properties where id = ?", property_id];
//		[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:TRUE];
//	}
//}


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
	[_state release];
	
    [super dealloc];
}

@end
