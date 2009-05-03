//
//  ShowNextResultView.m
//  ozEstate
//
//  Created by Anthony Mittaz on 10/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import "ShowNextResultView.h"


@implementation ShowNextResultView

@synthesize target=_target;
@synthesize selector=_selector;
@synthesize backgroundImage=_backgroundImage;
@synthesize title=_title;
@synthesize selected=_selected;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		self.opaque = TRUE;
		self.backgroundColor = [UIColor clearColor];
		self.selected = FALSE;
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
		UIColor *selectedColor = [UIColor redColor];
		if (self.selected) {
			[selectedColor set];
		} else {
			[bigColor set];
		}
		// Set shadow
		CGContextSetShadowWithColor(context,  CGSizeMake(0.0, -1.0), 0.5, [[UIColor whiteColor]CGColor]);
		// Draw the text
		[self.title drawInRect:CGRectMake(self.bounds.origin.x + 25.0, self.bounds.origin.y + (self.bounds.size.height-25.0)/2.0, self.bounds.size.width - 50.0, 25.0) withFont:boldFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
		CGContextRestoreGState(context);
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	self.selected = TRUE;
	[self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	self.selected = FALSE;
	[self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	self.selected = FALSE;
	[self setNeedsDisplay];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.target performSelector:self.selector withObject:self];
	self.selected = FALSE;
	[self setNeedsDisplay];
}

- (void)dealloc {
	[_target release];
	[_title release];
	[_backgroundImage release];
	
	[super dealloc];
}

@end
