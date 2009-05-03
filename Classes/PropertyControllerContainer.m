//
//  PropertyControllerContainer.m
//  ozEstate
//
//  Created by Anthony Mittaz on 7/03/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
// 

#import "PropertyControllerContainer.h"
#import "PropertyController.h"
#import "PropertyPhotosViewController.h"
#import "PropertyMoreInfosController.h"
#import "AgencyDetailsController.h"


@implementation PropertyControllerContainer

@synthesize favorite=_favorite;
@synthesize property_id=_property_id;
@synthesize scrollView=_scrollView;
@synthesize pageControl=_pageControl;
@synthesize firstController=_firstController;
@synthesize secondController=_secondController;
@synthesize favoritesCount=_favoritesCount;
@synthesize initialPosition=_initialPosition;
@synthesize state=_state;
@synthesize lastScrolledXPosition=_lastScrolledXPosition;

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		self.favorite = NO;
		self.initialPosition = 0;
		self.lastScrolledXPosition = 0.0;
		
		[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldEnableScrollAndShowPageControl:) name:ShouldEnableScrollAndShowPageControl object:nil];
		
		[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushPhotoViewController:) name:ShouldPushPhotoViewController object:nil];
		[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushMoreInfosController:) name:ShouldPushMoreInfosController object:nil];
		[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushAgencyController:) name:ShouldPushAgencyController object:nil];
		
    }
    return self;
}

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Set title
	self.navigationItem.title = @"Property";
	
	if (!self.favorite) {
		UIBarButtonItem *favoriteButton = [[UIBarButtonItem alloc]initWithImage:[self.appDelegate cachedImage:@"add_favorite_button_image.png"] 
																		  style:UIBarButtonItemStylePlain
																		 target:self 
																		 action:@selector(addToFavorite:)];
		self.navigationItem.rightBarButtonItem = favoriteButton;
		[favoriteButton release];
	} else {
		UIBarButtonItem *favoriteButton = [[UIBarButtonItem alloc]initWithImage:[self.appDelegate cachedImage:@"remove_favorite_button_image.png"] 
																		  style:UIBarButtonItemStylePlain
																		 target:self 
																		 action:@selector(removeFromFavorite:)];
		self.navigationItem.rightBarButtonItem = favoriteButton;
		[favoriteButton release];
	}
	
	// init second view
	self.secondController.favorite = self.favorite;
	[self.scrollView addSubview:self.secondController.view];
	self.secondController.view.frame = CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.size.height, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
	// init first view
	self.firstController.favorite = self.favorite;
	self.firstController.view.frame = self.scrollView.frame;
	[self.scrollView addSubview:self.firstController.view];
	
	if (self.favorite) {
		// check the number of favorites
		NSInteger count = [self.appDelegate.userdb intForQuery:@"select count(id) from properties where favorite = ? and state_name = ?", [NSNumber numberWithBool:TRUE], self.state];
		self.favoritesCount = count;
		// should update page control
		self.pageControl.numberOfPages = count;
		// update frame size width according to the number of favorites
		self.scrollView.contentSize = CGSizeMake(count * 320.0, self.scrollView.frame.size.height);
		// get the location position
		//NSInteger position = [self.appDelegate.userdb intForQuery:@"select position from location where location_id = ?", self.location_id];
		NSInteger position = self.initialPosition;
		// enable scroll
		self.scrollView.scrollEnabled = TRUE;
		// scroll to first view
		CGRect viewFrame = self.scrollView.frame;
		if (position != 0) {
			[self.scrollView scrollRectToVisible:CGRectMake(position * viewFrame.size.width, self.scrollView.frame.origin.x, viewFrame.size.width, viewFrame.size.height) animated:FALSE];
		} else {
			self.firstController.pageIndex = 0;
			self.firstController.property_id = self.property_id;
			[self.firstController fetchDb];
			CGRect firstFrame = self.scrollView.frame;
			self.firstController.view.frame = CGRectMake(position * firstFrame.size.width, 0.0, firstFrame.size.width, firstFrame.size.height);
			
			self.lastScrolledXPosition = 0.0;		
		}
		// update page control
		self.pageControl.currentPage = position;
	} else {
		// should remove page control
		[self.pageControl removeFromSuperview];
		// make sure content view is not larger than 320.0
		self.scrollView.contentSize = CGSizeMake(320.0, 267.0);
		self.scrollView.scrollEnabled = FALSE;
		// Remove second controller
		[self.secondController.view removeFromSuperview];
		// First controller update
		self.firstController.pageIndex = 0;
		self.firstController.property_id = self.property_id;
		[self.firstController fetchDb];
		
		self.lastScrolledXPosition = 0.0;	
	}
}

