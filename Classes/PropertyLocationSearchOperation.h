//
//  PropertyLocationSearchOperation.h
//  ozEstate
//
//  Created by Anthony Mittaz on 15/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import <Foundation/Foundation.h>
#import "DefaultAppdbFetchingOperation.h"

@interface PropertyLocationSearchOperation : DefaultAppdbFetchingOperation {
	NSArray *_properties;
}

@property (nonatomic, retain) NSArray *properties;

@end
