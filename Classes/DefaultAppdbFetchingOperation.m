//
//  LoginOperation.m
//  ozEstate
//
//  Created by Anthony Mittaz on 8/08/08.
//  Copyright 2008 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import "DefaultAppdbFetchingOperation.h"
#import <CoreLocation/CoreLocation.h>

@implementation DefaultAppdbFetchingOperation

@synthesize target;
@synthesize action;
@synthesize needRefreshInterface;
@synthesize infoDictionary;
@synthesize queue;
@synthesize appdb=_appdb;
@synthesize userDefaults=_userDefaults;

#pragma mark -
#pragma mark Initialisation:

- (id)initWithTarget:(id)aTarget action:(SEL)anAction needRefreshInterface:(BOOL)aNeedRefreshInterface infoDictionary:(NSDictionary *)anInfoDictionary queue:(NSOperationQueue*)aQueue
{
	self = [super init];
	
	self.target = aTarget;
	self.action = anAction;
	self.needRefreshInterface = aNeedRefreshInterface;
	self.infoDictionary = anInfoDictionary;
	self.queue = aQueue;
	[self loadApprDatabase];
	// User Defaults
	self.userDefaults = [NSUserDefaults standardUserDefaults];
	
    return self;
}

#pragma mark -
#pragma mark This Is Where The Download And Processing Append:

// By the way the is a reason why this method 
// is not spitted into multiple files
- (void)main
{
	if ([self isCancelled])
	{
		return;	// user cancelled this operation
	}
	// do your db work

}

// User database (use this for example to store the favorites user places)
// Returns FALSE upon error
- (BOOL)loadApprDatabase
{
	BOOL error = FALSE;
	
	self.appdb = [FMDatabase databaseWithPath:[self bundlePathForRessource:@"appdatabase" ofType:@"sqlite"]];
	if (![self.appdb open]) {
		error = TRUE;
	}
	[self.appdb setLogsErrors:TRUE];
	
	return error;
}

// Permits to retrive the path for the given file on the application ressources dir
- (NSString *)bundlePathForRessource:(NSString *)aRessource ofType:(NSString *)aType
{
	NSBundle *bundle = [NSBundle mainBundle];
	NSString *path = [bundle pathForResource:aRessource ofType:aType];
	return path;
}

#pragma mark -
#pragma mark If Operation Not Cancelled Send The Resut To The Associated Taarget:

- (void)performSelectorWithDictionary:(NSDictionary *)aDict
{
	if (![self isCancelled])
	{
		// user cancelled this operation
		[target performSelectorOnMainThread:action
								 withObject:aDict
							  waitUntilDone:NO
									  modes:[NSArray arrayWithObject:NSDefaultRunLoopMode]];
		
	}
}

#pragma mark -
#pragma mark Dealloc:

- (void)dealloc
{
	[_appdb release];
	[target release];
	[infoDictionary release];
	[queue release];
	[_userDefaults release];
	
	[super dealloc];
}

@end
