//
//  PropertyController.m
//  ozEstate
//
//  Created by Anthony Mittaz on 5/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import "PropertyController.h"
#import "ListingTitleView.h"
#import "TransparentCell.h"

@implementation PropertyController

@synthesize content=_content;
@synthesize favorite=_favorite;
@synthesize property_id=_property_id;
@synthesize pageIndex=_pageIndex;

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
	
	self.content = [NSArray arrayWithObjects:@"Photos", @"More Infos", @"Show Map", @"Agency", nil];
	
	self.tableView.sectionHeaderHeight = 18.0;
	
	[self fetchDb];
	
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadPropertyForPropertyId:) name:ShouldReloadPropertyForPropertyId object:nil];
}

- (void)fetchDb
{
	ListingTitleView *backgroundView = (id)self.tableView.tableHeaderView;
	if (!backgroundView) {
		CGRect cellFrame = CGRectMake(0.0, 0.0, 320.0, 150.0);
		// BackgroundView
		backgroundView = [ListingTitleView viewWithFrame:cellFrame selected:FALSE];
		backgroundView.photoFrameTarget = self;
		backgroundView.photoFrameSelector = @selector(pushPhotoViewController:);
		backgroundView.noteTarget = self;
		backgroundView.noteSelector = @selector(pushMoreInfosController:);	
		self.tableView.tableHeaderView = backgroundView;
	}
	
	FMResultSet *rs = [self.appDelegate.userdb executeQuery:[NSString stringWithFormat:@"select properties.state_name,properties.suburb_name,properties.id as property_id,properties.price,properties.bathroom_number,properties.bedroom_number,properties.garage_number,properties.latitude,properties.longitude,properties.street_name,images.data,images.url,images.id from properties,images where properties.id =  ? and properties.id=images.property_id and images.preview = ?"],  self.property_id, [NSNumber numberWithBool:TRUE]];
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
	if (!suburb || [suburb length] == 0) {
		suburb = @"n/a";
	} else {
		suburb = [suburb uppercaseString];
	}
	
	[backgroundView setTitle:suburb];
	[backgroundView setBedroomNumber:bedroom];
	[backgroundView setBathroomNumber:bathroom];
	[backgroundView setGarageNumber:garage];
	[backgroundView setPrice:price];
	[backgroundView setStreetName:street];
	
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
			[backgroundView setDistance:distanceString];
		}
	}
	
	[location release];
	
	if (!imageData || [imageData length] == 0) {
		if (imageURL && imageId) {
			[self.appDelegate.dataFetcher downloadImageForRowName:@"data" withId:imageId atURL:imageURL forCellView:backgroundView];
		}
	} else {
		UIImage *image = [[UIImage alloc]initWithData:imageData];
		[backgroundView setPropertyImage:image];
		[image release];
	}
	[backgroundView setNeedsDisplay];
}

- (void)reloadPropertyForPropertyId:(id)sender
{
	if ([[sender object]isEqual:self.property_id]) {
		[self fetchDb];
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
	if ([title isEqual:@"Photos"]) {
		imageName = @"photo_icon.png";
	} else if ([title isEqual:@"More Infos"]) {
		imageName = @"info_icon.png";
	} else if ([title isEqual:@"Show Map"]) {
		imageName = @"web_icon.png";
	} else if ([title isEqual:@"Agency"]) {
		imageName = @"agency_icon.png";
	}
	
	[cell setImage:[self.appDelegate cachedImage:imageName]];
	[cell setTitle:title];
    
    // Set up the cell...

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//Navigation logic may go here. Create and push another view controller.
	
	NSString *title = [self.content objectAtIndex:indexPath.row];
	if ([title isEqual:@"Photos"]) {
		[self pushPhotoViewController:self.property_id];
	} else if ([title isEqual:@"Show Map"]) {
		[self openMap:self];
	} else if ([title isEqual:@"More Infos"]) {
		[self pushMoreInfosController:self.property_id];
	} else if ([title isEqual:@"Agency"]) {
		[self pushAgencyController:self.property_id];
	}
	[self.tableView deselectRowAtIndexPath:indexPath animated:TRUE];
}

- (IBAction)pushPhotoViewController:(id)sender
{
	 [[NSNotificationCenter defaultCenter] postNotificationName:ShouldPushPhotoViewController object:self.property_id];
}

- (IBAction)pushMoreInfosController:(id)sender
{
	 [[NSNotificationCenter defaultCenter] postNotificationName:ShouldPushMoreInfosController object:self.property_id];
}

- (IBAction)pushAgencyController:(id)sender
{
	 [[NSNotificationCenter defaultCenter] postNotificationName:ShouldPushAgencyController object:self.property_id];
}

#pragma mark -
#pragma mark - Map

- (IBAction)openMap:(id)sender
{
	FMResultSet *rs = [self.appDelegate.userdb executeQuery:[NSString stringWithFormat:@"select street_name,suburb_name,state_name from properties where properties.id =  ?"],  self.property_id];
	NSString *street = nil;
	NSString *suburb = nil;
	NSString *state = nil;
	if ([rs next]) {
		street = [rs stringForColumn:@"street_name"];
		suburb = [rs stringForColumn:@"suburb_name"];
		state = [rs stringForColumn:@"state_name"];
	}
	[rs close];
	
	if (!street || [street length] == 0) {
		street = @"";
	} else {
		street = [street capitalizedString];
	}
	if (!suburb || [suburb length] == 0) {
		suburb = @"";
	} else {
		suburb = [suburb capitalizedString];
	}
	
	if (!state || [state length] == 0) {
		state = @"";
	} else {
		state = [state capitalizedString];
	}
	
	if (state && suburb) {
		//NSString *map = [NSString stringWithFormat:@"http://maps.google.com/maps?ll=%f,%f&z=%d", latitude, longitude,MAP_ZOOM_LEVEL];
		NSString *map = [self urlEncodeValue:[NSString stringWithFormat:@"http://maps.google.com/maps?f=q&hl=en&geocode=&q=%@,%@,%@", street, suburb, state]];
		
		[[UIApplication sharedApplication]openURL:[NSURL URLWithString:map]];
	}
}

- (NSString *)urlEncodeValue:(NSString *)string
{
	CFStringRef originalURLString = (CFStringRef)string;
	CFStringRef preprocessedString = CFURLCreateStringByAddingPercentEscapes(NULL, originalURLString, NULL, (CFStringRef)@"", kCFStringEncodingUTF8);
	//CFStringRef urlString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, preprocessedString, NULL, (CFStringRef)@";/?:@&=+$", kCFStringEncodingUTF8);
	NSString *stringToReturn = [NSString stringWithString:(NSString *)preprocessedString];
	CFRelease(preprocessedString);
	return stringToReturn;
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
	[_content release];
	
	[super dealloc];
}


@end

