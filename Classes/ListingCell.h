//
//  ListingCell.h
//  ozEstate
//
//  Created by Anthony Mittaz on 7/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import <UIKit/UIKit.h>


@interface ListingCell : UITableViewCell {
	BOOL _highlighted;
}

@property (nonatomic, getter=isHighlighted) BOOL highlighted;

- (void)setBathroomNumber:(NSString *)aValue;
- (void)setBedroomNumber:(NSString *)aValue;
- (void)setGarageNumber:(NSString *)aValue;
- (void)setPrice:(NSString *)aValue;
- (void)setStreetName:(NSString *)aValue;
- (void)setDistance:(NSString *)aValue;
- (void)setPropertyImage:(UIImage *)aValue;

@end
