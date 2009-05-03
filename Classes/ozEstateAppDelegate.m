//
//  ozEstateAppDelegate.m
//  ozEstate
//
//  Created by Anthony Mittaz on 4/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import "ozEstateAppDelegate.h"
// Migrations
#import "FmdbMigrationManager.h"
#import "InitialUserTables.h"
#import "AddSearchTable.h"
#import "AddCopyrightToPropertiesUserTable.h"
#import "AddDataToImagesUserTable.h"
#import "AddInspectionsToPropertiesUserTable.h"
#import "AddCreatedAtAndUpdatedAtToAgenciesUserTable.h"
#import "AddPostcodeToAgenciesUserTable.h"
#import "ReseetUpdatedAtFromAgencies.h"
#import "ReseetUpdatedAtFromProperties.h"
#import "AddSalesAttributesToPropertiesUserTable.h"
// GPS
#import "MyLocationGetter.h"
// Loading
#import "LoadingController.h"
// Search can go nex
#import "SearchMorePanel.h"

@implementation UINavigationBar (ozEstate)

- (void)drawBackgroundInRect:(CGRect)frame withStyle:(NSInteger)barStyle
{
	UIImage *backgroundImage = [UIImage imageNamed:@"navigation_bar_background.png"];
	CGFloat alpha = 1.0;
	if (barStyle == 2) {
		alpha = 0.5;
	}
	[backgroundImage drawInRect:frame blendMode:kCGBlendModeNormal alpha:alpha];
	
}

- (BOOL)isOpaque
{
	return FALSE;
}

@end


@implementation ozEstateAppDelegate

@synthesize window=_window;
@synthesize tabBarController;
@synthesize userdb=_userdb;
@synthesize locationGetter=_locationGetter;
@synthesize loadingController=_loadingController;
@synthesize dataFetcher=_dataFetcher;
@synthesize userDefaults=_userDefaults;
@synthesize savedLocation=_savedLocation;
@synthesize tabBarController=_tabBarController;
@synthesize remoteHostStatus;
@synthesize internetConnectionStatus;
@synthesize localWiFiConnectionStatus;
@synthesize hasValidNetworkConnection=_hasValidNetworkConnection;
@synthesize noConnectionAlertShowing=_noConnectionAlertShowing;
@synthesize imagesCache=_imagesCache;
@synthesize bigImagesCache=_bigImagesCache;

#pragma mark -
#pragma mark Navigation Bar Overlay:

- (void)addNavigationOverlayInRect:(CGRect)rect
{
	UIImageView *navigationBarOverlay = (UIImageView *)[self.window viewWithTag:NAVIGATION_BAR_OVERLAY];
	if (!navigationBarOverlay) {
		navigationBarOverlay = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navigation_bar_drop_shadow.png"]]autorelease];
		navigationBarOverlay.tag = NAVIGATION_BAR_OVERLAY;
		navigationBarOverlay.frame = rect;
		[self.window addSubview:navigationBarOverlay];
	}
	navigationBarOverlay.frame = rect;
}

- (void)removeNavigationBarOverlay
{
	UIImageView *navigationBarOverlay = (UIImageView *)[self.window viewWithTag:NAVIGATION_BAR_OVERLAY];
	if (navigationBarOverlay) {
		[navigationBarOverlay removeFromSuperview];
	}
}

#pragma mark -
#pragma mark Tabb Bar Overlay:

- (void)addTabBarOverlayInRect:(CGRect)rect
{
	UIImageView *tabBarOverlay = (UIImageView *)[self.window viewWithTag:TAB_BAR_OVERLAY];
	if (!tabBarOverlay) {
		tabBarOverlay = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"uitab_bar_drop_shadow.png"]]autorelease];
		tabBarOverlay.tag = TAB_BAR_OVERLAY;
		tabBarOverlay.frame = rect;
		[self.window addSubview:tabBarOverlay];
	}
	tabBarOverlay.frame = rect;
}

- (void)removeTabBarOverlay
{
	UIImageView *tabBarOverlay = (UIImageView *)[self.window viewWithTag:TAB_BAR_OVERLAY];
	if (tabBarOverlay) {
		[tabBarOverlay removeFromSuperview];
	}
}


- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
    // Add the tab bar controller's current view as a subview of the window
    [self.window addSubview:self.tabBarController.view];
	
	// Image cache
	self.imagesCache = [NSMutableDictionary dictionaryWithCapacity:0];
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeCache:) name:ShouldRemoveCache object:nil];
	// Big Image cahce
	self.bigImagesCache = [NSMutableDictionary dictionaryWithCapacity:0];
	
	// Database access
	[self loadUserDatabase];
	
	// GPS
	MyLocationGetter *locationGetter = [[MyLocationGetter alloc]init];;
	self.locationGetter = locationGetter;
	[locationGetter release];
	[self.locationGetter startUpdates];
	
	// Initialize Data Fetcher
	self.dataFetcher = [DataFetcher dataFetcher];
	
	// User Defaults
	self.userDefaults = [NSUserDefaults standardUserDefaults];
	// Register defaults
	[self.userDefaults registerDefaults:[NSDictionary dictionaryWithObject:@"1.5" forKey:GPSRadius]];
	[self.userDefaults registerDefaults:[NSDictionary dictionaryWithObject:@"NSW" forKey:State]];
	
	// load the stored preference of the user's last location from a previous launch
	NSMutableArray *tempMutableCopy = [[self.userDefaults objectForKey:RestoreLocation] mutableCopy];
	self.savedLocation = tempMutableCopy;
	[tempMutableCopy release];
	
	if (self.savedLocation == nil) {
		// user has not launched this app nor navigated to a particular level yet, start at level 1, with no selection
		
		self.savedLocation = [NSMutableArray arrayWithObjects:
							  @"1",
							  @"-1",
							  @"-1,-1",
							  nil];
	}
	
	if ([self.savedLocation count] < 3) {
		[self.savedLocation replaceObjectAtIndex:1 withObject:@"-1"];
		[self.savedLocation addObject: @"-1,-1"];
	}
	
	[self restoreLevelWithSelectionArray:self.savedLocation];
	
	/*
	 You can use the Reachability class to check the reachability of a remote host
	 by specifying either the host's DNS name (www.apple.com) or by IP address.
	 */
	self.hasValidNetworkConnection = FALSE;
	self.noConnectionAlertShowing = FALSE;
	
	[[Reachability sharedReachability] setHostName:[self hostName]];
	[[Reachability sharedReachability] setNetworkStatusNotificationsEnabled:YES];
	[self updateStatus];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kNetworkReachabilityChangedNotification object:nil];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	DLog(@"ouch you are currently using way to much memory !");
	[self removeCache:self];
	[self.bigImagesCache removeAllObjects];
}

- (void)alertNoNetworkConnection
{
	if (!self.noConnectionAlertShowing) {
		// open an alert with just an OK button
		self.noConnectionAlertShowing = TRUE;
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Network Found." message:@"Would you like to try again?"
													   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
		[alert show];	
		[alert release];
	}	
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	self.noConnectionAlertShowing = FALSE;
	// the user clicked one of the OK/Cancel buttons
	if (buttonIndex == 0)
	{
		DLog(@"Cancel");
		// Do nothing
	}
	else
	{
		DLog(@"OK");
		[self updateStatus];
	}
}

- (void)reachabilityChanged:(NSNotification *)note
{
    [self updateStatus];
}

- (void)updateStatus
{
	// Query the SystemConfiguration framework for the state of the device's network connections.
	self.remoteHostStatus           = [[Reachability sharedReachability] remoteHostStatus];
	self.internetConnectionStatus	= [[Reachability sharedReachability] internetConnectionStatus];
	self.localWiFiConnectionStatus	= [[Reachability sharedReachability] localWiFiConnectionStatus];
	
	if ((self.remoteHostStatus == ReachableViaWiFiNetwork) || (self.remoteHostStatus == ReachableViaCarrierDataNetwork))  {
		self.hasValidNetworkConnection = TRUE;
	} else {
		self.hasValidNetworkConnection = FALSE;
	}
	
	
}

- (BOOL)isCarrierDataNetworkActive
{
	return (self.remoteHostStatus == ReachableViaCarrierDataNetwork);
}

- (NSString *)hostName
{
	// Don't include a scheme. 'http://' will break the reachability checking.
	// Change this value to test the reachability of a different host.
	return @"www.realestate.com.au";
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// save the drill-down hierarchy of selections to preferences
	[self.userDefaults setObject:self.savedLocation forKey:RestoreLocation];
}

