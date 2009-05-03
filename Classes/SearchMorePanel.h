//
//  ImageWithAction.h
//  ozEstate
//
//  Created by Anthony Mittaz on 12/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import <UIKit/UIKit.h>


@interface SearchMorePanel : UIView {
	id _target;
	SEL _selector;
	SEL _cancelSelector;
	NSString *_title;
	
	BOOL _cancelSelected;
	BOOL _selected;
}

@property (nonatomic, retain) id target;
@property (nonatomic) SEL selector;
@property (nonatomic) SEL cancelSelector;
@property (nonatomic, retain) NSString *title;
@property (nonatomic) BOOL cancelSelected;
@property (nonatomic) BOOL selected;

@end
