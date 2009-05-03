//
//  MinMaxController.m
//  ozEstate
//
//  Created by Anthony Mittaz on 8/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import "MinMaxSearchController.h"


@implementation MinMaxSearchController

@synthesize minTextField=_minTextField;
@synthesize maxTextField=_maxTextField;
@synthesize searchID=_searchID;
@synthesize propertyName=_propertyName;

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
	
	self.minTextField.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:21.0];
	self.minTextField.keyboardType = UIKeyboardTypeNumberPad;
	self.maxTextField.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:21.0];
	self.maxTextField.keyboardType = UIKeyboardTypeNumberPad;
	
	// query db
	FMResultSet *rs = [self.appDelegate.userdb executeQuery:[NSString stringWithFormat:@"select %@,%@ from searches where id = ? limit 1 offset 0", [NSString stringWithFormat:@"%@_min", self.propertyName], [NSString stringWithFormat:@"%@_max", self.propertyName]], self.searchID];
	
	NSString *minValue = nil;
	NSString *maxValue = nil;
	if ([rs next]) {
		minValue = [rs stringForColumn:[NSString stringWithFormat:@"%@_min", self.propertyName]];
		maxValue = [rs stringForColumn:[NSString stringWithFormat:@"%@_max", self.propertyName]];
	}
	[rs close];
	
	if (!minValue || [minValue length] == 0) {
		minValue = @"";
	}
	
	if (!maxValue || [maxValue length] == 0) {
		maxValue = @"";
	}

	self.minTextField.text = minValue;
	self.maxTextField.text = maxValue;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	//[self.appDelegate addNavigationOverlayInRect:CGRectMake(0.0, 107.0, 320.0, 9.0)];
	[self.minTextField becomeFirstResponder];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	//NSString *minValueText = self.minTextField.text;
//	NSString *maxValueText = self.maxTextField.text;
//	
//	if (minValueText && maxValueText) {
//		if (![minValueText isEqualToString:@""] && ![maxValueText isEqualToString:@""]) {
//			NSInteger min = [minValueText integerValue];
//			NSInteger max = [maxValueText integerValue];
//			if (min > max){
//				if ([textField tag] == MIN_VALUE_TAG) {
//					self.maxTextField.text = self.minTextField.text;
//				} else {
//					self.minTextField.text = self.maxTextField.text;
//				}
//				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bedroom Min & Max" message:@"Max value can not be less than Min value."
//															   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//				[alert show];
//				[alert release];
//			}
//		}
//	}
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	NSString *minValueText = self.minTextField.text;
	NSString *maxValueText = self.maxTextField.text;
	
	if (minValueText && [minValueText length] > 0 && maxValueText && [maxValueText length] > 0) {
		NSInteger min = [minValueText integerValue];
		NSInteger max = [maxValueText integerValue];
		if (min > max){
			self.minTextField.text = self.maxTextField.text;
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bedroom Min & Max" message:@"Max value can not be less than Min value."
														   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];
			[alert release];
		}
	}
	
	[self.appDelegate.userdb executeUpdate:[NSString stringWithFormat:@"UPDATE searches SET %@_min = ? where id = ?", self.propertyName], [self.minTextField text], self.searchID];
	[self.appDelegate.userdb executeUpdate:[NSString stringWithFormat:@"UPDATE searches SET %@_max = ? where id = ?", self.propertyName], [self.maxTextField text], self.searchID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [_propertyName release];
	[_searchID release];
	[_minTextField release];
	[_maxTextField release];
	
	[super dealloc];
}


@end
