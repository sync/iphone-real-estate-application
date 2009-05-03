//
//  DataFetcher.m
//  ozEstate
//
//  Created by Anthony Mittaz on 11/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import "DataFetcher.h"
// Operations
#import "SearchParseOperation.h"
#import "ImageFetchingOperation.h"
#import "SearchParseMoreInfosOperation.h"
#import "SearchParseMoreInfosAgencyOperation.h"
#import "ContactAgentOperation.h"
#import "SearchParseMoreImagesOperation.h"
#import "PropertyLocationSearchOperation.h"
#import "GoogleMapApiCoordinatesOperation.h"
// CellView
#import "ListingCellView.h"

@implementation DataFetcher

@synthesize dataFetcherQueue=_dataFetcherQueue;
@synthesize appDelegate=_appDelegate;
@synthesize databaseFetcherQueue=_databaseFetcherQueue;

- (id)init {
	if (self = [super init]) {
		NSOperationQueue *operationQueue = [[NSOperationQueue alloc]init];
		self.dataFetcherQueue = operationQueue;
		[self.dataFetcherQueue setMaxConcurrentOperationCount:1];
		[operationQueue release];
		
		NSOperationQueue *databaseOperationQueue = [[NSOperationQueue alloc]init];
		self.databaseFetcherQueue = databaseOperationQueue;
		[self.dataFetcherQueue setMaxConcurrentOperationCount:1];
		[databaseOperationQueue release];
		
		self.appDelegate = (ozEstateAppDelegate *)[[UIApplication sharedApplication]delegate];
		[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cancelAllOperations:) name:ShouldCancelAllOperationsDataFetcher object:nil];
	}
	return self;
}

- (void)cancelAllOperations:(id)sender
{
	[self.dataFetcherQueue cancelAllOperations];
	//if (self.dataFetcherQueue) {
//		[_dataFetcherQueue release];
//	}
//	NSOperationQueue *operationQueue = [[NSOperationQueue alloc]init];
//	self.dataFetcherQueue = operationQueue;
//	[self.dataFetcherQueue setMaxConcurrentOperationCount:3];
//	[operationQueue release];
	
	[self showProgressIndicator:FALSE];
}

