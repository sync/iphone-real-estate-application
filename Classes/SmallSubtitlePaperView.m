//
//  SmallSubtitlePaperView.m
//  ozEstate
//
//  Created by Anthony Mittaz on 7/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import "SmallSubtitlePaperView.h"


@implementation SmallSubtitlePaperView


@synthesize rotation=_rotation;
@synthesize title=_title;
@synthesize subtitle=_subtitle;
@synthesize target=_target;
@synthesize selector=_selector;
@synthesize selected=_selected;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		self.rotation = 0;
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
	// Retrieve the graphics context 
	CGContextRef context = UIGraphicsGetCurrentContext(); 
	
	// Save the context state 
	CGContextSaveGState(context);
	
	// Apply rotationa
	CGAffineTransform transform = CGAffineTransformIdentity;
	transform = CGAffineTransformRotate(transform, self.rotation);
	
	CGContextConcatCTM(context, transform);
	
	// Draw bottom image
	[[(ozEstateAppDelegate *)[[UIApplication sharedApplication]delegate] cachedImage:@"paper_small.png"] drawInRect:CGRectMake(self.bounds.origin.x + 10.0, self.bounds.origin.y + 10.0, 115.0, 76.0) blendMode:kCGBlendModeNormal alpha:1.0];
	
	// Draw edit button
	NSString *editImagePath = nil;
	if (self.selected ) {
		editImagePath = @"edit_button_selected.png";
	} else {
		editImagePath = @"edit_button.png";
	}
	[[(ozEstateAppDelegate *)[[UIApplication sharedApplication]delegate] cachedImage:editImagePath] drawInRect:CGRectMake(self.bounds.origin.x + 22.0, self.bounds.origin.y + 21.0, 27.0, 14.0) blendMode:kCGBlendModeNormal alpha:1.0];
	
	
	// Draw text
	UIFont *boldFont = [UIFont fontWithName:@"American Typewriter" size:14.0];
	UIColor *priceColor = [UIColor redColor];
	UIColor *textColor = [UIColor colorWithRed:97.0/255.0 green:58.0/255.0 blue:21.0/255.0 alpha:1.0];
	
	
	if (self.title) {
		[priceColor set];
		[self.title drawInRect:CGRectMake(self.bounds.origin.x + 10 + 15.0, self.bounds.origin.y + 12.0 + 10.0, 85.0, 16.0) withFont:boldFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentRight];
		
	}
	
	if (self.subtitle) {
		[textColor set];
		[self.subtitle drawInRect:CGRectMake(self.bounds.origin.x + 10 + 5.0, self.bounds.origin.y + 13.0 + 13.0 + 10.0, 100.0, 30.0) withFont:boldFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentLeft];
		
	}
	
	[textColor set];
	
	CGContextRestoreGState(context);
	
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
	[_subtitle release];
	[_title release];
	
    [super dealloc];
}


@end
