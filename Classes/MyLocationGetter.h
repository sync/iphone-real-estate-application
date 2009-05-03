//
//  MyLocationGetter.h
//  ozEstate
//
//  Created by Anthony Mittaz on 29/06/08.
//  Copyright 2008 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
// 

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface MyLocationGetter : NSObject <CLLocationManagerDelegate> {
	
	CLLocationManager *locationManager;

}

- (void)startUpdates;

@property (nonatomic, retain) CLLocationManager *locationManager;

@end
