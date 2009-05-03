//
//  ViewsWithTextInLayout.m
//  ozEstate
//
//  Created by Anthony Mittaz on 8/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import "ViewsWithTextInLayout.h"
#import "ResizableViewWithText.h"

#define offset 5

@implementation ViewsWithTextInLayout


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}


- (void)layoutSubviews
{
	CGFloat height = 0;
	CGFloat previousFrameYOrigin = 0;
	for (ResizableViewWithText *aView in [self subviews]) {
		CGSize textSize;
		textSize = [aView.text sizeWithFont:aView.font constrainedToSize:CGSizeMake(262.0, FLT_MAX) lineBreakMode:UILineBreakModeTailTruncation];
		aView.frame = CGRectMake(aView.frame.origin.x, aView.frame.origin.y, 262.0, textSize.height);
		
		height += aView.frame.size.height;
		aView.frame = CGRectMake(aView.frame.origin.x, previousFrameYOrigin, aView.frame.size.width, aView.frame.size.height);
		previousFrameYOrigin = height;
	}
	
	UIScrollView *mainScrollView = (UIScrollView *)[self superview];
	mainScrollView.contentSize = CGSizeMake(mainScrollView.frame.size.width, height);
	// Setup the photoView frame rect size
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,  self.frame.size.width, height);
	
	[super layoutSubviews];
}


- (void)dealloc {
    [super dealloc];
}


@end
