//
//  MinMaxController.h
//  ozEstate
//
//  Created by Anthony Mittaz on 8/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface MinMaxSearchController : BaseViewController <UITextFieldDelegate>{
	UITextField *_minTextField;
	UITextField *_maxTextField;
	NSNumber *_searchID;
	NSString *_propertyName;
}

@property (nonatomic, retain) IBOutlet UITextField *minTextField;
@property (nonatomic, retain) IBOutlet UITextField *maxTextField;

@property (nonatomic, retain) NSNumber *searchID;
@property (nonatomic, retain) NSString *propertyName;

@end
