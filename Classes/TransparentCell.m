//
//  TransparentCell.m
//  ozEstate
//
//  Created by Anthony Mittaz on 6/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#import "TransparentCell.h"
#import "CellBackgroundWithImage.h"
#import "AccessoryViewWithImage.h"
#import "TransparentCellView.h"

@implementation TransparentCell

@synthesize highlighted=_highlighted;

#pragma mark -
#pragma mark Initialisation:

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		// Initialization code
		self.opaque = TRUE;
		self.backgroundColor = [UIColor clearColor];
		
		CGRect cellFrame = CGRectMake(0.0, 0.0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
		TransparentCellView *cellView = [TransparentCellView viewWithFrame:cellFrame selected:FALSE];
		cellView.tag = TRANSPARENT_CELL_VIEW;
		[self addSubview:cellView];
		
		NSString *imageName = @"";
		NSString *selectedImageName = @"";
		
		if ([self.reuseIdentifier isEqual:TopTransparentCell]) {
			imageName = @"top_transparent_cell_background.png";
			selectedImageName = @"top_transparent_cell_background_selected.png";
		} else if ([self.reuseIdentifier isEqual:MiddleTransparentCell]) {
			imageName = @"transparent_cell_background.png";
			selectedImageName = @"transparent_cell_background_selected.png";
		} else if ([self.reuseIdentifier isEqual:BottomTransparentCell]) {
			imageName = @"bottom_transparent_cell_background.png";
			selectedImageName = @"bottom_transparent_cell_background_selected.png";
		} else if ([self.reuseIdentifier isEqual:UniqueTransparentCell]) {
			imageName = @"unique_transparent_cell_background.png";
			selectedImageName = @"unique_transparent_cell_background_selected.png";
		}
		
		CellBackgroundWithImage *backgroundView = [CellBackgroundWithImage backgroundViewWithFrame:cellFrame andBackgroundImage:[(ozEstateAppDelegate *)[[UIApplication sharedApplication]delegate] cachedImage:imageName]];
		self.backgroundView = backgroundView;
		
		CellBackgroundWithImage *selectedBackgroundView = [CellBackgroundWithImage backgroundViewWithFrame:cellFrame andBackgroundImage:[(ozEstateAppDelegate *)[[UIApplication sharedApplication]delegate] cachedImage:@"transparent_selected_cell_empty.png"]];
		self.selectedBackgroundView = selectedBackgroundView;
	}
	return self;
}

+ (id)cellWithFrame:(CGRect)frame position:(UITableViewCellPosition)position andAccessoryType:(UITableViewCellAccessoryType)accessoryType differentSelectedBackground:(BOOL)differentSelectedBackground
{
	// ContentView
//	TransparentCell *cell = nil;
//	CGRect cellFrame = CGRectMake(0.0, 0.0, cell.contentView.bounds.size.width, cell.contentView.bounds.size.height);
//	NSString *imageName = nil;
//	NSString *selectedImageName = nil;
//	switch (position) {
//		case UITableViewCellPositionTop:
//			cell = [[[TransparentCell alloc] initWithFrame:frame reuseIdentifier:TopTransparentCell] autorelease];
//			imageName = @"top_transparent_cell_background.png";
//			selectedImageName = @"top_transparent_cell_background_selected.png";
//			break;
//		case UITableViewCellPositionBottom:
//			cell = [[[TransparentCell alloc] initWithFrame:frame reuseIdentifier:BottomTransparentCell] autorelease];
//			imageName = @"bottom_transparent_cell_background.png";
//			selectedImageName = @"bottom_transparent_cell_background_selected.png";
//			break;
//		case UITableViewCellPositionUnique:
//			cell = [[[TransparentCell alloc] initWithFrame:frame reuseIdentifier:UniqueTransparentCell] autorelease];
//			imageName = @"unique_transparent_cell_background.png";
//			selectedImageName = @"unique_transparent_cell_background_selected.png";
//			break;
//		default:
//			cell = [[[TransparentCell alloc] initWithFrame:frame reuseIdentifier:MiddleTransparentCell] autorelease];
//			imageName = @"transparent_cell_background.png";
//			selectedImageName = @"transparent_cell_background_selected.png";
//			break;
//	}
	
	// ContentView
	
	NSString *imageName = nil;
	NSString *selectedImageName = nil;
	
	TransparentCell *cell = nil;
	CGRect cellFrame = CGRectMake(0.0, 0.0, cell.contentView.bounds.size.width, cell.contentView.bounds.size.height);
	switch (position) {
		case UITableViewCellPositionTop:
			cell = [[[TransparentCell alloc] initWithFrame:frame reuseIdentifier:TopTransparentCell] autorelease];
			imageName = @"top_transparent_cell_background.png";
			selectedImageName = @"top_transparent_cell_background_selected.png";
			break;
		case UITableViewCellPositionBottom:
			cell = [[[TransparentCell alloc] initWithFrame:frame reuseIdentifier:BottomTransparentCell] autorelease];
			imageName = @"bottom_transparent_cell_background.png";
			selectedImageName = @"bottom_transparent_cell_background_selected.png";
			break;
		case UITableViewCellPositionUnique:
			cell = [[[TransparentCell alloc] initWithFrame:frame reuseIdentifier:UniqueTransparentCell] autorelease];
			imageName = @"unique_transparent_cell_background.png";
			selectedImageName = @"unique_transparent_cell_background_selected.png";
			break;
		default:
			cell = [[[TransparentCell alloc] initWithFrame:frame reuseIdentifier:MiddleTransparentCell] autorelease];
			imageName = @"transparent_cell_background.png";
			selectedImageName = @"transparent_cell_background_selected.png";
			break;
	}
	
	
//	// BackgroundView
//	CellBackgroundWithImage *backgroundView = [CellBackgroundWithImage backgroundViewWithFrame:cellFrame andBackgroundImage:[(ozEstateAppDelegate *)[[UIApplication sharedApplication]delegate] cachedImage:imageName]];
//	cell.backgroundView = backgroundView;
	
	// Selected backgroundView
	if (!differentSelectedBackground) {
		selectedImageName = @"transparent_selected_cell_empty.png";
	}
	CellBackgroundWithImage *selectedBackgroundView = [CellBackgroundWithImage backgroundViewWithFrame:cellFrame andBackgroundImage:[(ozEstateAppDelegate *)[[UIApplication sharedApplication]delegate] cachedImage:selectedImageName]];
	cell.selectedBackgroundView = selectedBackgroundView;
	
	// AccessoryView
	AccessoryViewWithImage *accessoryView = nil;
	switch (accessoryType) {
		case UITableViewCellAccessoryDisclosureIndicator:
			accessoryView = [AccessoryViewWithImage accessoryViewWithFrame:CGRectMake(296.0, (cellFrame.size.height-20.0)/2, 30.0, 20.0) 
																  andImage:@"transparent_arrow.png"];
			accessoryView.tag = UITableViewCellAccessoryArrowTag;
			break;
		case UITableViewCellAccessoryCheckmark:
			accessoryView = [AccessoryViewWithImage accessoryViewWithFrame:CGRectMake(296.0, (cellFrame.size.height-20.0)/2, 30.0, 20.0) 
																  andImage:@"transparent_checkmark.png"];
			break;
		default:
			accessoryView = nil;
			break;
	}
	cell.accessoryView = accessoryView;
	
	return cell;
}

