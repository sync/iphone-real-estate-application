//
//  BigFramedPhotoView.m
//  ozEstate
//
//  Created by Anthony Mittaz on 9/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import "BigFramedPhotoView.h"


@implementation BigFramedPhotoView

@synthesize rotation=_rotation;
@synthesize image=_image;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		self.rotation = 0;
		self.opaque = TRUE;
		self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
	[super drawRect:rect];
	// Retrieve the graphics context 
	CGContextRef context = UIGraphicsGetCurrentContext(); 
	
	// Save the context state 
	CGContextSaveGState(context);
	
	// Apply rotationa
	CGAffineTransform transform = CGAffineTransformIdentity;
	transform = CGAffineTransformRotate(transform, self.rotation);
	
	CGContextConcatCTM(context, transform);
	
	// Draw bottom image
	
	
	[[(ozEstateAppDelegate *)[[UIApplication sharedApplication]delegate] cachedImage:@"bottom_big_image_frame.png"] drawInRect:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, 320.0, 367.0) blendMode:kCGBlendModeNormal alpha:1.0];
	
	if (self.image) {
		[self.image drawInRect:CGRectMake(self.bounds.origin.x + 28.0, self.bounds.origin.y + 60.0, 268.0, 227.0) blendMode:kCGBlendModeNormal alpha:1.0];
	}
	
	// Draw top image
	NSString *topImagePath = @"top_big_image_frame.png";
	
	[[(ozEstateAppDelegate *)[[UIApplication sharedApplication]delegate] cachedImage:topImagePath] drawInRect:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, 320.0, 367.0) blendMode:kCGBlendModeNormal alpha:1.0];
	
	CGContextRestoreGState(context);
	
}

- (void)dealloc {
	[_image release];
	
	[super dealloc];
}


@end
