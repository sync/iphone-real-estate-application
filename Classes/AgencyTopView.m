//
//  AgencyTopView.m
//  ozEstate
//
//  Created by Anthony Mittaz on 9/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import "AgencyTopView.h"

@implementation AgencyTopView

@synthesize streetName=_streetName;
@synthesize title=_title;
@synthesize distance=_distance;
@synthesize heightDiffFromTop=_heightDiffFromTop;
@synthesize selected=_selected;
@synthesize textToSend=_textToSend;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		self.opaque = TRUE;
		self.backgroundColor = [UIColor clearColor];
		self.heightDiffFromTop = 40.0;
    }
    return self;
}

+ (id)viewWithFrame:(CGRect)frame selected:(BOOL)selected;
{
	AgencyTopView *cellView = [[[AgencyTopView alloc]initWithFrame:frame]autorelease];
	cellView.selected = selected;
	return cellView;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
	// Retrieve the graphics context 
	CGContextRef context = UIGraphicsGetCurrentContext(); 
	if (!self.selected) {
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
			[self.title drawInRect:CGRectMake(self.bounds.origin.x + 30.0, self.bounds.origin.y + 15.0, self.bounds.size.width - 50.0,self.bounds.size.height) withFont:boldFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
			CGContextRestoreGState(context);
		}
		
		
		// Save the context state 
		CGContextSaveGState(context);
		
		// Apply rotationa
		CGAffineTransform transform = CGAffineTransformIdentity;
		transform = CGAffineTransformRotate(transform, 0.0);
		
		CGContextConcatCTM(context, transform);
		
		// Draw bottom image
		[[(ozEstateAppDelegate *)[[UIApplication sharedApplication]delegate] cachedImage:@"postcard_background.png"] drawInRect:CGRectMake(self.bounds.origin.x, self.bounds.origin.y + self.heightDiffFromTop, 320, 200.0) blendMode:kCGBlendModeNormal alpha:1.0];
		
		// Draw text
		UIFont *boldFont = [UIFont fontWithName:@"American Typewriter" size:14.0];
		UIColor *textColor = [UIColor colorWithRed:97.0/255.0 green:58.0/255.0 blue:21.0/255.0 alpha:1.0];
		
		if (self.textToSend) {
			[textColor set];
			[self.textToSend drawInRect:CGRectMake(self.bounds.origin.x + 30.0 + 5.0, self.bounds.origin.y + self.heightDiffFromTop + 15.0 + 13.0, 130.0, 158.0) withFont:boldFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentLeft];
			
		}
		
		if (self.streetName) {
			[textColor set];
			[self.streetName drawInRect:CGRectMake(self.bounds.origin.x + 173.0 + 5.0 + 5.0, self.bounds.origin.y + self.heightDiffFromTop + 76.0, 100.0, 100.0) withFont:boldFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentLeft];
			
		}
		
		[textColor set];
		
		CGContextRestoreGState(context);
	}
}

- (void)dealloc {
	[_textToSend release];
	[_distance release];
	[_title release];
	[_streetName release];
	
	[super dealloc];
}


@end
