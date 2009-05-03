//
//  SearchController.m
//  ozEstate
//
//  Created by Anthony Mittaz on 7/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import "SearchController.h"
#import "BigPaperView.h"
#import "SmallPaperView.h"
#import "SmallSubtitlePaperView.h"
#import "SuburbsSearchController.h"
#import "MinMaxSearchController.h"
#import "PropertyTypesSearchController.h"

@implementation SearchController

@synthesize suburbsListView=_suburbsListView;
@synthesize propertyTypesView=_propertyTypesView;
@synthesize bedroomView=_bedroomView;
@synthesize garageView=_garageView;
@synthesize bathroomView=_bathroomView;
@synthesize priceView=_priceView;
@synthesize searchID=_searchID;
@synthesize currentPageNumber=_currentPageNumber;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self loadAppDelegate];
	
	if (self.searchID) {
		[self queryDB];
	}
	
	if (self.appDelegate.savedLocation != nil) {
		[self.appDelegate.savedLocation replaceObjectAtIndex:1 withObject:@"-1"];
	}
	
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	// add start button
	UIBarButtonItem *startButton = [[UIBarButtonItem alloc]initWithTitle:@"Start" 
																   style:UIBarButtonItemStylePlain
																  target:self 
																  action:@selector(startSearch:)];
	self.navigationItem.rightBarButtonItem = startButton;
	[startButton release];
	
	// add clear button
	UIBarButtonItem *clearButton = [[UIBarButtonItem alloc]initWithTitle:@"Clear" 
																   style:UIBarButtonItemStylePlain
																  target:self 
																  action:@selector(clearSearch:)];
	self.navigationItem.leftBarButtonItem = clearButton;
	[clearButton release];
	
	
	self.searchID = [NSNumber numberWithInteger:[self.appDelegate.userdb intForQuery:@"select id from searches order by created_at DESC limit 1 offset 0"]];
	if (![self.appDelegate.userdb stringForQuery:@"select id from searches order by created_at DESC limit 1 offset 0"]) {
		// Init a new search row
		[self.appDelegate.userdb executeUpdate:@"insert into searches (created_at) values (?)", [NSDate date]];
		self.searchID = [NSNumber numberWithInteger:[self.appDelegate.userdb lastInsertRowId]];
	}
		
	
	// Setup search views
	// Suburbs
	self.suburbsListView.target = self;
	self.suburbsListView.selector = @selector(editSuburbs:);
	self.suburbsListView.rotation = (0.0*M_PI)/180.0;
	// Types
	self.propertyTypesView.title  = @"Type";
	self.propertyTypesView.target = self;
	self.propertyTypesView.selector = @selector(editPropertyTypes:);
	self.propertyTypesView.rotation = (-1.7*M_PI)/180.0;
	// Bedroom
	self.bedroomView.title = @"Bed";
	self.bedroomView.target = self;
	self.bedroomView.selector = @selector(editBedroomNumber:);
	self.bedroomView.rotation = (-2.3*M_PI)/180.0;
	// Garage
	self.garageView.title = @"Garage";
	self.garageView.target = self;
	self.garageView.selector = @selector(editGaragemNumber:);
	self.garageView.rotation = (2.0*M_PI)/180.0;
	// Bathroom
	self.bathroomView.title = @"Bath";
	self.bathroomView.target = self;
	self.bathroomView.selector = @selector(editBathdroomNumber:);
	self.bathroomView.rotation = (0.0*M_PI)/180.0;
	// Price
	self.priceView.title = @"Price";
	self.priceView.target = self;
	self.priceView.selector = @selector(editPrice:);
	self.priceView.rotation = (0.5*M_PI)/180.0;
	
	[self queryDB];
	
	self.currentPageNumber = 0;
	
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(searchShouldGoNext:) name:SearchShouldGoNext object:nil];
}

- (void)clearSearch:(id)sender
{
	[self.appDelegate.userdb executeUpdate:@"delete from searches"];
	
	self.searchID = [NSNumber numberWithInteger:[self.appDelegate.userdb intForQuery:@"select id from searches order by created_at DESC limit 1 offset 0"]];
	if (![self.appDelegate.userdb stringForQuery:@"select id from searches order by created_at DESC limit 1 offset 0"]) {
		// Init a new search row
		[self.appDelegate.userdb executeUpdate:@"insert into searches (created_at) values (?)", [NSDate date]];
		self.searchID = [NSNumber numberWithInteger:[self.appDelegate.userdb lastInsertRowId]];
	}
	[self queryDB];
	
	[self.appDelegate removeSearchCanGoNext:self];
}

