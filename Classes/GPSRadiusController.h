//
//  GPSRadiusController.h
//  ozEstate
//
//  Created by Anthony Mittaz on 14/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"

@interface GPSRadiusController : BaseTableViewController {
	NSArray *_content;
}

@property (nonatomic, retain) NSArray *content;

@end
