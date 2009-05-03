//
//  ViewWithImageAndAction.m
//  ozEstate
//
//  Created by Anthony Mittaz on 15/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import "LoadingViewFrameWithAction.h"


@implementation LoadingViewFrameWithAction


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
	LoadingViewFrameWithAction *cellView = [[[LoadingViewFrameWithAction alloc]initWithFrame:frame]autorelease];
	cellView.backgroundImage = image;
	return cellView;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
	// Retrieve the graphics context 
	CGContextRef context = UIGraphicsGetCurrentContext(); 
	// draw image
	NSString *imagePath = @"loading_image_frame.png";
	if (self.selected) {
		imagePath = @"loading_image_frame_selected.png";
	}
	[[(ozEstateAppDelegate *)[[UIApplication sharedApplication]delegate] cachedImage:imagePath] drawInRect:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width,self.bounds.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
	
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
	[[NSNotificationCenter defaultCenter]postNotificationName:ShouldCancelAllOperationsDataFetcher object:nil];
	self.selected = FALSE;
	[self setNeedsDisplay];
	
}



- (void)dealloc {
	[_title release];
	[_backgroundImage release];
	
	[super dealloc];
}

@end
