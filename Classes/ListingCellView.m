//
//  BackgroundView.m
//  ozEstate
//
//  Created by Anthony Mittaz on 7/10/08.
//  Copyright 2008 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import "ListingCellView.h"

@implementation ListingCellView

@synthesize bathroomNumber=_bathroomNumber;
@synthesize bedroomNumber=_bedroomNumber;
@synthesize garageNumber=_garageNumber;
@synthesize price=_price;
@synthesize streetName=_streetName;
@synthesize distance=_distance;
@synthesize propertyImage=_propertyImage;
@synthesize heightDiffFromTop=_heightDiffFromTop;
@synthesize selected=_selected;
@synthesize selectedPhotoFrame=_selectedPhotoFrame;
@synthesize selectedNote=_selectedNote;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		self.opaque = TRUE;
		self.backgroundColor = [UIColor clearColor];
		self.heightDiffFromTop = 15.0;
		self.selectedPhotoFrame = FALSE;
		self.selectedNote = FALSE;
    }
    return self;
}

+ (id)viewWithFrame:(CGRect)frame selected:(BOOL)selected;
{
	ListingCellView *cellView = [[[ListingCellView alloc]initWithFrame:frame]autorelease];
	cellView.selected = selected;
	return cellView;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
	// Retrieve the graphics context 
	CGContextRef context = UIGraphicsGetCurrentContext(); 
	 if (!self.selected) {
		if (TRUE) {
			// Save the context state 
			CGContextSaveGState(context);
			
			// Apply rotationa
			CGAffineTransform transform = CGAffineTransformIdentity;
			transform = CGAffineTransformRotate(transform, 0.17907079);
			
			CGContextConcatCTM(context, transform);
			
			// Draw bottom image
			[[(ozEstateAppDelegate *)[[UIApplication sharedApplication]delegate] cachedImage:@"framed_picture_bottom.png"] drawInRect:CGRectMake(self.bounds.origin.x + 30.0, self.bounds.origin.y + self.heightDiffFromTop - 10.0, 95.0, 100.0) blendMode:kCGBlendModeNormal alpha:1.0];
			
			if (self.propertyImage) {
				[self.propertyImage drawInRect:CGRectMake(self.bounds.origin.x + 30.0 + 12.0, self.bounds.origin.y + self.heightDiffFromTop - 10.0 + 13.0, 71.0, 61.0) blendMode:kCGBlendModeNormal alpha:1.0];
			}
			
			// Draw top image
			NSString *imagePath = nil;
			if (self.selectedPhotoFrame) {
				imagePath = @"framed_picture_top_selected.png";
			} else {
				imagePath = @"framed_picture_top.png";
			}
			[[(ozEstateAppDelegate *)[[UIApplication sharedApplication]delegate] cachedImage:imagePath] drawInRect:CGRectMake(self.bounds.origin.x + 30.0, self.bounds.origin.y + self.heightDiffFromTop - 10.0, 95.0, 100.0) blendMode:kCGBlendModeNormal alpha:1.0];
			CGContextRestoreGState(context);
		}
		
		if (self.bedroomNumber) {
			// Save the context state 
			CGContextSaveGState(context);
			
			// Set shadow
			CGContextSetShadowWithColor(context,  CGSizeMake(0.0, -1.0), 0.5, [[UIColor whiteColor]CGColor]);
			// Draw image
			[[(ozEstateAppDelegate *)[[UIApplication sharedApplication]delegate] cachedImage:@"bedroom(16x12).png"] drawInRect:CGRectMake(self.bounds.origin.x + 132.0, self.bounds.origin.y + self.heightDiffFromTop + 20.0, 16.0, 12.0) blendMode:kCGBlendModeNormal alpha:1.0];
			
			// Draw text
			UIFont *boldFont = [UIFont fontWithName:@"Marker Felt" size:18.0];
			UIColor *bigColor = [UIColor colorWithRed:97.0/255.0 green:58.0/255.0 blue:21.0/255.0 alpha:1.0];
			[bigColor set];
			[self.bedroomNumber drawInRect:CGRectMake(self.bounds.origin.x + 132.0 + 20.0, self.bounds.origin.y + self.heightDiffFromTop - 2.0 + 20.0, 50.0, 20.0) withFont:boldFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentLeft];
			
			CGContextRestoreGState(context);
		}
		
		if (self.bathroomNumber) {
			// Save the context state 
			CGContextSaveGState(context);
			
			// Set shadow
			CGContextSetShadowWithColor(context,  CGSizeMake(0.0, -1.0), 0.5, [[UIColor whiteColor]CGColor]);
			// Draw image
			[[(ozEstateAppDelegate *)[[UIApplication sharedApplication]delegate] cachedImage:@"bathroom(16x12).png"] drawInRect:CGRectMake(self.bounds.origin.x + 132.0, self.bounds.origin.y + self.heightDiffFromTop + 20.0 + 30.0, 16.0, 12.0) blendMode:kCGBlendModeNormal alpha:1.0];
			
			// Draw text
			UIFont *boldFont = [UIFont fontWithName:@"Marker Felt" size:18.0];
			UIColor *bigColor = [UIColor colorWithRed:97.0/255.0 green:58.0/255.0 blue:21.0/255.0 alpha:1.0];
			[bigColor set];
			[self.bathroomNumber drawInRect:CGRectMake(self.bounds.origin.x + 132.0 + 20.0, self.bounds.origin.y + self.heightDiffFromTop - 2.0 + 20.0 + 30.0, 50.0, 20.0) withFont:boldFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentLeft];
			
			CGContextRestoreGState(context);
		}
		
		if (self.garageNumber) {
			// Save the context state 
			CGContextSaveGState(context);
			
			// Set shadow
			CGContextSetShadowWithColor(context,  CGSizeMake(0.0, -1.0), 0.5, [[UIColor whiteColor]CGColor]);
			// Draw image
			[[(ozEstateAppDelegate *)[[UIApplication sharedApplication]delegate] cachedImage:@"garage(16x12).png"] drawInRect:CGRectMake(self.bounds.origin.x + 132.0, self.bounds.origin.y + self.heightDiffFromTop + 20.0 + 60.0, 16.0, 12.0) blendMode:kCGBlendModeNormal alpha:1.0];
			
			// Draw text
			UIFont *boldFont = [UIFont fontWithName:@"Marker Felt" size:18.0];
			UIColor *bigColor = [UIColor colorWithRed:97.0/255.0 green:58.0/255.0 blue:21.0/255.0 alpha:1.0];
			[bigColor set];
			[self.garageNumber drawInRect:CGRectMake(self.bounds.origin.x + 132.0 + 20.0, self.bounds.origin.y + self.heightDiffFromTop - 2.0 + 20.0 + 60.0, 50.0, 20.0) withFont:boldFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentLeft];
			
			CGContextRestoreGState(context);
		}
		
		if (TRUE) {
			// Save the context state 
			CGContextSaveGState(context);
			
			// Apply rotationa
			CGAffineTransform transform = CGAffineTransformIdentity;
			transform = CGAffineTransformRotate(transform, 0.017453292);
			
			CGContextConcatCTM(context, transform);
			
			// Draw bottom image
			NSString *imagePath = nil;
			if (self.selectedNote) {
				imagePath = @"paper_selected.png";
			} else {
				imagePath = @"paper.png";
			}
			[[(ozEstateAppDelegate *)[[UIApplication sharedApplication]delegate] cachedImage:imagePath] drawInRect:CGRectMake(self.bounds.origin.x + 180, self.bounds.origin.y + self.heightDiffFromTop, 115.0, 100.0) blendMode:kCGBlendModeNormal alpha:1.0];
			
			// Draw text
			UIFont *boldFont = [UIFont fontWithName:@"American Typewriter" size:14.0];
			UIColor *priceColor = [UIColor redColor];
			UIColor *textColor = [UIColor colorWithRed:97.0/255.0 green:58.0/255.0 blue:21.0/255.0 alpha:1.0];
			
			
			if (self.price) {
				[priceColor set];
				[self.price drawInRect:CGRectMake(self.bounds.origin.x + 185.0 + 15.0, self.bounds.origin.y + self.heightDiffFromTop + 12.0, 85.0, 16.0) withFont:boldFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentRight];
				
			}
			
			if (self.streetName) {
				[textColor set];
				[self.streetName drawInRect:CGRectMake(self.bounds.origin.x + 182.0 + 5.0, self.bounds.origin.y + self.heightDiffFromTop + 13.0 + 13.0, 100.0, 48.0) withFont:boldFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentLeft];
				
			}
			
			if (self.distance) {
				[textColor set];
				[self.distance drawInRect:CGRectMake(self.bounds.origin.x + 185.0 + 15.0, self.bounds.origin.y + self.heightDiffFromTop + 13.0 + 61.0, 85.0, 16.0) withFont:boldFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentRight];
				
			}
			
			[textColor set];
			
			CGContextRestoreGState(context);
		}
	}
}

- (void)dealloc {
   
	[_bathroomNumber release];
	[_bedroomNumber release];
	[_garageNumber release];
	[_price release];
	[_streetName release];
	[_distance release];
	[_propertyImage release];
	
	[super dealloc];
}


@end