- (void)restoreLevelWithSelectionArray:(NSArray *)selectionArray
{
	NSInteger item = [[selectionArray objectAtIndex:0]integerValue];
	if (item != -1) {
		[self.tabBarController setSelectedIndex:[[selectionArray objectAtIndex:0]integerValue]];
		
		// narrow down the selection array for level 2
		NSArray *newSelectionArray = [selectionArray subarrayWithRange:NSMakeRange(1, [selectionArray count]-1)];
		
		UINavigationController *naviagationController = (UINavigationController *)[[self tabBarController]selectedViewController];
		[naviagationController.visibleViewController performSelector:@selector(restoreLevelWithSelectionArray:) withObject:newSelectionArray];
	}
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
	if ((self.savedLocation != nil) && ([[self.savedLocation objectAtIndex:0]intValue] != self.tabBarController.selectedIndex)) {
		for (NSInteger i=0; i<self.savedLocation.count; i++) {
			if (i!=0) {
				[self.savedLocation replaceObjectAtIndex:i withObject:@"-1"];
			} else {
				[self.savedLocation replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%d", tabBarController.selectedIndex]];
			}
		}
	}
}

- (void)selectTabBarIndex:(NSInteger)index andPushControllerWithTitle:(NSString *)title
{
	if (self.tabBarController.selectedIndex != index) {
		self.tabBarController.selectedIndex = index;
	}
	
	[(id)[self.tabBarController selectedViewController]popToRootViewControllerAnimated:FALSE];
	
	UINavigationController *naviagationController = (UINavigationController *)[[self tabBarController]selectedViewController];
	[naviagationController.visibleViewController performSelector:@selector(pushNextControllerWithTitle:animated:) withObject:title withObject:[NSNumber numberWithBool:FALSE]];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:ShouldReloadRecentsStatesController object:nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:ShouldReloadFavoritesStatesController object:nil];
}

#pragma mark -
#pragma mark Geolocation:

- (CLLocation *)currentLocation
{
	if (TARGET_IPHONE_SIMULATOR) {
		return [[[CLLocation alloc]initWithLatitude:-27.450138 longitude:153.011142]autorelease];
	}

	return [self.locationGetter.locationManager location];
}

#pragma mark -
#pragma mark User Database:

// User database (use this for example to store the favorites user places)
// Returns FALSE upon error
- (BOOL)loadUserDatabase
{
	BOOL error = FALSE;
	NSArray *migrations = [NSArray arrayWithObjects:
						   [InitialUserTables migration],
						   [AddSearchTable migration],
						   [AddCopyrightToPropertiesUserTable migration],
						   [AddDataToImagesUserTable migration],
						   [AddInspectionsToPropertiesUserTable migration],
						   [AddCreatedAtAndUpdatedAtToAgenciesUserTable migration],
						   [AddPostcodeToAgenciesUserTable migration],
						   [ReseetUpdatedAtFromAgencies migration],
						   [ReseetUpdatedAtFromProperties migration],
						   [AddSalesAttributesToPropertiesUserTable migration],
						   nil
						   ];
	
	[FmdbMigrationManager executeForDatabasePath:[self documentPathForFile:@"database.sqlite"] withMigrations:migrations];
	
	self.userdb = [FMDatabase databaseWithPath:[self documentPathForFile:@"database.sqlite"]];
	if (![self.userdb open]) {
		error = TRUE;
	}
	[self.userdb setLogsErrors:TRUE];
	
	return error;
}

#pragma mark -
#pragma mark Loading Controller Overlay:

- (void)addLoadingView
{
	if (!self.loadingController) {
		LoadingController *loadingController = [[LoadingController alloc]initWithNibName:@"LoadingController" bundle:nil];
		loadingController.view.tag = LOADING_VIEW_TAG;
		self.loadingController = loadingController;
		self.loadingController.view.frame = CGRectMake(0.0, 64.0, 320.0, 367.0);
		self.loadingController.view.alpha = 0.0;
		[loadingController release];
	}
	
	if (!self.loadingController.loading) {
		self.loadingController.view.frame = CGRectMake(0.0, 64.0, 320.0, 367.0);
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[self.window addSubview:self.loadingController.view];
		self.loadingController.view.alpha = 1.0;
		self.loadingController.loading = TRUE;
		[UIView commitAnimations];
	}
}

