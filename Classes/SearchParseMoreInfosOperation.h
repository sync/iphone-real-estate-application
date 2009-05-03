//
//  SearchParseMoreInfosOperation.h
//  ozEstate
//
//  Created by Anthony Mittaz on 28/06/08.
//  Copyright 2008 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#import <UIKit/UIKit.h>
#import "DefaultOperation.h"

@interface SearchParseMoreInfosOperation : DefaultOperation {
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

@property (nonatomic, copy) NSString *houseID;

@end