- (void)queryDB
{
	FMResultSet *rs = [self.appDelegate.userdb executeQuery:[NSString stringWithFormat:@"select * from searches where id = ? limit 1 offset 0"], self.searchID];
	NSString *state = nil;
	NSString *suburbs = nil;
	NSString *types = nil;
	NSString *bedroomMin = nil;
	NSString *bedroomMax = nil;
	NSString *bathroomMin = nil;
	NSString *bathroomMax = nil;
	NSString *garageMin = nil;
	NSString *garageMax = nil;
	NSString *priceMin = nil;
	NSString *priceMax = nil;
	if ([rs next]) {
		state = [rs stringForColumn:@"state"];
		suburbs = [rs stringForColumn:@"suburbs"];
		types = [rs stringForColumn:@"property_types"];
		bedroomMin = [rs stringForColumn:@"bedroom_min"];
		bedroomMax = [rs stringForColumn:@"bedroom_max"];
		bathroomMin = [rs stringForColumn:@"bathroom_min"];
		bathroomMax = [rs stringForColumn:@"bathroom_max"];
		garageMin = [rs stringForColumn:@"garage_min"];
		garageMax = [rs stringForColumn:@"garage_max"];
		priceMin = [rs stringForColumn:@"price_min"];
		priceMax = [rs stringForColumn:@"price_max"];
	} 
	[rs close];
	
	// State
	if (!state || [state length] == 0) {
		state = [self.appDelegate.userDefaults valueForKey:State];
	}
	self.suburbsListView.title = state;
	
	
	// Suburbs
	if (!suburbs || [suburbs length] == 0) {
		suburbs = @"All";
	}
	self.suburbsListView.subtitle = suburbs;
	[self.suburbsListView setNeedsDisplay];
	
	// Types
	if (!types || [types length] == 0) {
		types = @"All";
	}
	self.propertyTypesView.subtitle = types;
	[self.propertyTypesView setNeedsDisplay];
	
	// Bedroom
	if (!bedroomMin || [bedroomMin length] == 0) {
		bedroomMin = @"All";
	}
	if (!bedroomMax || [bedroomMax length] == 0) {
		bedroomMax = @"All";
	}
	self.bedroomView.min = [NSString stringWithFormat:@"Min: %@", bedroomMin];
	self.bedroomView.max =[NSString stringWithFormat:@"Max: %@", bedroomMax];
	[self.bedroomView setNeedsDisplay];
	
	// Garage
	if (!garageMin || [garageMin length] == 0) {
		garageMin = @"All";
	}
	if (!garageMax || [garageMax length] == 0) {
		garageMax = @"All";
	}
	self.garageView.min = [NSString stringWithFormat:@"Min: %@", garageMin];
	self.garageView.max = [NSString stringWithFormat:@"Max: %@", garageMax];
	[self.garageView setNeedsDisplay];
	
	// Bathroom
	if (!bathroomMin || [bathroomMin length] == 0) {
		bathroomMin = @"All";
	}
	if (!bathroomMax || [bathroomMax length] == 0) {
		bathroomMax = @"All";
	}
	self.bathroomView.min = [NSString stringWithFormat:@"Min: %@", bathroomMin];
	self.bathroomView.max = [NSString stringWithFormat:@"Max: %@", bathroomMax];
	[self.bathroomView setNeedsDisplay];
	
	// Price
	if (!priceMin || [priceMin length] == 0) {
		priceMin = @"All";
	}
	if (!priceMax || [priceMax length] == 0) {
		priceMax = @"All";
	}
	self.priceView.min = [NSString stringWithFormat:@"Min: %@", priceMin];
	self.priceView.max = [NSString stringWithFormat:@"Max: %@", priceMax];
	[self.priceView setNeedsDisplay];
}

- (IBAction)editSuburbs:(id)sender
{
	SuburbsSearchController *controller = [[SuburbsSearchController alloc]initWithNibName:@"SuburbsSearchController" bundle:nil];
	controller.searchID = self.searchID;
	[self.navigationController pushViewController:controller animated:TRUE];
	[controller release];
}

- (IBAction)editBedroomNumber:(id)sender
{
	MinMaxSearchController *controller = [[MinMaxSearchController alloc]initWithNibName:@"MinMaxSearchController" bundle:nil];
	controller.navigationItem.title = @"Bedroom";
	controller.searchID = self.searchID;
	controller.propertyName = @"bedroom";
	[self.navigationController pushViewController:controller animated:TRUE];
	[controller release];
}
- (IBAction)editBathdroomNumber:(id)sender
{
	MinMaxSearchController *controller = [[MinMaxSearchController alloc]initWithNibName:@"MinMaxSearchController" bundle:nil];
	controller.navigationItem.title = @"Bathroom";
	controller.searchID = self.searchID;
	controller.propertyName = @"bathroom";
	[self.navigationController pushViewController:controller animated:TRUE];
	[controller release];
}
- (IBAction)editGaragemNumber:(id)sender
{
	MinMaxSearchController *controller = [[MinMaxSearchController alloc]initWithNibName:@"MinMaxSearchController" bundle:nil];
	controller.navigationItem.title = @"Garage";
	controller.searchID = self.searchID;
	controller.propertyName = @"garage";
	[self.navigationController pushViewController:controller animated:TRUE];
	[controller release];
}
- (IBAction)editPrice:(id)sender
{
	MinMaxSearchController *controller = [[MinMaxSearchController alloc]initWithNibName:@"MinMaxSearchController" bundle:nil];
	controller.navigationItem.title = @"Price";
	controller.searchID = self.searchID;
	controller.propertyName = @"price";
	[self.navigationController pushViewController:controller animated:TRUE];
	[controller release];
}

