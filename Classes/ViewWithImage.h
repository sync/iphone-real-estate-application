//
//  ViewWithImage.h
//  ozEstate
//
//  Created by Anthony Mittaz on 6/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import <UIKit/UIKit.h>


@interface ViewWithImage : UIView {
	UIImage *_backgroundImage;
	NSString *_title;
}

@property (nonatomic, retain) UIImage *backgroundImage;
@property (nonatomic, retain) NSString *title;

+ (id)viewWithFrame:(CGRect)frame andBackgroundImage:(UIImage *)image;

@end
