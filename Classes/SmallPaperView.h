//
//  SmallPaperView.h
//  ozEstate
//
//  Created by Anthony Mittaz on 7/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import <UIKit/UIKit.h>


@interface SmallPaperView : UIView {
	NSString *_title;
	NSString *_min;
	NSString *_max;
	
	CGFloat _rotation;
	
	id _target;
	SEL _selector;
	
	BOOL _selected;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic ,retain) NSString *min;
@property (nonatomic, retain) NSString *max;

@property CGFloat rotation;

@property (nonatomic, retain) id target;
@property SEL selector;
@property BOOL selected;

@end
