//
//  AccessoryViewWithImage.m
//  ozEstate
//
//  Created by Anthony Mittaz on 7/10/08.
//  Copyright 2008 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import "AccessoryViewWithImage.h"


@implementation AccessoryViewWithImage

@synthesize accessoryImage=_accessoryImage;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		self.opaque = TRUE;
		self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

+(id)accessoryViewWithFrame:(CGRect)frame andImage:(NSString *)imageNamed
{
	AccessoryViewWithImage *accessoryViewWithImage = [[[AccessoryViewWithImage alloc]initWithFrame:frame]autorelease];
	accessoryViewWithImage.accessoryImage = [(ozEstateAppDelegate *)[[UIApplication sharedApplication]delegate] cachedImage:imageNamed];
	return accessoryViewWithImage;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
	[self.accessoryImage drawInRect:rect];
}


- (void)dealloc {
    [_accessoryImage release];
	
	[super dealloc];
}


@end
