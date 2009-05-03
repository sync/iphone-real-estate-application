//
//  ShowNextResultView.h
//  ozEstate
//
//  Created by Anthony Mittaz on 10/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import <UIKit/UIKit.h>
#import "ViewWithImage.h"

@interface ShowNextResultView : UIView {
	id _target;
	SEL _selector;
	BOOL _selected;
	UIImage *_backgroundImage;
	NSString *_title;
}

@property (nonatomic, retain) id target;
@property SEL selector;
@property (nonatomic, retain) UIImage *backgroundImage;
@property (nonatomic, retain) NSString *title;
@property (nonatomic) BOOL selected;

+ (id)viewWithFrame:(CGRect)frame andBackgroundImage:(UIImage *)image;

@end
