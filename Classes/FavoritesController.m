//
//  FavoritesController.m
//  ozEstate
//
//  Created by Anthony Mittaz on 4/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import "FavoritesController.h"
#import "ListingCell.h"
#import "ViewWithImage.h"
#import "PropertyController.h"

@implementation FavoritesController

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

-(BOOL)isFavorite
{
	return TRUE;
}


- (void)viewDidLoad {
	[super viewDidLoad];
}

- (NSString *)suburbNameForSection:(NSInteger)section
{
	NSString *suburb = [self.appDelegate.userdb stringForQuery:[NSString stringWithFormat:@"select distinct(suburb_name) from properties where favorite = ? and state_name = ? order by suburb_name ASC limit 1 offset %d", section], [NSNumber numberWithBool:[self isFavorite]], self.state];
	return suburb;
}

- (NSInteger)initialPositionForPropertyId:(NSNumber *)property_id
{
	FMResultSet *rs = [self.appDelegate.userdb executeQuery:[NSString stringWithFormat:@"select id from properties where favorite = ? order by suburb_name ASC"],  [NSNumber numberWithBool:[self isFavorite]]];
	NSInteger initialPosition = 0;
	NSNumber *tempProperty_id = nil;
	while ([rs next] && [self isFavorite]) {
		tempProperty_id = [NSNumber numberWithInteger:[rs intForColumn:@"id"]];
		if ([tempProperty_id isEqualToNumber:property_id]) {
			break;
		}
		initialPosition++;
	} 
	[rs close];
	
	return initialPosition;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)dealloc {
	
    [super dealloc];
}


@end