- (IBAction)pushPhotoViewController:(id)sender
{
	PropertyPhotosViewController *controller = [[PropertyPhotosViewController alloc] initWithNibName:@"PropertyPhotosViewController" bundle:nil];
	controller.property_id = [sender object];
	[self.navigationController pushViewController:controller animated:TRUE];
	[controller release];
}

- (IBAction)pushMoreInfosController:(id)sender
{
	PropertyMoreInfosController *controller = [[PropertyMoreInfosController alloc] initWithNibName:@"PropertyMoreInfosController" bundle:nil];
	controller.property_id = [sender object];
	[self.navigationController pushViewController:controller animated:TRUE];
	[controller release];
}

- (IBAction)pushAgencyController:(id)sender
{
	AgencyDetailsController *controller = [[AgencyDetailsController alloc] initWithNibName:@"AgencyDetailsController" bundle:nil];
	controller.property_id = [sender object];
	NSString *state_name = [self.appDelegate.userdb stringForQuery:@"select state_name from properties where id = ?", [sender object]];
	controller.agency_id = [NSNumber numberWithInteger:[self.appDelegate.userdb intForQuery:@"select agency_id from properties where id = ?", self.property_id]];
	controller.state = state_name;
	[self.navigationController pushViewController:controller animated:TRUE];
	[controller release];
}

- (void)addToFavorite:(id)sender
{
	[self.appDelegate.userdb executeUpdate:[NSString stringWithFormat:@"UPDATE properties SET favorite = ? where id = ?"], [NSNumber numberWithBool:TRUE], self.property_id];
	
	[self.navigationController popViewControllerAnimated:FALSE];
	
	NSString *state_name = [self.appDelegate.userdb stringForQuery:@"select state_name from properties where id = ?", self.property_id];
	
	[self.appDelegate selectTabBarIndex:0 andPushControllerWithTitle:state_name];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:ShouldReloadFavoritesStatesController object:nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:ShouldReloadPropertiesTableView object:nil];
}

- (void)removeFromFavorite:(id)sender
{
	//[self.appDelegate.userdb executeUpdate:[NSString stringWithFormat:@"UPDATE properties SET favorite = ? where id = ?"], [NSNumber numberWithBool:FALSE], self.property_id];
	
	[self.appDelegate.userdb executeUpdate:@"delete from images where property_id = ?", self.property_id];
	[self.appDelegate.userdb executeUpdate:@"delete from properties where id = ?", self.property_id];
	
	[self.navigationController popViewControllerAnimated:FALSE];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:ShouldReloadFavoritesStatesController object:nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:ShouldReloadPropertiesTableView object:nil];
}

