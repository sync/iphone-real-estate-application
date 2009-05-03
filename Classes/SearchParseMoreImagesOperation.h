//
//  SearchParseMoreImagesOperation.h
//  ozEstate
//
//  Created by Anthony Mittaz on 13/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import <UIKit/UIKit.h>
#import "DefaultOperation.h"

@interface SearchParseMoreImagesOperation : DefaultOperation {
	NSString *nexElementName;
	NSString *nextKey;
	NSString *nextBalise;
	NSString *previousBalise;
	BOOL takeText;
	NSString *houseAttributeName;
	NSString *previousHouseAttributeName;
	BOOL shouldGoInside;
	NSString *houseID;
	BOOL takeHouseAttributeName;
	
	NSMutableDictionary *currentDict;
	NSString *currentLetter;
	NSMutableArray *URLMoreHouseImages;
	BOOL isMain;
	
	NSInteger retryCount;
	
	CGSize _wantedSize;
}

@property (nonatomic, copy) NSString *nextBalise;
@property (nonatomic, copy) NSString *nextKey;
@property (nonatomic, copy) NSString *nexElementName;
@property (nonatomic, copy) NSString *previousBalise;
@property (nonatomic, copy) NSString *houseAttributeName, *previousHouseAttributeName;

@property BOOL takeText, takeHouseAttributeName;
@property BOOL shouldGoInside;

@property (nonatomic, copy) NSString *houseID, *currentLetter;
@property (nonatomic, copy) NSMutableArray *URLMoreHouseImages;
@property BOOL isMain;

@property (nonatomic) CGSize wantedSize;

- (BOOL)downloadAndParseData;

@end
