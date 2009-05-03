//
//  DataFetcher.h
//  ozEstate
//
//  Created by Anthony Mittaz on 11/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import <Foundation/Foundation.h>

@class ozEstateAppDelegate;
@class ListingCellView;

@interface DataFetcher : NSObject {
	NSOperationQueue *_dataFetcherQueue;
	NSOperationQueue *_databaseFetcherQueue;
	
	ozEstateAppDelegate *_appDelegate;
}

@property (nonatomic, retain) NSOperationQueue *dataFetcherQueue;
@property (nonatomic, retain) ozEstateAppDelegate *appDelegate;
@property (nonatomic, retain) NSOperationQueue *databaseFetcherQueue;

+ (id)dataFetcher;

// Properties parsing
- (void)launchPropertySearchWithURLString:(NSString *)urlString minBathroomNumber:(NSNumber *)minBathroomNumber maxBathroomNumber:(NSNumber *)maxBathroomNumber minGarageNumber:(NSNumber *)minGarageNumber maxGarageNumber:(NSNumber *)maxGarageNumber andStateName:(NSString *)stateName;
- (void)addProperty:(id)sender;

// Image Downloading
- (void)downloadImageForRowName:(NSString *)rowName withId:(NSNumber *)rowId atURL:(NSString *)urlString forCellView:(ListingCellView *)cellView;
- (void)updateImage:(id)sender;

// Properties more infos
- (void)getPropertyMoreInfosWithPropertyId:(NSString *)property_id;
- (void)updateProperty:(id)sender;

// Agency More Infos
- (void)getAgencyMoreInfosWithAgencyId:(NSString *)agencyId andPropertyWebsiteId:(NSString *)websiteId;
- (void)updateAgency:(id)sender;

// Agency Message More Infos
- (void)sendMessageInfosRequestWithPropertyId:(NSNumber *)property_id andComment:(NSString *)comment;
- (void)updateMessageInfosRequest:(id)sender;

// More Images
- (void)getHouseMoreImagesWithLetter:(NSString *)aLetter forWebsiteId:(NSString *)websiteId main:(BOOL)isMain;
- (void)addHouseMoreImages:(id)sender;

// Progress indicator status bar
- (void)showProgressIndicator:(BOOL)showProgressIndicator;

// URL encoding
- (NSString *)urlEncodeValue:(NSString *)string;

// Property Coordinates
- (void)addCoordinatesToProperties:(NSArray *)properties;
- (void)updateCoordinatesToProperty:(id)sender;

- (void)addCoordinatesFromGoogleMapApiToProperties:(NSDictionary *)property;

@end
