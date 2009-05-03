//
//  TitleBackgroundViewWithImage.h
//  ozEstate
//
//  Created by Anthony Mittaz on 6/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import <UIKit/UIKit.h>
#import "ListingCellView.h"

@interface ListingTitleView : ListingCellView {
	NSString *_title;
	id _photoFrameTarget;
	SEL _photoFrameSelector;
	id _noteTarget;
	SEL _noteSelector;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) id photoFrameTarget;
@property SEL photoFrameSelector;
@property (nonatomic, retain) id noteTarget;
@property SEL noteSelector;

+ (id)viewWithFrame:(CGRect)frame selected:(BOOL)selected;

@end
