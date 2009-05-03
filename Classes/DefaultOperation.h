//
//  LoginOperation.h
//  ozEstate
//
//  Created by Anthony Mittaz on 8/08/08.
//  Copyright 2008 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>

@interface DefaultOperation : NSOperation {
	NSURL *url;
	id target;
	SEL action;
	BOOL needRefreshInterface;
	NSDictionary *infoDictionary;
	
	NSString *user;
	NSString *password;
	
	BOOL peformedSelectorOnce;
	
	NSData *bodyData;
	
	NSString *requestMethod;
	NSString *contentType;
	NSString *accept;
	
	NSInteger responseStatusCode;
	
	NSString *_tmpFilePath;
	NSFileHandle *_tmpFileHandle;
}

@property (nonatomic, retain) NSString *tmpFilePath;
@property (nonatomic, retain) NSFileHandle *tmpFileHandle;

@property (retain) NSURL *url;
@property (retain) id target;
@property SEL action;
@property BOOL needRefreshInterface;
@property (retain) NSDictionary *infoDictionary;
@property BOOL peformedSelectorOnce;
@property (nonatomic, copy) NSString *user;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, retain) NSData *bodyData;
@property (nonatomic, copy) NSString *requestMethod;
@property (nonatomic, copy) NSString *contentType;
@property (nonatomic, copy) NSString *accept;
@property NSInteger responseStatusCode;

- (id)initWithURL:(NSURL *)anUrl target:(id)aTarget action:(SEL)anAction needRefreshInterface:(BOOL)aNeedRefreshInterface infoDictionary:(NSDictionary *)anInfoDictionary;
- (void)performSelectorWithDictionary:(NSDictionary *)aDict;

- (NSData *)downloadUrl;
- (NSData *)tidyData:(NSData *)responseData;

- (NSString *)bundlePathForRessource:(NSString *)aRessource ofType:(NSString *)aType;

@end