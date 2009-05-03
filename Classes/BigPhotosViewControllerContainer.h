//
//  BigPhotosViewController.h
//  ozEstate
//
//  Created by Anthony Mittaz on 9/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class BigPhotoViewController;

@interface BigPhotosViewControllerContainer : BaseViewController <UIScrollViewDelegate>{
	NSNumber *_property_id;
	
	UIScrollView *_scrollView;
	UIPageControl *_pageControl;
	NSInteger _initialPosition;
	
	BigPhotoViewController *_firstController;
	BigPhotoViewController *_secondController;
	
	NSInteger _photosCount;
	
	CGFloat _lastScrolledXPosition;
}


@property (nonatomic, retain) NSNumber *property_id;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic) NSInteger initialPosition;
@property (nonatomic, retain) IBOutlet BigPhotoViewController *firstController;
@property (nonatomic, retain) IBOutlet BigPhotoViewController *secondController;
@property (nonatomic) NSInteger photosCount;
@property (nonatomic) CGFloat lastScrolledXPosition;


- (IBAction)loadPage:(id)sender;


@end
