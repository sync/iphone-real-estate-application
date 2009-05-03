//
//  BigPhotoViewController.h
//  ozEstate
//
//  Created by Anthony Mittaz on 13/03/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
// 

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class BigFramedPhotoView;

@interface BigPhotoViewController : BaseViewController {
	NSNumber *_image_id;
	BigFramedPhotoView *_bigImage;
	NSInteger _pageIndex;
}

@property (nonatomic, retain) NSNumber *image_id;
@property (nonatomic, retain) IBOutlet BigFramedPhotoView *bigImage;
@property (nonatomic) NSInteger pageIndex;

- (void)fetchDb;

@end
