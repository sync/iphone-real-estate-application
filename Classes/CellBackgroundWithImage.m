//
//  CellBackgroundWithImage.m
//  ozEstate
//
//  Created by Anthony Mittaz on 6/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
// 

#import "CellBackgroundWithImage.h"


@implementation CellBackgroundWithImage

@synthesize backgroundImage=_backgroundImage;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		self.opaque = TRUE;
		self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

+ (id)backgroundViewWithFrame:(CGRect)frame andBackgroundImage:(UIImage *)image
{
	CellBackgroundWithImage *cellView = [[[CellBackgroundWithImage alloc]initWithFrame:frame]autorelease];
	cellView.backgroundImage = image;
	return cellView;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
	if (self.backgroundImage) {
		[self.backgroundImage drawInRect:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width,self.bounds.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
	}
}

- (void)dealloc {
	[_backgroundImage release];
	
	[super dealloc];
}


@end
