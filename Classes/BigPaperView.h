//
//  BigPaperView.h
//  ozEstate
//
//  Created by Anthony Mittaz on 7/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import <UIKit/UIKit.h>


@interface BigPaperView : UIView {
	NSString *_title;
	NSString *_subtitle;
	
	CGFloat _rotation;
	id _target;
	SEL _selector;
	
	BOOL _selected;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic ,retain) NSString *subtitle;
@property (nonatomic, retain) id target;
@property SEL selector;
@property BOOL selected;

@property CGFloat rotation;

@end
