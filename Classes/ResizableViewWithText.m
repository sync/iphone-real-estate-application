//
//  ResizableViewWithText.m
//  ozEstate
//
//  Created by Anthony Mittaz on 8/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import "ResizableViewWithText.h"


@implementation ResizableViewWithText

@synthesize font=_font;
@synthesize text=_text;
@synthesize selector=_selector;
@synthesize target=_target;
@synthesize selected=_selected;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		self.opaque = TRUE;
		self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
	// Draw text
	UIColor *textColor = [UIColor blackColor];
	UIColor *selectedTextColor = [UIColor redColor];
	
	if (self.text) {
		if (self.selected) {
			[selectedTextColor set];
		} else {
			[textColor set];
		}
		[self.text drawInRect:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height) withFont:self.font lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentLeft];
		
		if (self.target) {
			//10x13
			[[(ozEstateAppDelegate *)[[UIApplication sharedApplication]delegate] cachedImage:@"follow_link_arrow.png"] drawInRect:CGRectMake(self.bounds.size.width - 20.0, self.bounds.origin.y + (self.bounds.size.height - 13.0) / 2.0, 13.0, 10.0) blendMode:kCGBlendModeNormal alpha:1.0];
		}
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (self.target) {
		self.selected = TRUE;
		[self setNeedsDisplay];
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (self.target) {
		self.selected = FALSE;
		[self setNeedsDisplay];
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (self.target) {
		self.selected = FALSE;
		[self setNeedsDisplay];
	}
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{	
	self.selected = FALSE;
	[self setNeedsDisplay];
	[self.target performSelector:self.selector withObject:nil];
	
}


- (void)dealloc {
	[_target release];
    [_font release];
	[_text release];
	
	[super dealloc];
}


@end