- (void)showProgressIndicator:(BOOL)showProgressIndicator
{
	if (showProgressIndicator) {
		[[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:TRUE];
		[self.appDelegate addLoadingView];
	} else {
		[[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:FALSE];
		[self.appDelegate removeLoadingView];
	}
}
			
+ (id)dataFetcher
{
	DataFetcher *dataFetcher = [[DataFetcher alloc]init];
	return [dataFetcher autorelease];
}

- (void)launchPropertySearchWithURLString:(NSString *)urlString minBathroomNumber:(NSNumber *)minBathroomNumber maxBathroomNumber:(NSNumber *)maxBathroomNumber minGarageNumber:(NSNumber *)minGarageNumber maxGarageNumber:(NSNumber *)maxGarageNumber andStateName:(NSString *)stateName
{
	if (self.appDelegate.hasValidNetworkConnection) {
		[self showProgressIndicator:TRUE];
		
		SearchParseOperation* operation = [[SearchParseOperation alloc]initWithURL:[NSURL URLWithString:urlString]
																						target:self 
																						action:@selector(addProperty:)
																		  needRefreshInterface:NO
																				infoDictionary:nil];
		operation.minBathroom = minBathroomNumber;
		operation.maxBathroom = maxBathroomNumber;
		operation.minGarage = minGarageNumber;
		operation.maxGarage = maxGarageNumber;
		operation.state = stateName;
		//[operation setQueuePriority:NSOperationQueuePriorityHigh];
		
		[self.dataFetcherQueue addOperation: operation];	// this will start the load operation
		[operation release];
	} else {
		[self.appDelegate alertNoNetworkConnection];
	}
}

- (void)addProperty:(id)sender
{
	if ([[sender valueForKey:@"fetchAndParseSuccessful"]boolValue]) {
		if ([[sender valueForKey:@"houseAdded"]boolValue]) {	
			
			NSString *state = nil;
			
			NSMutableArray *propertiesForCoordinates = [NSMutableArray arrayWithCapacity:0];
			
			// Check for number of recents, if more than 30 clear all
			NSInteger recentsCount = [self.appDelegate.userdb intForQuery:@"select count(id) from properties where favorite = ?", [NSNumber numberWithBool:FALSE]];
			if (recentsCount > 30) {
				[self.appDelegate.userdb executeUpdate:@"delete from images where property_id in (select id from properties where favorite = ?)", [NSNumber numberWithBool:FALSE]];
				[self.appDelegate.userdb executeUpdate:@"delete from properties where favorite = ?", [NSNumber numberWithBool:FALSE]];
			}
			
			for (NSDictionary *property in [sender valueForKey:@"properties"]) {
				NSDictionary *correspondingkeys = [NSDictionary dictionaryWithContentsOfFile:[self.appDelegate bundlePathForRessource:@"realestate_correspondingKeys" ofType:@"dict"]];
				
				// check if row already exist
				
				// Find corresponding key for website_id
				NSArray *array = [correspondingkeys allKeysForObject:@"website_id"];
				NSString *websiteIDCorresp = @"website_id";
				for (NSString *string in array) {
					if ([string hasPrefix:@"house"]) {
						websiteIDCorresp = string;
					}
				}
				
				NSString *website_id = [property valueForKey:websiteIDCorresp];
				NSNumber *property_id = [NSNumber numberWithInteger:[self.appDelegate.userdb intForQuery:@"select id from properties where website_id = ?", website_id]];
				if ([property_id integerValue] == 0) {
					[self.appDelegate.userdb executeUpdate:@"insert into properties (website_id) values (?)", website_id];
					property_id = [NSNumber numberWithInteger:[self.appDelegate.userdb lastInsertRowId]];
					//favorite
					[self.appDelegate.userdb executeUpdate:@"UPDATE properties SET favorite = ? where id = ?", [NSNumber numberWithBool:FALSE], property_id];
				}
				
				
				
				for (NSString *key in property) {
					if (![key isEqual:@"URLImageString"]) {
						[self.appDelegate.userdb executeUpdate:[NSString stringWithFormat:@"UPDATE properties SET %@ = ? where id = ?", [correspondingkeys valueForKey:key]], [property valueForKey:key], property_id];
					} else {
						// check if image exist if not create image and download
						NSNumber *image_id = [NSNumber numberWithInteger:[self.appDelegate.userdb intForQuery:@"select id from images where url = ?", [property valueForKey:key]]];
						if ([image_id integerValue] == 0) {
							[self.appDelegate.userdb executeUpdate:@"insert into images (url,property_id,preview) values (?,?,?)", [property valueForKey:key], property_id, [NSNumber numberWithBool:TRUE]];
							image_id = [NSNumber numberWithInteger:[self.appDelegate.userdb lastInsertRowId]];
						}
					}
				}
				
				// add created_at
				[self.appDelegate.userdb executeUpdate:[NSString stringWithFormat:@"UPDATE properties SET created_at = ? where id = ?"], [NSDate date], property_id];
				
				state = [property valueForKey:@"state"];
				
				NSMutableDictionary *aDict = [NSMutableDictionary dictionaryWithCapacity:0];
				[aDict setValue:property_id forKey:@"property_id"];
				[aDict setValue:[property valueForKey:@"street"] forKey:@"street_name"];
				[aDict setValue:[property valueForKey:@"suburb"] forKey:@"suburb_name"];
				[aDict setValue:[property valueForKey:@"state"] forKey:@"state_name"];
				[propertiesForCoordinates addObject:aDict];
			}
				
			 // add coordinates
			[self addCoordinatesToProperties:propertiesForCoordinates];
			
			[[NSNotificationCenter defaultCenter] postNotificationName:ShouldReloadRecentsStatesController object:nil];
			[[NSNotificationCenter defaultCenter]postNotificationName:ShouldReloadPropertiesTableView object:nil];
			
			[self.appDelegate selectTabBarIndex:2 andPushControllerWithTitle:state];
		}
	}
	
	[self showProgressIndicator:FALSE];
	
	if ([[sender valueForKey:@"canGoNext"]boolValue]) {
		// Show info panel
		[self.appDelegate addSearchCanGoNext:self];
	}
}

- (void)addCoordinatesToProperties:(NSArray *)properties
{	
	PropertyLocationSearchOperation *operation = [[PropertyLocationSearchOperation alloc]initWithTarget:self
																			 action:@selector(updateCoordinatesToProperty:) 
															   needRefreshInterface:TRUE 
																	 infoDictionary:nil
																			  queue:self.databaseFetcherQueue];
	operation.properties = properties;
	
	[self.databaseFetcherQueue addOperation:operation];
	[operation release];
}

- (void)addCoordinatesFromGoogleMapApiToProperties:(NSDictionary *)property
{	
	NSString *street = [property valueForKey:@"street_name"];
	NSString *suburb = [property valueForKey:@"suburb_name"];
	NSString *state = [property valueForKey:@"state_name"];
	
	if (!street || [street length] == 0) {
		street = @"";
	} else {
		street = [street capitalizedString];
	}
	if (!suburb || [suburb length] == 0) {
		suburb = @"";
	} else {
		suburb = [suburb capitalizedString];
	}
	
	if (!state || [state length] == 0) {
		state = @"";
	} else {
		state = [state capitalizedString];
	}
	
	if (state && suburb) {
		NSString *urlString = [self urlEncodeValue:[NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@,%@,%@&output=json&key=ABQIAAAA4yFxsxoDDepDo3ro17yA1hTjOjqphGs0Y9m3nFH3QZboM8-tuxRd5uNAoXEI-bEFHhLbT33JcyYACA", street, suburb, state]];
		
		GoogleMapApiCoordinatesOperation *operation = [[GoogleMapApiCoordinatesOperation alloc]initWithURL:[NSURL URLWithString:urlString] 
																									target:self 
																									action:@selector(updateCoordinatesToProperty:) 
																					  needRefreshInterface:TRUE 
																							infoDictionary:nil];
		operation.property_id = [property valueForKey:@"property_id"];
		
		[self.databaseFetcherQueue addOperation:operation];
		[operation release];
		
	}	
}

- (NSString *)urlEncodeValue:(NSString *)string
{
	CFStringRef originalURLString = (CFStringRef)string;
	CFStringRef preprocessedString = CFURLCreateStringByAddingPercentEscapes(NULL, originalURLString, NULL, (CFStringRef)@"", kCFStringEncodingUTF8);
	//CFStringRef urlString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, preprocessedString, NULL, (CFStringRef)@";/?:@&=+$", kCFStringEncodingUTF8);
	NSString *stringToReturn = [NSString stringWithString:(NSString *)preprocessedString];
	CFRelease(preprocessedString);
	return stringToReturn;
}

- (void)updateCoordinatesToProperty:(id)sender
{
	NSNumber *property_id = [sender valueForKey:@"property_id"];
	if (property_id) {
		for (NSString *key in sender) {
			if (![key isEqual:@"property_id"]) {
				[self.appDelegate.userdb executeUpdate:[NSString stringWithFormat:@"UPDATE properties SET %@ = ? where id = ?", key], [sender valueForKey:key], property_id];
			}
		}
		[[NSNotificationCenter defaultCenter] postNotificationName:ShouldReloadPropertiesTableView object:nil];
		[[NSNotificationCenter defaultCenter] postNotificationName:ShouldReloadPropertyForPropertyId object:[sender valueForKey:@"rowId"]];
	}
}

- (void)downloadImageForRowName:(NSString *)rowName withId:(NSNumber *)rowId atURL:(NSString *)urlString forCellView:(ListingCellView *)cellView
{
	if (self.appDelegate.hasValidNetworkConnection) {
		[[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:TRUE];
		ImageFetchingOperation *operation = [[ImageFetchingOperation alloc] initWithURL:[NSURL URLWithString:urlString] 
																				 target:self 
																				 action:@selector(updateImage:) 
																   needRefreshInterface:TRUE 
																		 infoDictionary:nil];
		operation.rowId = rowId;
		operation.rowName = rowName;
		operation.wantedSize= CGSizeMake(71.0,61.0);
		operation.cellView = cellView;
		
		[self.dataFetcherQueue addOperation:operation];
		[operation release];
	} else {
		//[self.appDelegate alertNoNetworkConnection];
	}
}

- (void)updateImage:(id)sender
{
	if ([[sender valueForKey:@"fetchAndParseSuccessful"]boolValue]) {
		NSData *responseData = 	[sender valueForKey:@"image"];
		UIImage *thumbnail = [UIImage imageWithData:responseData];
		if (thumbnail && !CGSizeEqualToSize(thumbnail.size,CGSizeZero)) {
			thumbnail = [thumbnail _imageScaledToSize:CGSizeMake(71.0,61.0) interpolationQuality:0.5];
			responseData =  UIImageJPEGRepresentation(thumbnail, 0.5);
		}
		[self.appDelegate.userdb executeUpdate:[NSString stringWithFormat:@"UPDATE images SET %@ = ? where id = ?", [sender valueForKey:@"rowName"]], responseData, [sender valueForKey:@"rowId"]];
		id cellView = [sender valueForKey:@"cellView"];
		if (cellView) {
			[cellView setPropertyImage:[UIImage imageWithData:responseData]];
			[cellView setNeedsDisplay];
		}
//		[[NSNotificationCenter defaultCenter] postNotificationName:ShouldReloadPropertiesTableView object:nil];

		[[NSNotificationCenter defaultCenter] postNotificationName:ShouldReloadPropertyForPropertyId object:[sender valueForKey:@"rowId"]];
	}
	
	[[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:FALSE];
}

- (void)getPropertyMoreInfosWithPropertyId:(NSString *)propertyId
{
	if (self.appDelegate.hasValidNetworkConnection) {
		[self showProgressIndicator:TRUE];
		NSString *urlMoreInfosSearchString = [NSString stringWithFormat:@"http://www.realestate.com.au/cgi-bin/rsearch?a=o&id=%@", propertyId];
		SearchParseMoreInfosOperation* operation = [[SearchParseMoreInfosOperation alloc]initWithURL:[NSURL URLWithString:urlMoreInfosSearchString]
																												   target:self
																												   action:@selector(updateProperty:)
																									 needRefreshInterface:NO
																										   infoDictionary:nil];
		operation.houseID = propertyId;
		//[operation setQueuePriority:NSOperationQueuePriorityNormal];
		[self.dataFetcherQueue addOperation:operation];	// this will start the load operation
		[operation release];
	} else {
		[self.appDelegate alertNoNetworkConnection];
	}
}

- (void)updateProperty:(id)sender
{
	if ([[sender valueForKey:@"fetchAndParseSuccessful"]boolValue]) {
		NSDictionary *property = sender;
				
		NSDictionary *correspondingkeys = [NSDictionary dictionaryWithContentsOfFile:[self.appDelegate bundlePathForRessource:@"realestate_correspondingKeys" ofType:@"dict"]];
		
		// check if row already exist
		
		// Find corresponding key for website_id
		NSArray *array = [correspondingkeys allKeysForObject:@"website_id"];
		NSString *websiteIDCorresp = @"website_id";
		for (NSString *string in array) {
			if ([string hasPrefix:@"house"]) {
				websiteIDCorresp = string;
			}
		}
		
		NSString *website_id = [property valueForKey:websiteIDCorresp];
		NSNumber *property_id = [NSNumber numberWithInteger:[self.appDelegate.userdb intForQuery:@"select id from properties where website_id = ?", website_id]];
		if ([property_id integerValue] != 0) {
			for (NSString *key in property) {
				if ([key isEqual:@"URLBigImageString"]) {
					// check if image exist if not create image
					//NSNumber *image_id = [NSNumber numberWithInteger:[self.appDelegate.userdb intForQuery:@"select id from images where url = ?", [property valueForKey:key]]];
	//				if ([image_id integerValue] == 0) {
	//					[self.appDelegate.userdb executeUpdate:@"insert into images (url,property_id,preview) values (?,?,?)", [property valueForKey:key], property_id, [NSNumber numberWithBool:FALSE]];
	//					image_id = [NSNumber numberWithInteger:[self.appDelegate.userdb lastInsertRowId]];
	//				}
				} else if ([key isEqual:@"agencyID"]) {
					// check if agency_id exist if not create agency
					NSNumber *agency_id = [NSNumber numberWithInteger:[self.appDelegate.userdb intForQuery:@"select id from agencies where website_id = ?", [property valueForKey:key]]];
					if ([agency_id integerValue] == 0) {
						[self.appDelegate.userdb executeUpdate:@"insert into agencies (website_id,created_at) values (?,?)", [property valueForKey:key], [NSDate date]];
						agency_id = [NSNumber numberWithInteger:[self.appDelegate.userdb lastInsertRowId]];
					}
					if ([property valueForKey:@"agencyName"]) {
						[self.appDelegate.userdb executeUpdate:[NSString stringWithFormat:@"UPDATE agencies SET name = ? where id = ?"], [property valueForKey:@"agencyName"], agency_id];
						
					}
					[self.appDelegate.userdb executeUpdate:[NSString stringWithFormat:@"UPDATE properties SET agency_id = ? where id = ?"], agency_id, property_id];
				} else if ([key isEqual:@"agencyName"]) {
					// do nothing
				} else if ([key isEqual:@"fetchAndParseSuccessful"]) {
					// do nothing
				} else {
					[self.appDelegate.userdb executeUpdate:[NSString stringWithFormat:@"UPDATE properties SET %@ = ? where id = ?", [correspondingkeys valueForKey:key]], [property valueForKey:key], property_id];
				}
			}
			
			// add updated_at
			[self.appDelegate.userdb executeUpdate:[NSString stringWithFormat:@"UPDATE properties SET updated_at = ? where id = ?"], [NSDate date], property_id];
			
			
			[[NSNotificationCenter defaultCenter]postNotificationName:ShouldReloadMoreInfosTableView object:nil];
			[[NSNotificationCenter defaultCenter]postNotificationName:ShouldReloadAgencyTableView object:nil];
		}
	}

	
	[self showProgressIndicator:FALSE];
}

- (void)getAgencyMoreInfosWithAgencyId:(NSString *)agencyId andPropertyWebsiteId:(NSString *)websiteId
{
	[self showProgressIndicator:TRUE];
	NSString *urlMoreInfosSearchString = nil;
	if (__IS_FOR_SALE__) {
		urlMoreInfosSearchString = [NSString stringWithFormat:@"http://www.realestate.com.au/cgi-bin/rsearch?a=ae&id=%@&t=res&AgentID=%@", websiteId,agencyId];
	} else {
		urlMoreInfosSearchString = [NSString stringWithFormat:@"http://www.realestate.com.au/cgi-bin/rsearch?a=ae&id=%@&t=ren&AgentID=%@", websiteId,agencyId];
		
	}
	SearchParseMoreInfosAgencyOperation* operation = [[SearchParseMoreInfosAgencyOperation alloc]initWithURL:[NSURL URLWithString:urlMoreInfosSearchString]
																																 target:self
																																 action:@selector(updateAgency:)
																												   needRefreshInterface:NO
																														 infoDictionary:nil];
	operation.agencyID = agencyId;
	//[operation setQueuePriority:NSOperationQueuePriorityNormal];
	[self.dataFetcherQueue addOperation: operation];	// this will start the load operation
	[operation release];
}

- (void)updateAgency:(id)sender
{
	if ([[sender valueForKey:@"fetchAndParseSuccessful"]boolValue]) {
		NSDictionary *agency = sender;
		
		NSDictionary *correspondingkeys = [NSDictionary dictionaryWithContentsOfFile:[self.appDelegate bundlePathForRessource:@"realestate_correspondingKeys" ofType:@"dict"]];
		
		// check if row already exist
		
		// Find corresponding key for website_id
		NSArray *array = [correspondingkeys allKeysForObject:@"website_id"];
		NSString *websiteIDCorresp = @"website_id";
		for (NSString *string in array) {
			if ([string hasPrefix:@"agency"]) {
				websiteIDCorresp = string;
			}
		}
		
		NSString *website_id = [agency valueForKey:websiteIDCorresp];
		NSNumber *agency_id = [NSNumber numberWithInteger:[self.appDelegate.userdb intForQuery:@"select id from agencies where website_id = ?", website_id]];
		if ([agency_id integerValue] != 0) {
			for (NSString *key in agency) {
				if (![key isEqual:@"fetchAndParseSuccessful"]) {
					// do nothing
					[self.appDelegate.userdb executeUpdate:[NSString stringWithFormat:@"UPDATE agencies SET %@ = ? where id = ?", [correspondingkeys valueForKey:key]], [agency valueForKey:key], agency_id];
				}
			}
			
			// add updated_at
			[self.appDelegate.userdb executeUpdate:[NSString stringWithFormat:@"UPDATE agencies SET updated_at = ? where id = ?"], [NSDate date], agency_id];
			
			[[NSNotificationCenter defaultCenter]postNotificationName:ShouldReloadAgencyTableView object:nil];
		}
	}
	
	
	[self showProgressIndicator:FALSE];
}

- (void)sendMessageInfosRequestWithPropertyId:(NSNumber *)property_id andComment:(NSString *)comment
{
	if (self.appDelegate.hasValidNetworkConnection) {
		NSString *name = [self.appDelegate.userDefaults stringForKey:UserFullName];
		NSString *phone = [self.appDelegate.userDefaults stringForKey:UserEmail];
		NSString *email = [self.appDelegate.userDefaults stringForKey:UserPhone];
		
		BOOL shouldShowError = FALSE;
		if (!name || [name length] == 0) {
			shouldShowError = TRUE;
			name = @"";
		}
		
		if (!phone || [phone length] == 0) {
			shouldShowError = TRUE;
			phone = @"";
		}
		
		if (!email || [email length] == 0) {
			shouldShowError = TRUE;
			email = @"";
		}
		
		if (shouldShowError) {
			[self.appDelegate showInformativeMenuUsers:self];
		} else {	
			[self showProgressIndicator:TRUE];
			NSString *urlSearchString = nil;
			if (__IS_FOR_SALE__) {
				urlSearchString = @"http://www.realestate.com.au/cgi-bin/rsearch?Name=&Email=&Phone=&Comments=&a=aes&arp=1&t=res&s=&AgentID=&submit=Send+Email";
			} else {
				urlSearchString = @"http://www.realestate.com.au/cgi-bin/rsearch?Name=&Email=&Phone=&Comments=&a=aes&arp=1&t=ren&s=&AgentID=&submit=Send+Email";
			}
			
			urlSearchString =  [urlSearchString stringByReplacingOccurrencesOfString:@"Name=" withString:[NSString stringWithFormat:@"Name=%@", name]];
			urlSearchString =  [urlSearchString stringByReplacingOccurrencesOfString:@"&Email=" withString:[NSString stringWithFormat:@"&Email=%@", email]];
			urlSearchString =  [urlSearchString stringByReplacingOccurrencesOfString:@"&Phone=" withString:[NSString stringWithFormat:@"&Phone=%@", phone]];
			urlSearchString =  [urlSearchString stringByReplacingOccurrencesOfString:@"&Comments=" withString:[NSString stringWithFormat:@"&Comments=%@", comment]];
			
			FMResultSet *rs = [self.appDelegate.userdb executeQuery:[NSString stringWithFormat:@"select properties.state_name,agencies.website_id from properties,agencies where properties.id = ? and agencies.id=properties.agency_id"], property_id];
			NSString *website_id = @"";
			NSString *state_name = @"";
			if ([rs next]) {
				website_id = [rs stringForColumn:@"website_id"];
				state_name = [rs stringForColumn:@"state_name"];
			}
			[rs close];
			
			
			urlSearchString =  [urlSearchString stringByReplacingOccurrencesOfString:@"&AgentID=" withString:[NSString stringWithFormat:@"&AgentID=%@", website_id]];
			urlSearchString =  [urlSearchString stringByReplacingOccurrencesOfString:@"&s=" withString:[NSString stringWithFormat:@"&s=%@", state_name]];
			
			
			urlSearchString = [self urlEncodeValue:urlSearchString];
			
			ContactAgentOperation* opeation = [[ContactAgentOperation alloc]initWithURL:[NSURL URLWithString:urlSearchString]
																							   target:self 
																							   action:@selector(updateMessageInfosRequest:)
																				 needRefreshInterface:NO
																					   infoDictionary:nil];
			//[opeation setQueuePriority:8];
			[self.dataFetcherQueue addOperation: opeation];	// this will start the load operation
			[opeation release];
		}
	} else {
		[self.appDelegate alertNoNetworkConnection];
	}
}

- (void)updateMessageInfosRequest:(id)sender
{
	[self showProgressIndicator:FALSE];
}

- (void)getHouseMoreImagesWithLetter:(NSString *)aLetter forWebsiteId:(NSString *)websiteId main:(BOOL)isMain
{
	if (self.appDelegate.hasValidNetworkConnection) {
		[[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:TRUE];
		NSString *urlMoreImagesSearchString = [NSString stringWithFormat:@"http://www.realestate.com.au/cgi-bin/rsearch?a=depi&id=%@&img=%@", websiteId, aLetter];
		SearchParseMoreImagesOperation* operation = [[SearchParseMoreImagesOperation alloc]initWithURL:[NSURL URLWithString:urlMoreImagesSearchString]
																													  target:self
																													  action:@selector(addHouseMoreImages:)
																										needRefreshInterface:NO
																											  infoDictionary:nil];
		operation.houseID = websiteId;
		operation.currentLetter = aLetter;
		operation.isMain = isMain;
		operation.wantedSize = CGSizeMake(268.0, 227.0);
		//[operation setQueuePriority:NSOperationQueuePriorityNormal];
		[self.dataFetcherQueue addOperation: operation];	// this will start the load operation
		[operation release];
	} else {
		[self.appDelegate alertNoNetworkConnection];
	}
}

- (void)addHouseMoreImages:(id)sender
{
	if ([[sender valueForKey:@"fetchAndParseSuccessful"]boolValue]) {
		NSDictionary *image = sender;
		
		NSDictionary *correspondingkeys = [NSDictionary dictionaryWithContentsOfFile:[self.appDelegate bundlePathForRessource:@"realestate_correspondingKeys" ofType:@"dict"]];
		
		// check if row already exist
		
		// Find corresponding key for website_id
		NSArray *array = [correspondingkeys allKeysForObject:@"website_id"];
		NSString *websiteIDCorresp = @"website_id";
		for (NSString *string in array) {
			if ([string hasPrefix:@"house"]) {
				websiteIDCorresp = string;
			}
		}
		
		NSString *website_id = [image valueForKey:websiteIDCorresp];
			
		// test if image data is valid
		UIImage *imageData = [UIImage imageWithData:[image valueForKey:@"data"]];
		CGSize imageSize = imageData.size;
		
		BOOL stop = FALSE;
		
		if (CGSizeEqualToSize(imageSize,CGSizeZero)) {
			stop = TRUE;
		}
		
		// Defautl image when no small image
		if (CGSizeEqualToSize(imageSize,CGSizeMake(120.9,90.0))) {
			stop = TRUE;
		}
		
		if (!stop) {
			NSNumber *property_id = [NSNumber numberWithInteger:[self.appDelegate.userdb intForQuery:@"select id from properties where website_id = ?", website_id]];
			NSNumber *image_id = [NSNumber numberWithInteger:[self.appDelegate.userdb intForQuery:@"select id from images where property_id = ? and url = ?", property_id, [image valueForKey:@"url"]]];
			if ([image_id integerValue] == 0) {
				[self.appDelegate.userdb executeUpdate:@"insert into images (property_id) values (?)", property_id];
				image_id = [NSNumber numberWithInteger:[self.appDelegate.userdb lastInsertRowId]];
			} else {
				// Check if data exist
				NSData *data = [self.appDelegate.userdb dataForQuery:@"select data from images where property_id = ?", property_id];
				if (data || [data length] > 0) {
					// possible race condition should close network connection
					[self showProgressIndicator:FALSE];
					[[NSNotificationCenter defaultCenter]postNotificationName:ShouldReloadPhotosView object:nil];
					//return;
				}
			}
			
			for (NSString *key in image) {
				if ([key isEqual:@"url"] || [key isEqual:@"data"] || [key isEqual:@"preview"]) {
					[self.appDelegate.userdb executeUpdate:[NSString stringWithFormat:@"UPDATE images SET %@ = ? where id = ?", [correspondingkeys valueForKey:key]], [image valueForKey:key], image_id];
				}
			}
			
			[[NSNotificationCenter defaultCenter]postNotificationName:ShouldReloadPhotosView object:nil];
			[[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:FALSE];
			
			if ([[image valueForKey:@"isMain"]boolValue] && [[sender valueForKey:@"currentLetter"]isEqual:@"m"]) {
				[self getHouseMoreImagesWithLetter:@"a" forWebsiteId:website_id main:FALSE];
			} else {		
				if ([[sender valueForKey:@"goNextLetter"]boolValue]) {
					NSString *nextLetter = [sender valueForKey:@"nextLetter"];
					if (!nextLetter) {
						unichar letter =  [[sender valueForKey:@"currentLetter"]characterAtIndex:0]+1;
						nextLetter = [NSString stringWithCharacters:&letter length:1];
					}
					
					[self getHouseMoreImagesWithLetter:nextLetter forWebsiteId:website_id main:FALSE];
				}
			}
		} else {
			[[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:FALSE];
			if (image && (![[image valueForKey:@"isMain"]boolValue] || [[sender valueForKey:@"currentLetter"]isEqual:@"m"])) {
				[self getHouseMoreImagesWithLetter:@"a" forWebsiteId:website_id main:TRUE];
			} else {
				[[NSNotificationCenter defaultCenter]postNotificationName:ShouldReloadPhotosView object:nil];
			}
		}
	} else {
		[[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:FALSE];
	}
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter]removeObserver:self];
	[_databaseFetcherQueue release];
	[_appDelegate release];
	[_dataFetcherQueue release];
	
	[super dealloc];
}

@end
