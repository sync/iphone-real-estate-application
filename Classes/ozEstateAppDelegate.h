//
//  ozEstateAppDelegate.h
//  ozEstate
//
//  Created by Anthony Mittaz on 4/02/09.
//  Copyright Anthony Mittaz 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
// Geolocation
#import <CoreLocation/CoreLocation.h>
// Data Fetching
#import "DataFetcher.h"
// Remote status
#import "Reachability.h"

@interface UIImage (ResizeExtension)

- (UIImage *)_imageScaledToSize:(CGSize)size interpolationQuality:(CGFloat)quality;

@end

@class MyLocationGetter;
@class LoadingController;

@interface ozEstateAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, UIActionSheetDelegate, UIAlertViewDelegate> {
    UIWindow *_window;
    UITabBarController *_tabBarController;
	
	FMDatabase *_userdb;
	MyLocationGetter *_locationGetter;
	
	LoadingController *_loadingController;
	
	DataFetcher *_dataFetcher;
	
	NSUserDefaults *_userDefaults;
	NSMutableArray *_savedLocation;	
	
	NetworkStatus remoteHostStatus;
	NetworkStatus internetConnectionStatus;
	NetworkStatus localWiFiConnectionStatus;
	
	BOOL _hasValidNetworkConnection;
	BOOL _noConnectionAlertShowing;
	
	NSMutableDictionary *_imagesCache;
	NSMutableDictionary *_bigImagesCache;
}

@property (nonatomic, retain) NSMutableDictionary *imagesCache;
@property (nonatomic, retain) NSMutableDictionary *bigImagesCache;
@property BOOL noConnectionAlertShowing;
@property BOOL hasValidNetworkConnection;

@property NetworkStatus remoteHostStatus;
@property NetworkStatus internetConnectionStatus;
@property NetworkStatus localWiFiConnectionStatus;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@property (nonatomic, retain) FMDatabase *userdb;
@property (nonatomic, retain) MyLocationGetter *locationGetter;

@property (nonatomic, retain) LoadingController *loadingController;

@property (nonatomic, retain) DataFetcher *dataFetcher;

@property (nonatomic, retain) NSUserDefaults *userDefaults;
@property (nonatomic, retain) NSMutableArray *savedLocation;

- (BOOL)loadUserDatabase;

- (NSString *)documentPathForFile:(NSString *)aPath;
- (NSString *)bundlePathForRessource:(NSString *)aRessource ofType:(NSString *)aType;

- (void)addNavigationOverlayInRect:(CGRect)rect;
- (void)removeNavigationBarOverlay;

- (void)addTabBarOverlayInRect:(CGRect)rect;
- (void)removeTabBarOverlay;

- (CLLocation *)currentLocation;

- (void)addLoadingView;
- (void)removeLoadingView;

- (void)selectTabBarIndex:(NSInteger)index andPushControllerWithTitle:(NSString *)title;

- (void)restoreLevelWithSelectionArray:(NSArray *)selectionArray;

- (void)addSearchCanGoNext:(id)sender;
- (void)removeSearchCanGoNext:(id)sender;

- (IBAction)showInformativeMenuUsers:(id)sender;

- (void)updateStatus;
- (BOOL)isCarrierDataNetworkActive;
- (NSString *)hostName;

- (void)alertNoNetworkConnection;

- (UIImage*)cachedImage:(NSString*)imageName;
- (void)removeCache:(id)sender;


@end
