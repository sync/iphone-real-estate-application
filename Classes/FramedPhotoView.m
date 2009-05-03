//
//  FramedPhotoView.m
//  ozEstate
//
//  Created by Anthony Mittaz on 8/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import "FramedPhotoView.h"

@implementation FramedPhotoView

@synthesize rotation=_rotation;
@synthesize selected=_selected;
@synthesize image=_image;
@synthesize target=_target;
@synthesize selector=_selector;
@synthesize index=_index;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		self.rotation = 0;
		self.selected = FALSE;
		self.opaque = TRUE;
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
	[[(ozEstateAppDelegate *)[[UIApplication sharedApplication]delegate] cachedImage:@"bottom_medium_photo_frame.png"] drawInRect:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, 160.0, 183.5) blendMode:kCGBlendModeNormal alpha:1.0];
	
	if (self.image) {
		// x73 y 96
		[self.image drawInRect:CGRectMake(self.bounds.origin.x + 28.0, self.bounds.origin.y + 44.0, 106.0, 90.0) blendMode:kCGBlendModeNormal alpha:1.0];
	}
	
	// Draw top image
	NSString *topImagePath = nil;
	if (self.selected) {
		topImagePath = @"top_medium_photo_frame_selected.png";
	} else {
		topImagePath = @"top_medium_photo_frame.png";
	}
	
	[[(ozEstateAppDelegate *)[[UIApplication sharedApplication]delegate] cachedImage:topImagePath] drawInRect:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, 160.0, 183.5) blendMode:kCGBlendModeNormal alpha:1.0];
	
	CGContextRestoreGState(context);
		
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch* touch = [[event touchesForView:self] anyObject];
	CGPoint touchLocation = [touch locationInView:self];
	
	CGRect rectSize = CGRectMake(22.0, 30.0, 116.0, 110.0);
	
	if (CGRectContainsPoint(rectSize, touchLocation)) {
		self.selected = TRUE;
		[self setNeedsDisplay];
	}
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
	UITouch* touch = [[event touchesForView:self] anyObject];
	CGPoint touchLocation = [touch locationInView:self];
	
	CGRect rectSize = CGRectMake(22.0, 30.0, 116.0, 110.0);
	
	if (CGRectContainsPoint(rectSize, touchLocation)) {
		self.selected = FALSE;
		[self setNeedsDisplay];
		[self.target performSelector:self.selector withObject:[NSNumber numberWithInteger:self.index]];
	}
	
}


- (void)dealloc {
    [_target release];
	[_image release];
	
	[super dealloc];
}


@end
