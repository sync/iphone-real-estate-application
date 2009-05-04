//
//  ContactAgentOperation.m
//  ozEstate
//
//  Created by Anthony Mittaz on 14/08/08.
//  Copyright 2008 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
// 

#import "ContactAgentOperation.h"


@implementation ContactAgentOperation

- (void)main
{
	if ([self isCancelled])
	{
		return;	// user cancelled this operation
	}
	
	[self downloadUrl];
	
	[self performSelectorWithDictionary:nil];
}

@end