- (void)setTitle:(NSString *)aValue
{
	[(TransparentCellView *)[self viewWithTag:TRANSPARENT_CELL_VIEW]setTitle:aValue];
}

- (void)setImage:(UIImage *)aValue
{
	[(TransparentCellView *)[self viewWithTag:TRANSPARENT_CELL_VIEW]setImage:aValue];
}

- (void)setShowCheckmark:(BOOL)show
{	
	AccessoryViewWithImage *accessoryView = nil;
	
	if (show && !self.accessoryView) {
		CGRect cellFrame = CGRectMake(0.0, 0.0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
		accessoryView = [AccessoryViewWithImage accessoryViewWithFrame:CGRectMake(296.0, (cellFrame.size.height-20.0)/2, 30.0, 20.0) 
															  andImage:@"transparent_checkmark.png"];
	} else if (self.accessoryView) {
		if (self.accessoryView.tag == UITableViewCellAccessoryArrowTag) {
			accessoryView = (id)self.accessoryView;
		} else {
			accessoryView = nil;
		}
	} else {
		accessoryView = nil;
	}
	self.accessoryView = accessoryView;
}

- (void)prepareForReuse
{
	[super prepareForReuse];
	
	[(TransparentCellView *)[self viewWithTag:TRANSPARENT_CELL_VIEW]removeFromSuperview];
	
	CGRect cellFrame = CGRectMake(0.0, 0.0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
	TransparentCellView *cellView = [TransparentCellView viewWithFrame:cellFrame selected:FALSE];
	cellView.tag = TRANSPARENT_CELL_VIEW;
	[self addSubview:cellView];
	
//	NSString *imageName = @"";
//	NSString *selectedImageName = @"";
//	
//	if ([self.reuseIdentifier isEqual:TopTransparentCell]) {
//		imageName = @"top_transparent_cell_background.png";
//		selectedImageName = @"top_transparent_cell_background_selected.png";
//	} else if ([self.reuseIdentifier isEqual:MiddleTransparentCell]) {
//		imageName = @"transparent_cell_background.png";
//		selectedImageName = @"transparent_cell_background_selected.png";
//	} else if ([self.reuseIdentifier isEqual:BottomTransparentCell]) {
//		imageName = @"bottom_transparent_cell_background.png";
//		selectedImageName = @"bottom_transparent_cell_background_selected.png";
//	} else if ([self.reuseIdentifier isEqual:UniqueTransparentCell]) {
//		imageName = @"unique_transparent_cell_background.png";
//		selectedImageName = @"unique_transparent_cell_background_selected.png";
//	}
//	
//	CellBackgroundWithImage *backgroundView = [CellBackgroundWithImage backgroundViewWithFrame:cellFrame andBackgroundImage:[(ozEstateAppDelegate *)[[UIApplication sharedApplication]delegate] cachedImage:imageName]];
//	self.backgroundView = backgroundView;
			   
	[self setShowCheckmark:FALSE];
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
