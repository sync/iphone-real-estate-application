//
//  PhotosViewInLayout.m
//  ozEstate
//
//  Created by Anthony Mittaz on 8/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import "PhotosViewInLayout.h"

static NSUInteger kColumnCount = 2;
static CGFloat kYOffset = 0.0f;
static CGFloat kXOffset = 0.0f;

@implementation PhotosViewInLayout

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		self.opaque = TRUE;
    }
    return self;
}

- (void)layoutSubviews
{
	NSArray *subviews = self.subviews;
	NSInteger subviewsCount = [subviews count];
	CGSize maxImageSize = CGSizeMake(160.0, 183.5);
	NSInteger row = 0;
	for(NSInteger i = 0;i < subviewsCount;i++) {
		UIView *subview = [subviews objectAtIndex:i];
		NSInteger column = i % kColumnCount;
		CGFloat x = column * maxImageSize.width + column * kXOffset;
		CGFloat y = row * maxImageSize.height + row * kYOffset;
		CGRect subviewFrame = CGRectMake(x, y, maxImageSize.width, 
										 maxImageSize.height);
		subview.frame = subviewFrame;
		row = (column == 1)?row+1:row;
		CGFloat frameHeight = 0;
		if (column == 1) {
			frameHeight = (row) * (kYOffset +  maxImageSize.height);
		} else {
			frameHeight = (row+1) * (kYOffset +  maxImageSize.height);
		}
		if (row >= 2 || frameHeight <= 367.0) {
			// for a nice bounce scroll
			if (frameHeight <= 377.0) {
				frameHeight = 377.0;
			}
			// Setup the scrollview content rect size
			UIScrollView *mainScrollView = (UIScrollView *)[self superview];
			mainScrollView.contentSize = CGSizeMake(mainScrollView.frame.size.width, frameHeight);
			// Setup the photoView frame rect size
			self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,  self.frame.size.width, frameHeight);
		}
	}
}


- (void)dealloc {
    [super dealloc];
}


@end