- (IBAction)editPropertyTypes:(id)sender
{
	PropertyTypesSearchController *controller = [[PropertyTypesSearchController alloc]initWithNibName:@"PropertyTypesSearchController" bundle:nil];
	controller.searchID = self.searchID;
	[self.navigationController pushViewController:controller animated:TRUE];
	[controller release];
}

- (IBAction)startSearch:(id)sender
{
	self.currentPageNumber = 0;
	
	NSString *urlSearchString = [self setupSearchUrlString];
	
	[self launchSearchWithUrlString:urlSearchString];
}

- (void)searchShouldGoNext:(id)sender
{
	[self.appDelegate removeSearchCanGoNext:self];
	
	self.currentPageNumber += 10;
	
	NSString *urlSearchString = [self setupSearchUrlString];
	
	[self launchSearchWithUrlString:urlSearchString];
}

- (void)launchSearchWithUrlString:(NSString *)urlSearchString
{
	// Bathroom
	NSNumber *minBathroomNumber = nil;
	NSString *minBathroomValue = self.bathroomView.min;
	minBathroomValue = [minBathroomValue stringByReplacingOccurrencesOfString:@"Min: " withString:@""];
	minBathroomValue = [minBathroomValue stringByReplacingOccurrencesOfString:@"Max: " withString:@""];
	if ([minBathroomValue length] > 0 && ![minBathroomValue isEqual:@"All"]) {
		minBathroomNumber = [NSNumber numberWithInteger:[minBathroomValue integerValue]];
	}
	NSNumber *maxBathroomNumber = nil;
	NSString *maxBathroomValue = self.bathroomView.max;
	maxBathroomValue = [maxBathroomValue stringByReplacingOccurrencesOfString:@"Min: " withString:@""];
	maxBathroomValue = [maxBathroomValue stringByReplacingOccurrencesOfString:@"Max: " withString:@""];
	if ([maxBathroomValue length] > 0 && ![maxBathroomValue isEqual:@"All"]) {
		maxBathroomNumber = [NSNumber numberWithInteger:[maxBathroomValue integerValue]];
	}
	
	// Garage
	NSNumber *minGarageNumber = nil;
	NSString *minGarageValue = self.garageView.min;
	minGarageValue = [minGarageValue stringByReplacingOccurrencesOfString:@"Min: " withString:@""];
	minGarageValue = [minGarageValue stringByReplacingOccurrencesOfString:@"Max: " withString:@""];
	if ([minGarageValue length] > 0 && ![minGarageValue isEqual:@"All"]) {
		minGarageNumber = [NSNumber numberWithInteger:[minGarageValue integerValue]];
	}
	NSNumber *maxGarageNumber = nil;
	NSString *maxGarageValue = self.garageView.max;
	maxGarageValue = [maxGarageValue stringByReplacingOccurrencesOfString:@"Min: " withString:@""];
	maxGarageValue = [maxGarageValue stringByReplacingOccurrencesOfString:@"Max: " withString:@""];
	if ([maxGarageValue length] > 0 && ![maxGarageValue isEqual:@"All"]) {
		maxGarageNumber = [NSNumber numberWithInteger:[maxGarageValue integerValue]];
	}
	
	[self.appDelegate.dataFetcher launchPropertySearchWithURLString:urlSearchString minBathroomNumber:minBathroomNumber maxBathroomNumber:maxBathroomNumber minGarageNumber:minGarageNumber maxGarageNumber:maxGarageNumber andStateName:self.suburbsListView.title];	
}


