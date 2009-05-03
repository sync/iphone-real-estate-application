//
//  LocationsSearchBar.m
//  ozEstate
//
//  Created by Anthony Mittaz on 21/09/08.
//  Copyright 2008 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
// 

#import "CustomSearchBar.h"


@implementation CustomSearchBar


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}


//- (void)drawRect:(CGRect)rect {
//    [super drawRect:rect];
//	// Drawing code
//	UIImage *backgroundImage = [(ozEstateAppDelegate *)[[UIApplication sharedApplication]delegate] cachedImage:@"search_bar_background.png"];
//	[backgroundImage drawInRect:self.bounds];
//}


- (void)dealloc {
    [super dealloc];
}


@end