- (void)removeLoadingView
{
	if (self.loadingController.loading) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(fadingAnimationDidStop:finished:context:)];
		self.loadingController.view.alpha = 0.0;
		[UIView commitAnimations];
		self.loadingController.loading = FALSE;
	}
}

#pragma mark -
#pragma mark Search Controller Can Go Next Overlay:

- (void)addSearchCanGoNext:(id)sender
{
	//SEARCH_CAN_GO_NEXT
	SearchMorePanel *searachMoreView = [[SearchMorePanel alloc]initWithFrame: CGRectMake(0.0, 64.0, 320.0, 44.0)];
	searachMoreView.tag = SEARCH_CAN_GO_NEXT;
	searachMoreView.title = @"Last search has more results...\nTouch me to continue...";
	searachMoreView.target = self;
	searachMoreView.selector = @selector(searchShouldGoNext:);
	searachMoreView.cancelSelector = @selector(removeSearchCanGoNext:);
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.75];
	//	
	//	[UIView setAnimationTransition:(UIViewAnimationTransitionCurlDown)
	//						   forView:self.view cache:YES];
	
	[self.window addSubview:searachMoreView];
	[searachMoreView release];
	
	[UIView commitAnimations];
}

- (void)removeSearchCanGoNext:(id)sender
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.75];
	//		[UIView setAnimationTransition:(UIViewAnimationTransitionCurlUp)
	//							   forView:self.view cache:YES];
	
	[[self.window viewWithTag:SEARCH_CAN_GO_NEXT]removeFromSuperview];
	
	[UIView commitAnimations];
}

- (void)searchShouldGoNext:(id)sender
{
	// Do something here
	[[NSNotificationCenter defaultCenter] postNotificationName:SearchShouldGoNext object:nil];
}

#pragma mark -
#pragma mark Show User Informative Panel
- (IBAction)showInformativeMenuUsers:(id)sender
{
	UIActionSheet *styleAlert =
	[[UIActionSheet alloc] initWithTitle:@"Please review your user details."
								delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
					   otherButtonTitles:@"Open Settings", nil, nil];
	
	[styleAlert showInView:self.window];
	[styleAlert release];
}
// change the navigation bar style, also make the status bar match with it
- (void)actionSheet:(UIActionSheet *)modalView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (buttonIndex)
	{
		case 0:
		{
			// Open Settings
			[self selectTabBarIndex:3 andPushControllerWithTitle:@"User Details"];
			break;
		}
		case 1:
		{
			// Cancel
			break;
		}
	}
}

#pragma mark -
#pragma mark Image Cache

- (UIImage*)cachedImage:(NSString*)imageName
{
	UIImage *thumbnail = [self.imagesCache objectForKey:imageName];
	
	if (nil == thumbnail)
	{
		NSString *type = [imageName pathExtension];
		NSString *impageNameWithoutType = [imageName stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@".%@", type] withString:@""];
		NSString *thumbnailFile = [self bundlePathForRessource:impageNameWithoutType ofType:type];
		thumbnail = [UIImage imageWithContentsOfFile:thumbnailFile];
		[self.imagesCache setObject:thumbnail forKey:imageName];
	}
	return thumbnail;
}


- (void)removeCache:(id)sender
{
	[self.imagesCache removeAllObjects];
}

#pragma mark -
#pragma mark Utilities method to help find ressources from the applications directory or from the user directory:

// Permits to retrieve the path for the given file on the user documents dir
- (NSString *)documentPathForFile:(NSString *)aPath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *appFile = [documentsDirectory stringByAppendingPathComponent:aPath];
	return appFile;
}

// Permits to retrive the path for the given file on the application ressources dir
- (NSString *)bundlePathForRessource:(NSString *)aRessource ofType:(NSString *)aType
{
	NSBundle *bundle = [NSBundle mainBundle];
	NSString *path = [bundle pathForResource:aRessource ofType:aType];
	return path;
}


- (void)dealloc {
	[[NSNotificationCenter defaultCenter]removeObserver:self];
	[_bigImagesCache release];
	[_imagesCache release];
	[_savedLocation release];
	[_userDefaults release];
	[_dataFetcher release];
	[_loadingController release];
	[_userdb release];
	[_locationGetter release];
	[_tabBarController release];
    [_window release];
    [super dealloc];
}

@end

