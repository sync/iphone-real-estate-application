//
//  AppDelegate.h
//  AppDatabaseGenerator
//
//  Created by Anthony Mittaz on 7/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import <Cocoa/Cocoa.h>


@interface AppDelegate : NSObject {
	FMDatabase *_userdb;
}

@property (nonatomic, retain) FMDatabase *userdb;

- (BOOL)loadUserDatabase:(id)sender;
- (BOOL)loadUserDatabaseForState:(NSString *)stateName;
- (void)fillDatabaseByIncludingAustralianList:(BOOL)includeList forState:(NSString *)stateName andSuburbs:(NSString *)suburbs;

- (NSString *)documentPathForFile:(NSString *)aPath;
- (NSString *)applicationSupportPathForFile:(NSString *)aPath;
- (NSString *)bundlePathForRessource:(NSString *)aRessource ofType:(NSString *)aType;

- (NSString *)urlEncodeValue:(NSString *)string;



@end
