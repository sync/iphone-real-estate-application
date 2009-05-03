//
//  SpotImageFetchingOperation.h
//  ozEstate
//
//  Created by Anthony Mittaz on 27/09/08.
//  Copyright 2008 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
// 

#import <Foundation/Foundation.h>
#import "DefaultOperation.h"

@interface ImageFetchingOperation : DefaultOperation {
	NSNumber *_rowId;
	NSString *_rowName;
	
	CGSize _wantedSize;
	ListingCellView *_cellView;
}

@property (nonatomic, copy) NSNumber *rowId;
@property (nonatomic, copy) NSString *rowName;
@property (nonatomic) CGSize wantedSize;
@property (nonatomic, retain) ListingCellView *cellView;

@end
