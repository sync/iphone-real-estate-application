//
//  TransparentCell.h
//  ozEstate
//
//  Created by Anthony Mittaz on 6/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import <UIKit/UIKit.h>

typedef enum {
    UITableViewCellPositionTop, 
    UITableViewCellPositionMiddle,
	UITableViewCellPositionBottom,
	UITableViewCellPositionUnique
} UITableViewCellPosition;


@interface TransparentCell : UITableViewCell {
	BOOL _highlighted;
}

@property (nonatomic, getter=isHighlighted) BOOL highlighted;

+ (id)cellWithFrame:(CGRect)frame position:(UITableViewCellPosition)position andAccessoryType:(UITableViewCellAccessoryType)accessoryType differentSelectedBackground:(BOOL)differentSelectedBackground;

- (void)setTitle:(NSString *)aValue;
- (void)setImage:(UIImage *)aValue;

- (void)setShowCheckmark:(BOOL)show;

@end
