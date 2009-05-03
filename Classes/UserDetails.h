//
//  UserDetails.h
//  ozEstate
//
//  Created by Anthony Mittaz on 14/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface UserDetails : BaseViewController {
	UITextField *_nameTextField;
	UITextField *_emailTextField;
	UITextField *_phoneTextField;
}

@property (nonatomic, retain) IBOutlet UITextField *nameTextField;
@property (nonatomic, retain) IBOutlet UITextField *emailTextField;
@property (nonatomic, retain) IBOutlet UITextField *phoneTextField;

@end
