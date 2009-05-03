//
//  ImageWithAction.m
//  ozEstate
//
//  Created by Anthony Mittaz on 12/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import "SearchMorePanel.h"


@implementation SearchMorePanel

@synthesize target=_target;
@synthesize selector=_selector;
@synthesize cancelSelector=_cancelSelector;
@synthesize title=_title;
@synthesize cancelSelected=_cancelSelected;
@synthesize selected=_selected;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		self.cancelSelected = FALSE;
		self.selected = FALSE;
		self.backgroundColor = [UIColor clearColor];
		self.opaque = FALSE;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
	
	// Draw top bottom image
	NSString *imagePath = nil;
	if (self.cancelSelected ) {
		imagePath = @"more_search_info_selected.png";
	} else {
		imagePath = @"more_search_info.png";
	}
	[[(ozEstateAppDelegate *)[[UIApplication sharedApplication]delegate] cachedImage:imagePath] drawInRect:CGRectMake(self.bounds.origin.x, self.bounds.origin.y , 320.0, 44.0) blendMode:kCGBlendModeNormal alpha:0.8];
	
	// Draw text
	UIFont *boldFont = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:13.0];
	UIColor *textColor = [UIColor whiteColor];
	UIColor *textColorSelected = [UIColor colorWithRed:129.0/255.0 green:9.0/255.0 blue:38.0/255.0 alpha:1.0];
	UIColor *cancelTextColor = [UIColor whiteColor];
	
	if (self.title) {
		if (self.selected) {
			[textColorSelected set];
		} else {
			[textColor set];
		}
		[self.title drawInRect:CGRectMake(self.bounds.origin.x, self.bounds.origin.y + 1.0 + 5.5, 210.0, 30.0) withFont:boldFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentRight];
	}
	
	NSString *cancelText = @"Close";
	[cancelTextColor set];
	
	[cancelText drawInRect:CGRectMake(self.bounds.origin.x + 244.0, self.bounds.origin.y + 9.0 + 5.5, 65.0, 20.0) withFont:boldFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
	
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch* touch = [[event touchesForView:self] anyObject];
	CGPoint touchLocation = [touch locationInView:self];
	
	CGRect rectSize = CGRectMake(self.bounds.origin.x + 244.0, self.bounds.origin.y + 9.0 + 5.5, 65.0, 20.0);
	CGRect allRectSize = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, 320.0, 44.0);
	
	if (CGRectContainsPoint(rectSize, touchLocation)) {
		self.cancelSelected = TRUE;
		[self setNeedsDisplay];
	} else if (CGRectContainsPoint(allRectSize, touchLocation)) {
		self.selected = TRUE;
		[self setNeedsDisplay];
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	self.cancelSelected = FALSE;
	self.selected = FALSE;
	[self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	self.cancelSelected = FALSE;
	self.selected = FALSE;
	[self setNeedsDisplay];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch* touch = [[event touchesForView:self] anyObject];
	CGPoint touchLocation = [touch locationInView:self];
	
	CGRect rectSize = CGRectMake(self.bounds.origin.x + 244.0, self.bounds.origin.y + 9.0 + 5.5, 65.0, 20.0);
	CGRect allRectSize = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, 320.0, 44.0);
	
	if (CGRectContainsPoint(rectSize, touchLocation)) {
		self.cancelSelected = FALSE;
		[self setNeedsDisplay];
		[self.target performSelector:self.cancelSelector withObject:self];
	} else if (CGRectContainsPoint(allRectSize, touchLocation)) {
		self.selected = FALSE;
		[self setNeedsDisplay];
		[self.target performSelector:self.selector withObject:self];
	}
	
}


- (void)dealloc {
    [_title release];
	[_target release];
	
	[super dealloc];
}


@end
