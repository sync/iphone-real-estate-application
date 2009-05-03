//
//  ViewWithImage.m
//  ozEstate
//
//  Created by Anthony Mittaz on 6/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import "ViewWithImage.h"


@implementation ViewWithImage

@synthesize backgroundImage=_backgroundImage;
@synthesize title=_title;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		self.opaque = TRUE;
		self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

+ (id)viewWithFrame:(CGRect)frame andBackgroundImage:(UIImage *)image
{
	ViewWithImage *cellView = [[[ViewWithImage alloc]initWithFrame:frame]autorelease];
	cellView.backgroundImage = image;
	return cellView;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
	// Retrieve the graphics context 
	CGContextRef context = UIGraphicsGetCurrentContext(); 
	// draw image
	if (self.backgroundImage) {
		[self.backgroundImage drawInRect:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width,self.bounds.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
	}
	
	// title
	if (self.title) {
		// Save the context state 
		CGContextSaveGState(context);
		// Define font and color
		UIFont *boldFont = [UIFont fontWithName:@"Marker Felt" size:20.0];
		UIColor *bigColor = [UIColor colorWithRed:61.0/255.0 green:43.0/255.0 blue:30.0/255.0 alpha:1.0];
		[bigColor set];
		// Set shadow
		CGContextSetShadowWithColor(context,  CGSizeMake(0.0, -1.0), 0.5, [[UIColor whiteColor]CGColor]);
		// Draw the text
		[self.title drawInRect:CGRectMake(self.bounds.origin.x + 30.0, self.bounds.origin.y + 25.0, self.bounds.size.width - 50.0,self.bounds.size.height) withFont:boldFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
		CGContextRestoreGState(context);
	}
}

- (void)dealloc {
	[_title release];
	[_backgroundImage release];
	
	[super dealloc];
}


@end
