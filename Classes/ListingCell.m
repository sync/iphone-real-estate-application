//
//  LocationCell.m
//  ozEstate
//
//  Created by Anthony Mittaz on 27/09/08.
//  Copyright 2008 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import "ListingCell.h"
#import "ListingCellView.h"
#import "CellBackgroundWithImage.h"

@implementation ListingCell

@synthesize highlighted=_highlighted;

#pragma mark -
#pragma mark Initialisation:

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		// Initialization code
		self.opaque = TRUE;
		self.backgroundColor = [UIColor clearColor];
		CGRect cellFrame = CGRectMake(0.0, 0.0, self.contentView.bounds.size.width, 130.0);
		// BackgroundView
		CellBackgroundWithImage *backgroundView = [CellBackgroundWithImage backgroundViewWithFrame:cellFrame andBackgroundImage:[(ozEstateAppDelegate *)[[UIApplication sharedApplication]delegate] cachedImage:@"transparent_selected_cell_empty.png"]];
		self.backgroundView = backgroundView;
		// Selected backgroundView
		CellBackgroundWithImage *selectedBackgroundView = [CellBackgroundWithImage backgroundViewWithFrame:cellFrame andBackgroundImage:[(ozEstateAppDelegate *)[[UIApplication sharedApplication]delegate] cachedImage:@"listing_selected_background.png"]];
		self.selectedBackgroundView = selectedBackgroundView;
		
		ListingCellView *cellView = [ListingCellView viewWithFrame:cellFrame selected:FALSE];
		cellView.tag = LISTING_CELL_VIEW;
		[self addSubview:cellView];
	}
	return self;
}

- (void)layoutSubviews
{
	
	//	// Day
	//	UILabel *dayLabel = (UILabel *)[self viewWithTag:DAY_LABEL_TAG];
	//	dayLabel.frame = CGRectMake(10.0, 10.0, 300.0, 18.0);
	//	
	//	UILabel *conditionsLabel = (UILabel *)[self viewWithTag:CONDITIONS_LABEL_TAG];
	//	CGRect conditionsRect = [conditionsLabel textRectForBounds:CGRectMake(10.0, 28.0, 160.0, 16.0) limitedToNumberOfLines:1];
	//
	//	conditionsLabel.frame = conditionsRect;
	//	UILabel *waveLabel = (UILabel *)[self viewWithTag:WAVE_LABEL_TAG];
	//	waveLabel.frame = CGRectMake(conditionsRect.size.width + 15.0, 28.0, 300.0 - conditionsRect.size.width - 15.0, 16.0);
	//	
	//	CGFloat rowHeight = self.bounds.size.height;
	//	
	//	// Description
	//	UILabel *descriptionLabel = (UILabel *)[self viewWithTag:DESCRIPTION_LABEL_TAG];
	//	// Place this field under the top image
	//	CGFloat descriptionHeight = rowHeight - 55.0 - 5.0;
	//	descriptionLabel.frame = CGRectMake(10.0, 55.0 + 5.0 , 300.0, descriptionHeight - 5.0);
	
	
	
	[super layoutSubviews];
	
}

- (void)prepareForReuse
{
	[super prepareForReuse];
	
	[(ListingCellView *)[self viewWithTag:LISTING_CELL_VIEW]removeFromSuperview];
	
	CGRect cellFrame = CGRectMake(0.0, 0.0, self.contentView.bounds.size.width, 130.0);
	ListingCellView *cellView = [ListingCellView viewWithFrame:cellFrame selected:FALSE];
	cellView.tag = LISTING_CELL_VIEW;
	[self addSubview:cellView];
}

- (void)setBathroomNumber:(NSString *)aValue
{
	[(ListingCellView *)[self viewWithTag:LISTING_CELL_VIEW]setBathroomNumber:aValue];
}

- (void)setBedroomNumber:(NSString *)aValue
{
	[(ListingCellView *)[self viewWithTag:LISTING_CELL_VIEW]setBedroomNumber:aValue];
}

- (void)setGarageNumber:(NSString *)aValue
{
	[(ListingCellView *)[self viewWithTag:LISTING_CELL_VIEW]setGarageNumber:aValue];
}

- (void)setPrice:(NSString *)aValue
{
	[(ListingCellView *)[self viewWithTag:LISTING_CELL_VIEW]setPrice:aValue];
}

- (void)setStreetName:(NSString *)aValue
{
	[(ListingCellView *)[self viewWithTag:LISTING_CELL_VIEW]setStreetName:aValue];
}

- (void)setDistance:(NSString *)aValue
{
	[(ListingCellView *)[self viewWithTag:LISTING_CELL_VIEW]setDistance:aValue];
}

- (void)setPropertyImage:(UIImage *)aValue
{
	[(ListingCellView *)[self viewWithTag:LISTING_CELL_VIEW]setPropertyImage:aValue];
}


#pragma mark -
#pragma mark Allow The TableView To Draw Differently When Cell Selected:

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
	[super setSelected:selected animated:animated];
	
	// Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)lit {
	// If highlighted state changes, need to redisplay.
	if (_highlighted != lit) {
		_highlighted = lit;	
		[self setNeedsDisplay];
	}
}

#pragma mark -
#pragma mark Dealloc:

- (void)dealloc {
    
	[super dealloc];
}


@end