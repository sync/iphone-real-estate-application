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

@interface DefaultAppdbFetchingOperation : NSOperation {
	id target;
	SEL action;
	BOOL needRefreshInterface;
	NSDictionary *infoDictionary;
	NSOperationQueue *queue;
	
	FMDatabase *_appdb;
	
	NSUserDefaults *_userDefaults;
}


@property (retain) id target;
@property SEL action;
@property BOOL needRefreshInterface;
@property (retain) NSDictionary *infoDictionary;
@property (retain) NSOperationQueue *queue;
@property (nonatomic, retain) FMDatabase *appdb;
@property (nonatomic, retain) NSUserDefaults *userDefaults;

- (id)initWithTarget:(id)aTarget action:(SEL)anAction needRefreshInterface:(BOOL)aNeedRefreshInterface infoDictionary:(NSDictionary *)anInfoDictionary queue:(NSOperationQueue*)aQueue;
- (void)performSelectorWithDictionary:(NSDictionary *)aDict;

- (BOOL)loadApprDatabase;
- (NSString *)bundlePathForRessource:(NSString *)aRessource ofType:(NSString *)aType;

@end
