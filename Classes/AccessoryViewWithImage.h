//
//  AccessoryViewWithImage.h
//  ozEstate
//
//  Created by Anthony Mittaz on 7/10/08.
//  Copyright 2008 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import <UIKit/UIKit.h>


@interface AccessoryViewWithImage : UIView {
	UIImage *_accessoryImage;
}

@property (nonatomic, retain) UIImage *accessoryImage;

+(id)accessoryViewWithFrame:(CGRect)frame andImage:(NSString *)imageNamed;

@end
