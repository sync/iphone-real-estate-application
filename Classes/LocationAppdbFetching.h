//
//  LocationAppdbFetching.h
//  ozEstate
//
//  Created by Anthony Mittaz on 7/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
// 

#import <Foundation/Foundation.h>
#import "DefaultAppdbFetchingOperation.h"

@interface LocationAppdbFetching : DefaultAppdbFetchingOperation {
	NSInteger _gpsRadius;
	NSInteger _lastLoadedIndex;
}

@property (nonatomic) NSInteger gpsRadius;
@property (nonatomic) NSInteger lastLoadedIndex;

@end
