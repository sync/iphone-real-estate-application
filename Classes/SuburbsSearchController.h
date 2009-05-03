//
//  SearchController.h
//  ozEstate
//
//  Created by Anthony Mittaz on 6/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SuburbsSearchController : BaseViewController <UITableViewDelegate, UITableViewDelegate, UIScrollViewDelegate, UISearchBarDelegate>{
	UITableView *_tableView;
	UISearchBar *_searchBar;
	NSMutableArray *_content;
	
	NSOperationQueue *_fetchingQueue;
	NSInteger _lastLoadedIndex;
	
	NSString *_selectedSuburbs;
	
	NSNumber *_searchID;
	
	SEL _selectorToUse;
	
	UIButton *_stateButton;
	
	NSString *_currentState;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) NSMutableArray *content;
@property (nonatomic, retain) NSOperationQueue *fetchingQueue;
@property (nonatomic) NSInteger lastLoadedIndex;
@property (nonatomic, retain) NSString *selectedSuburbs;
@property (nonatomic, retain) NSNumber *searchID;
@property (nonatomic) SEL selectorToUse;
@property (nonatomic, retain) IBOutlet UIButton *stateButton;
@property (nonatomic, retain) NSString *currentState;

- (IBAction)findLocation:(id)sender;
- (void)searchLocation:(id)sender;

- (void)reloadTableContent:(id)sender;

- (void)searchDB:(id)sender;
- (void)clearSearch:(id)sender;

- (IBAction)showStateSelection:(id)sender;

- (void)stateChanged:(id)sender;

@end
