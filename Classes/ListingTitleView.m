//
//  TitleBackgroundViewWithImage.m
//  ozEstate
//
//  Created by Anthony Mittaz on 6/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import "ListingTitleView.h"

@implementation ListingTitleView

@synthesize title=_title;
@synthesize photoFrameTarget=_photoFrameTarget;
@synthesize photoFrameSelector=_photoFrameSelector;
@synthesize noteTarget=_noteTarget;
@synthesize noteSelector=_noteSelector;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		self.heightDiffFromTop = 40.0;
    }
    return self;
}

+ (id)viewWithFrame:(CGRect)frame selected:(BOOL)selected
{
	ListingTitleView *cellView = [[[ListingTitleView alloc]initWithFrame:frame]autorelease];
	cellView.selected = selected;
	return cellView;
}



- (void)drawRect:(CGRect)rect {
    // Drawing code
	// Retrieve the graphics context 
	CGContextRef context = UIGraphicsGetCurrentContext(); 
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
		[self.title drawInRect:CGRectMake(self.bounds.origin.x + 30.0, self.bounds.origin.y + 15.0, self.bounds.size.width - 50.0,self.bounds.size.height) withFont:boldFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
		CGContextRestoreGState(context);
	}
	
	[super drawRect:rect];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch* touch = [[event touchesForView:self] anyObject];
	CGPoint touchLocation = [touch locationInView:self];
	
	// Photo frame
	CGRect photoFrameRect = CGRectMake(self.bounds.origin.x + 30.0, self.bounds.origin.y + self.heightDiffFromTop - 10.0, 95.0, 100.0);
	
	// Note
	CGRect noteRect =CGRectMake(self.bounds.origin.x + 180, self.bounds.origin.y + self.heightDiffFromTop, 115.0, 100.0);
	
	// Inside photo frame
	if (CGRectContainsPoint(photoFrameRect, touchLocation)) {
		self.selectedPhotoFrame = TRUE;
		[self setNeedsDisplay];
	} else if (CGRectContainsPoint(noteRect, touchLocation)) {
		self.selectedNote = TRUE;
		[self setNeedsDisplay];
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	self.selectedPhotoFrame = FALSE;
	self.selectedNote = FALSE;
	[self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	self.selectedPhotoFrame = FALSE;
	self.selectedNote = FALSE;
	[self setNeedsDisplay];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch* touch = [[event touchesForView:self] anyObject];
	CGPoint touchLocation = [touch locationInView:self];
	
	// Photo frame
	CGRect photoFrameRect = CGRectMake(self.bounds.origin.x + 30.0, self.bounds.origin.y + self.heightDiffFromTop - 10.0, 95.0, 100.0);
	
	// Note
	CGRect noteRect =CGRectMake(self.bounds.origin.x + 180, self.bounds.origin.y + self.heightDiffFromTop, 115.0, 100.0);
	
	// Inside photo frame
	if (CGRectContainsPoint(photoFrameRect, touchLocation)) {
		self.selectedPhotoFrame = FALSE;
		[self setNeedsDisplay];
		[self.photoFrameTarget performSelector:self.photoFrameSelector withObject:self];
	} else if (CGRectContainsPoint(noteRect, touchLocation)) {
		self.selectedNote = FALSE;
		[self setNeedsDisplay];
		[self.noteTarget performSelector:self.noteSelector withObject:self];
	}
	
}


- (void)dealloc {
	[_photoFrameTarget release];
	[_noteTarget release];
	[_title release];
	
	[super dealloc];
}


@end
