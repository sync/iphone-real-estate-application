//
//  GoogleMapApiCoordinatesOperation.h
//  ozEstate
//
//  Created by Anthony Mittaz on 18/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import <Foundation/Foundation.h>
#import "DefaultOperation.h"

@interface GoogleMapApiCoordinatesOperation : DefaultOperation {
	NSNumber *_property_id;
}

@property (nonatomic, retain) NSNumber *property_id;

@end
