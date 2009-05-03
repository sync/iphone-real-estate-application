//
//  SearchParseOperation.h
//  ozEstate
//
//  Created by Anthony Mittaz on 18/06/08.
//  Copyright 2008 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
// 

#import <Foundation/Foundation.h>
#import "DefaultOperation.h"

@interface SearchParseOperation : DefaultOperation {
	NSMutableDictionary *currentDict;
	NSString *nexElementName;
	NSString *nextKey;
	NSString *nextBalise;
	NSString *previousBalise;
	BOOL takeText;
	NSString *houseAttributeName;
	BOOL shouldGoInside;
	BOOL houseAdded;
	
	NSInteger numberHousesAdded;
	
	NSNumber *minBathroom;
	NSNumber *maxBathroom;
	NSNumber *minGarage;
	NSNumber *maxGarage;
	
	NSMutableSet *streetAbbreviations;
	
	BOOL canSkipNextElementNameTest;
	
	NSString *ifSkippedHouseAttributeName;
	NSString *ifSkippedElementName;
	NSString *state;
	BOOL canStartParsing;
	BOOL canGoNext;
	
	NSMutableArray *_properties;
	
	NSString *elementWhereTakeText;
}

@property (nonatomic, retain) NSString *elementWhereTakeText;

@property (nonatomic, copy) NSString *nextBalise;
@property (nonatomic, copy) NSString *nextKey;
@property (nonatomic, copy) NSString *nexElementName;
@property (nonatomic, copy) NSString *previousBalise;
@property (nonatomic, copy) NSString *houseAttributeName;

@property BOOL takeText;
@property BOOL shouldGoInside;

@property NSInteger numberHousesAdded;

@property (nonatomic, retain) NSNumber *minBathroom, *maxBathroom;
@property (nonatomic, retain) NSNumber *minGarage, *maxGarage;
@property (nonatomic, retain) NSMutableSet *streetAbbreviations;
- (void)loadAbbreviation;

@property (nonatomic, copy) NSString *ifSkippedHouseAttributeName, *ifSkippedElementName, *state;

@property (nonatomic, retain) NSMutableArray *properties;

@end
