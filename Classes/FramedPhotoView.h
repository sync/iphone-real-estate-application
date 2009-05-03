//
//  FramedPhotoView.h
//  ozEstate
//
//  Created by Anthony Mittaz on 8/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import <UIKit/UIKit.h>


@interface FramedPhotoView : UIView {
	CGFloat _rotation;
	BOOL _selected;
	
	UIImage *_image;
	id _target;
	SEL _selector;
	
	NSInteger _index;
}

@property CGFloat rotation;
@property BOOL selected;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) id target;
@property SEL selector;
@property NSInteger index;

@end
