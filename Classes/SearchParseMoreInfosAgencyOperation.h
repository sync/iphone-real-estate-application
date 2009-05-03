//
//  SearchParseMoreInfosAgencyOperation.h
//  ozEstate
//
//  Created by Anthony Mittaz on 11/08/08.
//  Copyright 2008 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
// 

#import <UIKit/UIKit.h>
#import "DefaultOperation.h"
@interface SearchParseMoreInfosAgencyOperation : DefaultOperation {
	NSString *nexElementName;
	NSString *nextKey;
	NSString *nextBalise;
	NSString *previousBalise;
	BOOL takeText;
	NSString *houseAttributeName;
	NSString *previousHouseAttributeName;
	BOOL shouldGoInside;
	BOOL takeHouseAttributeName;
	NSString *agencyID;
	
	NSMutableDictionary *currentDict;
	
	NSString *elementWhereTakeText;
}


@property (nonatomic, retain) NSString *elementWhereTakeText;

@property (nonatomic, copy) NSString *nextBalise;
@property (nonatomic, copy) NSString *nextKey;
@property (nonatomic, copy) NSString *nexElementName;
@property (nonatomic, copy) NSString *previousBalise;
@property (nonatomic, copy) NSString *houseAttributeName, *previousHouseAttributeName;

@property BOOL takeText, takeHouseAttributeName;
@property BOOL shouldGoInside;

@property (nonatomic, copy) NSString *agencyID;

@end
