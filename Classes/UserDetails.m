//
//  UserDetails.m
//  ozEstate
//
//  Created by Anthony Mittaz on 14/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import "UserDetails.h"


@implementation UserDetails

@synthesize nameTextField=_nameTextField;
@synthesize emailTextField=_emailTextField;
@synthesize phoneTextField=_phoneTextField;

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
	
	self.navigationItem.title = @"User Details";
	
	self.nameTextField.font = [UIFont fontWithName:@"American Typewriter" size:14.0];
	self.nameTextField.keyboardType = UIKeyboardTypeDefault;
	self.emailTextField.font = [UIFont fontWithName:@"American Typewriter" size:14.0];
	self.emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
	self.phoneTextField.font = [UIFont fontWithName:@"American Typewriter" size:14.0];
	self.phoneTextField.keyboardType = UIKeyboardTypePhonePad;
	
	NSString *name = [self.appDelegate.userDefaults stringForKey:UserFullName];
	NSString *phone = [self.appDelegate.userDefaults stringForKey:UserEmail];
	NSString *email = [self.appDelegate.userDefaults stringForKey:UserPhone];
	
	
	if (name || [name length] > 0) {
		self.nameTextField.text = name;
	}
	
	if (phone || [phone length] > 0) {
		self.phoneTextField.text = phone;
	}
	
	if (email || [email length] > 0) {
		self.emailTextField.text = email;
	}
	
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	//[self.appDelegate addNavigationOverlayInRect:CGRectMake(0.0, 107.0, 320.0, 9.0)];
	[self.nameTextField becomeFirstResponder];
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
	NSString *key = nil;
	if ([textField isEqual:self.nameTextField]) {
		key = UserFullName;
	} else if ([textField isEqual:self.emailTextField]) {
		key = UserEmail;
	} else if ([textField isEqual:self.phoneTextField]) {
		key = UserPhone;
	}
	if (key) {
		[self.appDelegate.userDefaults setValue:textField.text forKey:key];
	}
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[_nameTextField release];
	[_emailTextField release];
	[_phoneTextField release];
	
	[super dealloc];
}

@end
