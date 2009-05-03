//
//  LoadingController.m
//  ozEstate
//
//  Created by Anthony Mittaz on 8/09/08.
//  Copyright 2008 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import "LoadingController.h"


@implementation LoadingController

@synthesize loading;
@synthesize loadingIndicator=_loadingIndicator;

/*
// Override initWithNibName:bundle: to load the view using a nib file then perform additional customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
	[super viewDidLoad];
	
	
}

//- (void)viewWillAppear:(BOOL)animated
//{
//	self.loading = TRUE;
//	[super viewWillAppear:animated];
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//	self.loading = FALSE;
//	[super viewWillDisappear:animated];
//}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[_loadingIndicator release];
	
    [super dealloc];
}


@end
