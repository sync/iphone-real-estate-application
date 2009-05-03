//
//  AgencyTopView.h
//  ozEstate
//
//  Created by Anthony Mittaz on 9/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
// 

#import <UIKit/UIKit.h>


@interface AgencyTopView : UIView {
	NSString *_title;
	NSString *_streetName;
	NSString *_distance;
	NSString *_textToSend;
	
	NSInteger _heightDiffFromTop;
	BOOL _selected;
}

@property (nonatomic, retain) NSString *streetName;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *distance;
@property (nonatomic, retain) NSString *textToSend;
@property BOOL selected;
@property NSInteger heightDiffFromTop;

+ (id)viewWithFrame:(CGRect)frame selected:(BOOL)selected;

@end
