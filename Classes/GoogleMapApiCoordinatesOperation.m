//
//  GoogleMapApiCoordinatesOperation.m
//  ozEstate
//
//  Created by Anthony Mittaz on 18/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  
#import "GoogleMapApiCoordinatesOperation.h"
#import "SBJSON.h"

@implementation GoogleMapApiCoordinatesOperation

@synthesize property_id=_property_id;

// By the way the is a reason why this method 
// is not spitted into multiple files
- (void)main
{
	if ([self isCancelled])
	{
		return;	// user cancelled this operation
	}
	
	
//	NSData *responseData = [self downloadUrl];
//	NSMutableDictionary *dictToSend = [NSMutableDictionary dictionaryWithCapacity:0];
//	
//	if ([responseData length] != 0)  {
//		NSString *jsonString = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
//		SBJSON *json = [[SBJSON alloc]init]; 
//		NSDictionary* result = (NSDictionary *)[json objectWithString:jsonString error:nil];
//		
//		NSArray *placemarks = [result valueForKey:@"Placemark"];
//		if (placemarks && [placemarks count] > 0) {
//			NSDictionary *placemark = [placemarks objectAtIndex:0];
//		
//			NSArray *coordinates = [placemark valueForKeyPath:@"Point.coordinates"];
//			if (coordinates && [coordinates count] > 1) {
//				id latitude = [coordinates objectAtIndex:1];
//				id longitude = [coordinates objectAtIndex:0];
//				[dictToSend setValue:latitude forKey:@"latitude"];
//				[dictToSend setValue:longitude forKey:@"longitude"];
//			}
//			
//		}
//		[jsonString release];
//		[json release];
//	}
//	
//	[dictToSend setValue:self.property_id forKey:@"property_id"];
//	[self performSelectorWithDictionary:[NSDictionary dictionaryWithDictionary:dictToSend]];
	
	
}



- (void)dealloc
{
	[_property_id release];
	
	[super dealloc];
}



@end
