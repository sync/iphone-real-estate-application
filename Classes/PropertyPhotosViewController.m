//
//  PropertyPhotosView.m
//  ozEstate
//
//  Created by Anthony Mittaz on 8/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
// 

#import "PropertyPhotosViewController.h"
#import "FramedPhotoView.h"
#import "BigPhotosViewControllerContainer.h"


@implementation PropertyPhotosViewController

@synthesize scrollView=_scrollView;
@synthesize photosView=_photosView;
@synthesize property_id=_property_id;
@synthesize retryCount=_retryCount;

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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.retryCount = 0;
	
	self.navigationItem.title = @"Photos";
	
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadTableView:) name:ShouldReloadPhotosView object:nil];
	
	[self fetchDb];
	
	UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithTitle:@"Refresh" 
																   style:UIBarButtonItemStylePlain
																  target:self 
																  action:@selector(refreshPhotos:)];
	[self.navigationItem setRightBarButtonItem:button animated:FALSE];
	[button release];
}

- (void)refreshPhotos:(id)sender
{
	NSString *website_id = [self.appDelegate.userdb stringForQuery:@"select website_id from properties where id = ?", self.property_id];
	[self.appDelegate.dataFetcher getHouseMoreImagesWithLetter:@"m" forWebsiteId:website_id main:TRUE];
}

- (void)reloadTableView:(id)sender
{
	[self fetchDb];
}

- (void)fetchDb
{
	// clear all subviews
	for (id view in [self.photosView subviews]) {
		[view removeFromSuperview];
	}
	
	FMResultSet *rs = [self.appDelegate.userdb executeQuery:@"select data from images where property_id = ? and preview = ?", self.property_id, [NSNumber numberWithBool:FALSE]];
	NSData *data = nil;
	NSInteger count = 0;
	while ([rs next]) {
		data = [rs dataForColumn:@"data"];
		FramedPhotoView *propertyImage = [[FramedPhotoView alloc]initWithFrame:CGRectMake(0.0, 0.0, 160.0, 183.)];
		propertyImage.backgroundColor = [UIColor clearColor];
		//srandom(time(NULL));
		//CGFloat rotation = (((random() % 20))*M_PI)/180.0;
		//propertyImage.rotation = rotation;
		propertyImage.image = [[UIImage imageWithData:data] _imageScaledToSize:CGSizeMake(106.0, 90.0) interpolationQuality:0.5];
		propertyImage.target = self;
		propertyImage.index = count;
		propertyImage.selector = @selector(pushBigPhotosController:);
		[self.photosView addSubview:propertyImage];
		[propertyImage release];
		count ++;
	}
	[rs close];
	if (count == 0 && self.retryCount == 0) {
		NSString *website_id = [self.appDelegate.userdb stringForQuery:@"select website_id from properties where id = ?", self.property_id];
		[self.appDelegate.dataFetcher getHouseMoreImagesWithLetter:@"m" forWebsiteId:website_id main:TRUE];
		self.retryCount += 1;
	} else if (count == 0 && self.retryCount == 1) {
		UIImageView *propertyImage = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 0.0, 160.0, 183.0)];
		propertyImage.image = [self.appDelegate cachedImage:@"medium_photo_frame_empty.png"];
		[self.photosView addSubview:propertyImage];
		[propertyImage release];
	}
}

- (IBAction)pushBigPhotosController:(id)sender
{
	NSInteger selectedIndex = [sender integerValue];
	BigPhotosViewControllerContainer *controller = [[BigPhotosViewControllerContainer alloc]initWithNibName:@"BigPhotosViewControllerContainer" bundle:nil];
	controller.property_id = self.property_id;
	controller.initialPosition = selectedIndex;
	[self.navigationController pushViewController:controller animated:TRUE];
	[controller release];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	[[NSNotificationCenter defaultCenter]postNotificationName:ShouldRemoveCache object:nil];
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
	
	[_property_id release];
	[_photosView release];
	[_scrollView release];
	
	[super dealloc];
}


@end
