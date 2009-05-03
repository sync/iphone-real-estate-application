//
//  MyLocationGetter.m
//  ozEstate
//
//  Created by Anthony Mittaz on 29/06/08.
//  Copyright 2008 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import "MyLocationGetter.h"


@implementation MyLocationGetter

@synthesize locationManager;

- (void)startUpdates
{
    // Create the location manager if this object does not
    // already have one.
    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];
	
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
	
    // Set a movement threshold for new events
    locationManager.distanceFilter = 500;
	
    [locationManager startUpdatingLocation];
}


// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
    // If it's a relatively recent event, turn off updates to save power
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 5.0)
    {
        [manager stopUpdatingLocation];
		
       // Log("latitude %+.6f, longitude %+.6f\n",
//			   newLocation.coordinate.latitude,
//			   newLocation.coordinate.longitude);
    }

}
- (void)dealloc {
	[locationManager release];
	
	[super dealloc];
}

@end