- (void)shouldEnableScrollAndShowPageControl:(id)sender
{
	if (self.favorite) {
		if ([[sender object]boolValue]) {
			[self.pageControl setHidden:FALSE];
			self.scrollView.scrollEnabled = TRUE;
		} else {
			[self.pageControl setHidden:TRUE];
			self.scrollView.scrollEnabled = FALSE;
		}
	}
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat newScrolledXPosition = self.scrollView.contentOffset.x;
	
	BOOL scrollRight = FALSE;
	BOOL scrollLeft = FALSE;
	CGFloat diff = 0;
	if (newScrolledXPosition > self.lastScrolledXPosition) {
		scrollRight = TRUE;
		diff = (newScrolledXPosition - self.lastScrolledXPosition);
	} else if (newScrolledXPosition < self.lastScrolledXPosition) {
		scrollLeft = TRUE;
		diff = (self.lastScrolledXPosition - newScrolledXPosition);
	}
	
	CGFloat ratio = diff / 320.0;
	if (ratio < 1.04) {
		ratio = 1.0;
	}
	NSInteger roundedRatio = ceil(ratio);
	
	BOOL shouldLoad = TRUE;
	if (diff > 0.0 && diff > (319.0 * roundedRatio)) {
		shouldLoad = FALSE;
	}
	
	if (shouldLoad || self.initialPosition >= 0) {
		self.initialPosition = -1;
		CGFloat pageWidth = self.scrollView.frame.size.width;
		float fractionalPage = (self.scrollView.contentOffset.x / pageWidth);
		
		NSInteger firstPageIndex = self.firstController.pageIndex;
		NSInteger secondPageIndex = self.secondController.pageIndex;
		
		NSInteger currentPageIndex = lround(fractionalPage);
		
		BOOL firstControllerUsed = TRUE;
		
		if (firstPageIndex == currentPageIndex) {
			// first controller used
			firstControllerUsed = TRUE;
		} else if (secondPageIndex == currentPageIndex) {
			// second controller used
			firstControllerUsed = FALSE;
		} else {
			// use first controller
			firstControllerUsed = FALSE;
		}
		
		NSInteger lowerNumber = floor(fractionalPage);
		NSInteger upperNumber = lowerNumber + 1;
		
		NSInteger nextPage = 0;
		NSInteger currentPage = 0;
		if (firstControllerUsed) {
			nextPage = self.secondController.view.frame.origin.x / 320.0;
			currentPage = self.firstController.view.frame.origin.x / 320.0;
		} else {
			nextPage = self.firstController.view.frame.origin.x / 320.0;
			currentPage = self.secondController.view.frame.origin.x / 320.0;
		}
		
		NSInteger currentIndexToUse = -1;
		NSInteger nextIndexToUse = -1;
		
		if (lowerNumber == currentPage) {
			if (upperNumber != nextPage) {
				nextIndexToUse = upperNumber;
			}
		} else if (upperNumber == currentPage) {
			if (lowerNumber != nextPage) {
				nextIndexToUse = lowerNumber;
			}
		} else {
			if (lowerNumber == nextPage) {
				currentIndexToUse = upperNumber;
			} else if (upperNumber == nextPage) {
				currentIndexToUse = lowerNumber;
			} else {
				currentIndexToUse = lowerNumber;
				nextIndexToUse = upperNumber;
			}
		}
		
		if (nextIndexToUse != -1) {
			DLog(@"nextIndexToUse: %d", nextIndexToUse);
			// get location id according to it's location
			NSNumber *property_id = [NSNumber numberWithInteger:[self.appDelegate.userdb intForQuery:[NSString stringWithFormat:@"select id from properties where favorite = ? and state_name = ? order by suburb_name ASC limit 1 offset %d", nextIndexToUse], [NSNumber numberWithBool:TRUE], self.state]];
			CGFloat yPosition = self.scrollView.frame.size.height;
			if (property_id && [property_id integerValue] != 0) {
				yPosition = 0.0;
			}
			if (firstControllerUsed) {
				self.secondController.pageIndex = nextIndexToUse;
				self.secondController.property_id = property_id;
				[self.secondController fetchDb];
				CGRect firstFrame = self.scrollView.frame;
				self.secondController.view.frame = CGRectMake(nextIndexToUse * firstFrame.size.width, yPosition, firstFrame.size.width, firstFrame.size.height);
			} else {
				self.firstController.pageIndex = nextIndexToUse;
				self.firstController.property_id = property_id;
				[self.firstController fetchDb];
				CGRect firstFrame = self.scrollView.frame;
				self.firstController.view.frame = CGRectMake(nextIndexToUse * firstFrame.size.width, yPosition, firstFrame.size.width, firstFrame.size.height);
			}
		}
		
		if (currentIndexToUse != -1) {
			DLog(@"currentIndexToUse: %d", currentIndexToUse);
			// get location id according to it's location
			NSNumber *property_id = [NSNumber numberWithInteger:[self.appDelegate.userdb intForQuery:[NSString stringWithFormat:@"select id from properties where favorite = ? and state_name = ? order by suburb_name ASC limit 1 offset %d", currentIndexToUse], [NSNumber numberWithBool:TRUE], self.state]];
			if (property_id && [property_id integerValue] != 0) {
				if (firstControllerUsed) {
					self.firstController.pageIndex = currentIndexToUse;
					self.firstController.property_id = property_id;
					[self.firstController fetchDb];
					CGRect firstFrame = self.scrollView.frame;
					self.firstController.view.frame = CGRectMake(currentIndexToUse * firstFrame.size.width, 0.0, firstFrame.size.width, firstFrame.size.height);
				} else {
					self.secondController.pageIndex = currentIndexToUse;
					self.secondController.property_id = property_id;
					[self.secondController fetchDb];
					CGRect firstFrame = self.scrollView.frame;
					self.secondController.view.frame = CGRectMake(currentIndexToUse * firstFrame.size.width, 0.0, firstFrame.size.width, firstFrame.size.height);
				}
			}
		}
	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	self.lastScrolledXPosition = self.scrollView.contentOffset.x;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)newScrollView
{
	
	CGFloat pageWidth = self.scrollView.frame.size.width;
    float fractionalPage = self.scrollView.contentOffset.x / pageWidth;
	NSInteger nearestNumber = lround(fractionalPage);
	
	// get location id according to it's location
	NSNumber *property_id = [NSNumber numberWithInteger:[self.appDelegate.userdb intForQuery:[NSString stringWithFormat:@"select id from properties where favorite = ? and state_name = ? order by suburb_name ASC limit 1 offset %d", nearestNumber], [NSNumber numberWithBool:TRUE], self.state]];
	
	self.property_id = property_id;
	
	// should save location
	NSArray *offsetArray = [[self.appDelegate.savedLocation objectAtIndex:2]componentsSeparatedByString:@","];
	if ([offsetArray count] > 1) {
		// Find the current state
		NSString *state = [self.appDelegate.userdb stringForQuery:@"select state_name from properties where id = ?", self.property_id];
		// Find the current suburb name
		NSString *suburb = [self.appDelegate.userdb stringForQuery:@"select suburb_name from properties where id = ?", self.property_id];
		// Findd out the position of the suburb
		FMResultSet *rs = [self.appDelegate.userdb executeQuery:[NSString stringWithFormat:@"select distinct(suburb_name) from properties where favorite = ? and state_name = ? order by suburb_name ASC"], [NSNumber numberWithBool:self.favorite], state];
		NSInteger suburbPosition = 0;
		NSString *tempSuburb = nil;
		while ([rs next]) {
			tempSuburb = [rs stringForColumn:@"suburb_name"];
			if ([tempSuburb isEqualToString:suburb]) {
				break;
			}
			suburbPosition++;
		} 
		[rs close];
		// Find out the property position
		FMResultSet *newRs = [self.appDelegate.userdb executeQuery:[NSString stringWithFormat:@"select id from properties where favorite = ? and state_name = ? and suburb_name = ? order by suburb_name ASC"],  [NSNumber numberWithBool:self.favorite], state, suburb];
		NSInteger initialPosition = 0;
		NSNumber *tempProperty_id = nil;
		while ([newRs next]) {
			tempProperty_id = [NSNumber numberWithInteger:[newRs intForColumn:@"id"]];
			if ([tempProperty_id isEqualToNumber:property_id]) {
				break;
			}
			initialPosition++;
		} 
		[newRs close];
		
		[self.appDelegate.savedLocation replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%d,%d", suburbPosition, initialPosition]];
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)newScrollView
{
	[self scrollViewDidEndScrollingAnimation:newScrollView];
	
	CGFloat pageWidth = self.scrollView.frame.size.width;
    float fractionalPage = self.scrollView.contentOffset.x / pageWidth;
	NSInteger nearestNumber = lround(fractionalPage);
	self.pageControl.currentPage = nearestNumber;
}

- (IBAction)loadPage:(id)sender
{
	NSInteger index = self.pageControl.currentPage;
	
	DLog(@"tapped index: %d", index);
	CGRect rectToScrollTo = CGRectMake(index * self.scrollView.frame.size.width, 0.0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
	
	
	self.lastScrolledXPosition = self.scrollView.contentOffset.x;
	[self.scrollView scrollRectToVisible:rectToScrollTo animated:TRUE];
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)viewWillDisappear:(BOOL)animated
{	
	[super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    
	DLog(@"Ouch... using too much memory");
	// Release anything that's not essential, such as cached data
}



- (void)dealloc {
	[[NSNotificationCenter defaultCenter]removeObserver:self];
	[_state release];
	[_secondController release];
	[_firstController release];
	[_pageControl release];
	[_scrollView release];
	[_property_id release];
	
    [super dealloc];
}


@end