- (NSString *)setupSearchUrlString
{
	// Get the corresponding property types values
	NSDictionary *correspondingTypes = [NSDictionary dictionaryWithContentsOfFile:[self.appDelegate bundlePathForRessource:@"realestate_propertyTypeList" ofType:@"dict"]];
	NSString *realTypes = self.propertyTypesView.subtitle;
	if ([realTypes isEqual:@"All"]) {
		realTypes = @"Show All";
	}
	
	for (NSString *key in correspondingTypes) {
		realTypes = [realTypes stringByReplacingOccurrencesOfString:key withString:[correspondingTypes valueForKey:key]];
	}
	
	// Compose url
	// note &is=1 means include surrounding but we are not should define this on the user prefs
	NSString *urlSearchString = nil;
	if (__IS_FOR_SALE__) {
		urlSearchString = @"http://www.realestate.com.au/cgi-bin/rsearch?a=s&cu=fn-rea&t=res&snf=rbs&chk=0&s=&tb=&is=0&pm=&px=&minbed=&maxbed=&cat=&f=&p=10&print=1";
	} else {
		urlSearchString = @"http://www.realestate.com.au/cgi-bin/rsearch?a=s&cu=fn-rea&t=ren&snf=rbs&chk=0&s=&tb=&is=0&pm=&px=&minbed=&maxbed=&cat=&f=&p=10&print=1";
	}
	
	// Page
	urlSearchString =  [urlSearchString stringByReplacingOccurrencesOfString:@"&f=" withString:[NSString stringWithFormat:@"&f=%d", self.currentPageNumber]];
	
	// State
	urlSearchString =  [urlSearchString stringByReplacingOccurrencesOfString:@"&s=" withString:[NSString stringWithFormat:@"&s=%@", self.suburbsListView.title]];
	
	// Suburb
	if (![self.suburbsListView.subtitle isEqual:@"Show All"]) {
		if (![self.suburbsListView.subtitle isEqual:@"All"]) {
			urlSearchString =  [urlSearchString stringByReplacingOccurrencesOfString:@"&tb=" withString:[NSString stringWithFormat:@"&tb=%@", self.suburbsListView.subtitle]];	
		}
	}
	
	// Types
	if (realTypes) {
		urlSearchString =  [urlSearchString stringByReplacingOccurrencesOfString:@"&cat=" withString:[NSString stringWithFormat:@"&cat=%@", realTypes]];
	}
	
	// Price
	NSString *minPriceValue = self.priceView.min;
	minPriceValue = [minPriceValue stringByReplacingOccurrencesOfString:@"Min: " withString:@""];
	minPriceValue = [minPriceValue stringByReplacingOccurrencesOfString:@"Max: " withString:@""];
	if ([minPriceValue length] > 0 && ![minPriceValue isEqual:@"All"]) {
		urlSearchString =  [urlSearchString stringByReplacingOccurrencesOfString:@"&pm=" withString:[NSString stringWithFormat:@"&pm=%@", minPriceValue]];
	}
	NSString *maxPriceValue = self.priceView.max;
	maxPriceValue = [maxPriceValue stringByReplacingOccurrencesOfString:@"Min: " withString:@""];
	maxPriceValue = [maxPriceValue stringByReplacingOccurrencesOfString:@"Max: " withString:@""];
	if ([maxPriceValue length] > 0 && ![maxPriceValue isEqual:@"All"]) {
		urlSearchString =  [urlSearchString stringByReplacingOccurrencesOfString:@"&px=" withString:[NSString stringWithFormat:@"&px=%@", maxPriceValue]];
	}
	
	// Bedroom
	NSString *minBedroomValue = self.bedroomView.min;
	minBedroomValue = [minBedroomValue stringByReplacingOccurrencesOfString:@"Min: " withString:@""];
	minBedroomValue = [minBedroomValue stringByReplacingOccurrencesOfString:@"Max: " withString:@""];
	if ([minBedroomValue length] > 0 && ![minBedroomValue isEqual:@"All"]) {
		urlSearchString =  [urlSearchString stringByReplacingOccurrencesOfString:@"&minbed=" withString:[NSString stringWithFormat:@"&minbed=%@", minBedroomValue]];
	}
	NSString *maxBedroomValue = self.bedroomView.max;
	maxBedroomValue = [maxBedroomValue stringByReplacingOccurrencesOfString:@"Min: " withString:@""];
	maxBedroomValue = [maxBedroomValue stringByReplacingOccurrencesOfString:@"Max: " withString:@""];
	if ([maxBedroomValue length] > 0 && ![maxBedroomValue isEqual:@"All"]) {
		urlSearchString =  [urlSearchString stringByReplacingOccurrencesOfString:@"&maxbed=" withString:[NSString stringWithFormat:@"&maxbed=%@", maxBedroomValue]];
	}
	
	return [self urlEncodeValue:urlSearchString];
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
    [[NSNotificationCenter defaultCenter]removeObserver:self];
	[_searchID release];
	[_suburbsListView release];
	[_propertyTypesView release];
	[_bedroomView release];
	[_garageView release];
	[_bathroomView release];
	[_priceView release];
	
	[super dealloc];
}


@end
