//
//  BigPhotoViewController.m
//  ozEstate
//
//  Created by Anthony Mittaz on 13/03/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import "BigPhotoViewController.h"
#import "BigFramedPhotoView.h"

@implementation BigPhotoViewController

@synthesize image_id=_image_id;
@synthesize bigImage=_bigImage;
@synthesize pageIndex=_pageIndex;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
    [super viewDidLoad];
}

- (void)fetchDb
{
	UIImage *image = [self.appDelegate.bigImagesCache valueForKey:[NSString stringWithFormat:@"%@", self.image_id]];
	if (!image) {
		NSData *data = [self.appDelegate.userdb dataForQuery:@"select data from images where id = ?", self.image_id];
		image = [UIImage imageWithData:data];
		[self.appDelegate.bigImagesCache setValue:image forKey:[NSString stringWithFormat:@"%@", self.image_id]];
	}
	self.bigImage.image = image;
	[self.bigImage setNeedsDisplay];	
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [_image_id release];
	[_bigImage release];
	
	[super dealloc];
}


@end
