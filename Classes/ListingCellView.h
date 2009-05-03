//
//  BackgroundView.h
//  ozEstate
//
//  Created by Anthony Mittaz on 7/10/08.
//  Copyright 2008 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
// 

#import <UIKit/UIKit.h>
#import "CellBackgroundWithImage.h"

@interface ListingCellView : UIView {
	NSString *_bathroomNumber;
	NSString *_bedroomNumber;
	NSString *_garageNumber;
	NSString *_price;
	NSString *_streetName;
	NSString *_distance;
	UIImage *_propertyImage;
	BOOL _selected;
	BOOL _selectedPhotoFrame;
	BOOL _selectedNote;
	
	NSInteger _heightDiffFromTop;
}

@property (nonatomic, retain) NSString *bathroomNumber;
@property (nonatomic, retain) NSString *bedroomNumber;
@property (nonatomic, retain) NSString *garageNumber;
@property (nonatomic, retain) NSString *price;
@property (nonatomic, retain) NSString *streetName;
@property (nonatomic, retain) NSString *distance;
@property (nonatomic, retain) UIImage *propertyImage;
@property BOOL selected;
@property NSInteger heightDiffFromTop;
@property BOOL selectedPhotoFrame;
@property BOOL selectedNote;

+ (id)viewWithFrame:(CGRect)frame selected:(BOOL)selected;

@end
