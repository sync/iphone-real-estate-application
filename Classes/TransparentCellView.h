//
//  TransparentCellView.h
//  ozEstate
//
//  Created by Anthony Mittaz on 6/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import <UIKit/UIKit.h>


@interface TransparentCellView : UIView {
	UIImage *_image;
	NSString *_title;
	BOOL _selected;
}

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSString *title;
@property BOOL selected;

+ (id)viewWithFrame:(CGRect)frame selected:(BOOL)selected;

@end
