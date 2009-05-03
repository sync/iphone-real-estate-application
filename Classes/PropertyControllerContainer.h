//
//  PropertyControllerContainer.h
//  ozEstate
//
//  Created by Anthony Mittaz on 7/03/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class PropertyController;

@interface PropertyControllerContainer : BaseViewController <UIScrollViewDelegate>{
	BOOL _favorite;
	
	NSNumber *_property_id;
	
	UIScrollView *_scrollView;
	UIPageControl *_pageControl;
	
	PropertyController *_firstController;
	PropertyController *_secondController;
	
	NSInteger _favoritesCount;
	
	NSInteger _initialPosition;
	
	NSString *_state;
	
	CGFloat _lastScrolledXPosition;
}

@property (nonatomic) BOOL favorite;
@property (nonatomic, retain) NSNumber *property_id;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) IBOutlet PropertyController *firstController;
@property (nonatomic, retain) IBOutlet PropertyController *secondController;
@property (nonatomic) NSInteger favoritesCount;
@property (nonatomic) NSInteger initialPosition;
@property (nonatomic, retain) NSString *state;
@property (nonatomic) CGFloat lastScrolledXPosition;

- (IBAction)pushPhotoViewController:(id)sender;
- (IBAction)pushMoreInfosController:(id)sender;
- (IBAction)pushAgencyController:(id)sender;

- (void)addToFavorite:(id)sender;
- (void)removeFromFavorite:(id)sender;

- (void)shouldEnableScrollAndShowPageControl:(id)sender;

- (IBAction)loadPage:(id)sender;

@end
