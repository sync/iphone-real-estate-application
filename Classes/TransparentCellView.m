//
//  TransparentCellView.m
//  ozEstate
//
//  Created by Anthony Mittaz on 6/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
// 

#import "TransparentCellView.h"


@implementation TransparentCellView

@synthesize image=_image;
@synthesize title=_title;
@synthesize selected=_selected;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		self.opaque = TRUE;
		self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

+ (id)viewWithFrame:(CGRect)frame selected:(BOOL)selected;
{
	TransparentCellView *cellView = [[[TransparentCellView alloc]initWithFrame:frame]autorelease];
	cellView.selected = selected;
	return cellView;
}



- (void)drawRect:(CGRect)rect {
    // Drawing code
	
	NSInteger leftWidthToAdd = 0;
	
	if (self.image) {
		// Draw top image
		[self.image drawInRect:CGRectMake(self.bounds.origin.x + 40.0, self.bounds.origin.y + (self.bounds.size.height - 30) / 2.0, 30.0, 30.0) blendMode:kCGBlendModeNormal alpha:1.0];
		leftWidthToAdd = 50.0;
	} else {
		leftWidthToAdd = 0;
	}
	
	
	
	if (self.title) {
		// Draw text
		UIFont *boldFont = [UIFont fontWithName:@"Courier-Bold" size:28.0];
		UIColor *bigColor = [UIColor whiteColor];
		[bigColor set];
		[self.title drawInRect:CGRectMake(self.bounds.origin.x + 40.0 + leftWidthToAdd, self.bounds.origin.y + (self.bounds.size.height - 38.0) / 2.0, 230.0 - leftWidthToAdd, 30.0) withFont:boldFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentLeft];
		
	}
}


- (void)dealloc {
	[_image release];
	[_title release];
	
    [super dealloc];
}


@end
