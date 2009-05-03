//
//  SearchController.h
//  ozEstate
//
//  Created by Anthony Mittaz on 7/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class BigPaperView;
@class SmallPaperView;
@class SmallSubtitlePaperView;

@interface SearchController : BaseViewController {
	BigPaperView *_suburbsListView;
	SmallSubtitlePaperView *_propertyTypesView;
	SmallPaperView *_bedroomView;
	SmallPaperView *_garageView;
	SmallPaperView *_bathroomView;
	SmallPaperView *_priceView;
	NSInteger _currentPageNumber;
	
	NSNumber *_searchID;
}

@property (nonatomic, retain) IBOutlet BigPaperView *suburbsListView;
@property (nonatomic, retain) IBOutlet SmallSubtitlePaperView *propertyTypesView;
@property (nonatomic, retain) IBOutlet SmallPaperView *bedroomView;
@property (nonatomic, retain) IBOutlet SmallPaperView *garageView;
@property (nonatomic, retain) IBOutlet SmallPaperView *bathroomView;
@property (nonatomic, retain) IBOutlet SmallPaperView *priceView;
@property (nonatomic) NSInteger currentPageNumber;

@property (nonatomic, retain) NSNumber *searchID;

- (IBAction)editSuburbs:(id)sender;
- (IBAction)editBedroomNumber:(id)sender;
- (IBAction)editBathdroomNumber:(id)sender;
- (IBAction)editGaragemNumber:(id)sender;
- (IBAction)editPrice:(id)sender;
- (IBAction)editPropertyTypes:(id)sender;

- (IBAction)startSearch:(id)sender;
- (NSString *)setupSearchUrlString;
- (void)launchSearchWithUrlString:(NSString *)urlSearchString;
- (void)queryDB;
- (void)clearSearch:(id)sender;

- (NSString *)urlEncodeValue:(NSString *)string;

@end
