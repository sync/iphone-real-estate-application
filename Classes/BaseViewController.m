//
//  BaseViewController.m
//  ozEstate
//
//  Created by Anthony Mittaz on 6/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import "BaseViewController.h"


@implementation BaseViewController

@synthesize appDelegate=_appDelegate;

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
	
	[self.appDelegate removeLoadingView];
}


- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self loadAppDelegate];
	
	// NavigationBar overlay
	[self.appDelegate addNavigationOverlayInRect:CGRectMake(0.0, 63.0, 320.0, 9.0)];
	
	// TabBar overlay
	[self.appDelegate addTabBarOverlayInRect:CGRectMake(0.0, 422.0, 320.0, 9.0)];
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

	self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:61.0/255.0 green:43.0/255.0 blue:30.0/255.0 alpha:1.0];
}

- (void)loadAppDelegate
{
	if (!self.appDelegate) {
		self.appDelegate = (ozEstateAppDelegate *)[[UIApplication sharedApplication]delegate];
	}
}

- (void)restoreLevelWithSelectionArray:(NSArray *)selectionArray
{
	// nothing
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	//[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
   // Release anything that's not essential, such as cached data
}



- (void)dealloc {
	[_appDelegate release];
	
    [super dealloc];
}

@end
