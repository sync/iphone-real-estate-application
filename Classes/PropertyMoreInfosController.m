//
//  PropertyMoreInfosController.m
//  ozEstate
//
//  Created by Anthony Mittaz on 8/02/09.
//  Copyright 2009 Anthony Mittaz. All rights reserved.
//
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  

#import "PropertyMoreInfosController.h"
#import "ResizableViewWithText.h"

#define titleView 5000
#define descriptionView 5001
#define availabilityTitleView 5002
#define availabilityView 5003
#define property_typeTitleView 5004
#define property_typeView 5005
#define bondTitleView 5006
#define bondView 5007
#define inspectionsTitleView 5008
#define inspectionsView 5009
#define copyrightTitleView 5010
#define copyrightView 5011
#define energy_efficiency_ratingTitleView 5012
#define energy_efficiency_ratingView 5013
#define landTitleView 5014
#define landView 5015
#define municipalityTitleView 5016
#define municipalityView 5017
#define close_toTitleView 5018
#define close_toView 5019
#define featuresTitleView 5020
#define featuresView 5021
#define buildingTitleView 5022
#define buildingView 5023

@implementation PropertyMoreInfosController

@synthesize resizableView=_resizableView;
@synthesize property_id=_property_id;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"More Infos";
	
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadTableView:) name:ShouldReloadMoreInfosTableView object:nil];
	
	[self fetchDb];
}

- (void)reloadTableView:(id)sender
{
	[self fetchDb];
}

- (void)fetchDb
{
	FMResultSet *rs = [self.appDelegate.userdb executeQuery:[NSString stringWithFormat:@"select building,energy_efficiency_rating,land,municipality,close_to,features,updated_at,website_id,description,title,availability,bond,property_type,copyright,inspections from properties where id =  ?"],  self.property_id];
	NSDate *updated_at = nil;
	NSString *description = nil;
	NSString *title = nil;
	NSDate *availability = nil;
	NSString *availabilityString = nil;
	NSString *bond = nil;
	NSString *property_type = nil;
	NSString *copyright = nil;
	NSString *inspections = nil;
	NSString *website_id = nil;
	NSString *energy_efficiency_rating = nil;
	NSString *land = nil;
	NSString *municipality = nil;
	NSString *close_to = nil;
	NSString *features = nil;
	NSString *building = nil;
	if ([rs next]) {
		updated_at = [rs dateForColumn:@"updated_at"];
		description = [rs stringForColumn:@"description"];
		title = [rs stringForColumn:@"title"];
		availability = [rs dateForColumn:@"availability"];
		availabilityString = [rs stringForColumn:@"availability"];
		bond = [rs stringForColumn:@"bond"];
		property_type = [rs stringForColumn:@"property_type"];
		copyright = [rs stringForColumn:@"copyright"];
		inspections = [rs stringForColumn:@"inspections"];
		website_id = [rs stringForColumn:@"website_id"];
		energy_efficiency_rating = [rs stringForColumn:@"energy_efficiency_rating"];
		land = [rs stringForColumn:@"land"];
		municipality = [rs stringForColumn:@"municipality"];
		close_to = [rs stringForColumn:@"close_to"];
		features = [rs stringForColumn:@"features"];
		building = [rs stringForColumn:@"building"];
	}
	[rs close];
	
	
	// Updated_at
	NSTimeInterval timeDiff = 60*60*24+100;
	if (updated_at) {
		timeDiff = [[NSDate date] timeIntervalSinceDate:updated_at];
	}
	
	if (timeDiff > 60*60*24) {
		if (website_id) {
			[self.appDelegate.dataFetcher getPropertyMoreInfosWithPropertyId:website_id];
		}
	}
	// Title
	if (!title || [title length] == 0) {
		title = @"A great property";
	} else {
		title = [NSString stringWithFormat:@"%@", title];
	}
	// Description
	if (!description || [description length] == 0) {
		description = @"n/a\n\n";
	} else {
		description = [NSString stringWithFormat:@"%@\n\n", description];
	}
	// Availabitlity
	if (!availabilityString || [availabilityString length] == 0) {
		availabilityString = @"Now\n\n";
	} else {
		// check if availability is before today
		
		NSTimeInterval timeInterval = [availability timeIntervalSinceNow];
		if (timeInterval > 0) {
			NSDateFormatter *formater = [[NSDateFormatter alloc]init];
			[formater setDateStyle:NSDateFormatterFullStyle];
			[formater setTimeStyle:NSDateFormatterNoStyle];
			availabilityString =[formater stringFromDate:availability];
			[formater release];
			availabilityString = [NSString stringWithFormat:@"%@\n\n", availabilityString];
		} else {
			availabilityString = @"Now\n\n";
		}
		
	}
	// Bond
	if (!bond || [bond length] == 0) {
		bond = @"n/a\n\n";
	} else {
		CFLocaleRef currentLocale = CFLocaleCopyCurrent();
		CFNumberFormatterRef customCurrencyFormatter = CFNumberFormatterCreate
		(NULL, currentLocale, kCFNumberFormatterCurrencyStyle);
		CFNumberFormatterSetFormat(customCurrencyFormatter, CFSTR("#,##0;n/a;($#,##0)"));
		
		CGFloat floatNumer = [bond floatValue];
		CFNumberRef number = CFNumberCreate(NULL, kCFNumberFloatType, &floatNumer);
		
		CFStringRef formattedStringNumber = CFNumberFormatterCreateStringWithNumber(NULL, customCurrencyFormatter, number);
		
		NSString *stringWithFormat = [NSString stringWithString:(NSString *)formattedStringNumber];
		
		// Memory management
		CFRelease(currentLocale);
		CFRelease(customCurrencyFormatter);
		CFRelease(number);
		CFRelease(formattedStringNumber);
		
		bond = [NSString stringWithFormat:@"%@\n\n", stringWithFormat];
	}
	// Property_type
	if (!property_type || [property_type length] == 0) {
		property_type = @"n/a\n\n";
	} else {
		property_type = [NSString stringWithFormat:@"%@\n\n", property_type];
	}
	// Inspections
	if (!inspections || [inspections length] == 0) {
		inspections = @"n/a\n\n";
	} else {
		inspections = [NSString stringWithFormat:@"%@\n\n", inspections];
	}
	// Energy Efficiency Rating
	if (!energy_efficiency_rating || [energy_efficiency_rating length] == 0) {
		energy_efficiency_rating = @"n/a\n\n";
	} else {
		energy_efficiency_rating = [NSString stringWithFormat:@"%@\n\n", energy_efficiency_rating];
	}
	// Land
	if (!land || [land length] == 0) {
		land = @"n/a\n\n";
	} else {
		land = [NSString stringWithFormat:@"%@\n\n", land];
	}
	// Municipality
	if (!municipality || [municipality length] == 0) {
		municipality = @"n/a\n\n";
	} else {
		municipality = [NSString stringWithFormat:@"%@\n\n", municipality];
	}
	// Close to
	if (!close_to || [close_to length] == 0) {
		close_to = @"n/a\n\n";
	} else {
		close_to = [NSString stringWithFormat:@"%@\n\n", close_to];
	}
	// Features
	if (!features || [features length] == 0) {
		features = @"n/a\n\n";
	} else {
		features = [NSString stringWithFormat:@"%@\n\n", features];
	}
	// Building
	if (!building || [building length] == 0) {
		building = @"n/a\n\n";
	} else {
		building = [NSString stringWithFormat:@"%@\n\n", features];
	}
	// Copyright
	if (!copyright || [copyright length] == 0) {
		copyright = @"n/a\n\n";
	} else {
		copyright = [NSString stringWithFormat:@"%@", copyright];
	}
	
	UIFont *normalFont = [UIFont fontWithName:@"Courier" size:13.0];
	UIFont *boldFont = [UIFont fontWithName:@"Courier-Bold" size:13.0];
	
	if (title) {
		// add som view with text
		ResizableViewWithText *aView = (ResizableViewWithText *)[self.resizableView viewWithTag:titleView];
		if (!aView) {
			aView = [[ResizableViewWithText alloc]initWithFrame:CGRectZero];
			aView.tag = titleView;
			[self.resizableView addSubview:aView];
			[aView release];
		}
		aView.font = boldFont;
		aView.text = title;
		[aView setNeedsLayout];
		[aView setNeedsDisplay];
	} else {
		[[self.resizableView viewWithTag:titleView]removeFromSuperview];
	}
	
	
	if (description) {
		// add som view with text
		ResizableViewWithText *aView = (ResizableViewWithText *)[self.resizableView viewWithTag:descriptionView];
		if (!aView) {
			aView = [[ResizableViewWithText alloc]initWithFrame:CGRectZero];
			aView.tag = descriptionView;
			[self.resizableView addSubview:aView];
			[aView release];
		}
		aView.font = normalFont;
		aView.text = description;
		[aView setNeedsLayout];
		[aView setNeedsDisplay];
	} else {
		[[self.resizableView viewWithTag:descriptionView]removeFromSuperview];
	}
	
	if (availability) {
		// add som view with text
		NSString *testText = @"Availability";
		ResizableViewWithText *aView = (ResizableViewWithText *)[self.resizableView viewWithTag:availabilityTitleView];
		if (!aView) {
			aView = [[ResizableViewWithText alloc]initWithFrame:CGRectZero];
			aView.tag = availabilityTitleView;
			[self.resizableView addSubview:aView];
			[aView release];
		}
		aView.font = boldFont;
		aView.text = testText;
		[aView setNeedsLayout];
		[aView setNeedsDisplay];
	} else {
		[[self.resizableView viewWithTag:availabilityTitleView]removeFromSuperview];
	}
	
	
	if (availability) {
		// add som view with text
		ResizableViewWithText *aView = (ResizableViewWithText *)[self.resizableView viewWithTag:availabilityView];
		if (!aView) {
			aView = [[ResizableViewWithText alloc]initWithFrame:CGRectZero];
			aView.tag = availabilityView;
			[self.resizableView addSubview:aView];
			[aView release];
		}
		aView.font = normalFont;
		aView.text = availabilityString;
		[aView setNeedsLayout];
		[aView setNeedsDisplay];
	} else {
		[[self.resizableView viewWithTag:availabilityView]removeFromSuperview];
	}
	
	if (property_type) {
		// add som view with text
		NSString *testText = @"Property Type";
		ResizableViewWithText *aView = (ResizableViewWithText *)[self.resizableView viewWithTag:property_typeTitleView];
		if (!aView) {
			aView = [[ResizableViewWithText alloc]initWithFrame:CGRectZero];
			aView.tag = property_typeTitleView;
			[self.resizableView addSubview:aView];
			[aView release];
		}
		aView.font = boldFont;
		aView.text = testText;
		[aView setNeedsLayout];
		[aView setNeedsDisplay];
	} else {
		[[self.resizableView viewWithTag:property_typeTitleView]removeFromSuperview];
	}
	
	
	if (property_type) {
		// add som view with text
		ResizableViewWithText *aView = (ResizableViewWithText *)[self.resizableView viewWithTag:property_typeView];
		if (!aView) {
			aView = [[ResizableViewWithText alloc]initWithFrame:CGRectZero];
			aView.tag = property_typeView;
			[self.resizableView addSubview:aView];
			[aView release];
		}
		aView.font = normalFont;
		aView.text = property_type;
		[aView setNeedsLayout];
		[aView setNeedsDisplay];
	} else {
		[[self.resizableView viewWithTag:property_typeView]removeFromSuperview];
	}
	
	
	if (__IS_FOR_SALE__) {
		if (energy_efficiency_rating) {
			// add som view with text
			NSString *testText = @"Energy Efficiency Rating";
			ResizableViewWithText *aView = (ResizableViewWithText *)[self.resizableView viewWithTag:energy_efficiency_ratingTitleView];
			if (!aView) {
				aView = [[ResizableViewWithText alloc]initWithFrame:CGRectZero];
				aView.tag = energy_efficiency_ratingTitleView;
				[self.resizableView addSubview:aView];
				[aView release];
			}
			aView.font = boldFont;
			aView.text = testText;
			[aView setNeedsLayout];
			[aView setNeedsDisplay];
		} else {
			[[self.resizableView viewWithTag:energy_efficiency_ratingTitleView]removeFromSuperview];
		}
		
		if (energy_efficiency_rating) {
			// add som view with text
			ResizableViewWithText *aView = (ResizableViewWithText *)[self.resizableView viewWithTag:energy_efficiency_ratingView];
			if (!aView) {
				aView = [[ResizableViewWithText alloc]initWithFrame:CGRectZero];
				aView.tag = energy_efficiency_ratingView;
				[self.resizableView addSubview:aView];
				[aView release];
			}
			aView.font = normalFont;
			aView.text = energy_efficiency_rating;
			[aView setNeedsLayout];
			[aView setNeedsDisplay];
		} else {
			[[self.resizableView viewWithTag:energy_efficiency_ratingView]removeFromSuperview];
		}
		
		if (land) {
			// add som view with text
			NSString *testText = @"Land";
			ResizableViewWithText *aView = (ResizableViewWithText *)[self.resizableView viewWithTag:landTitleView];
			if (!aView) {
				aView = [[ResizableViewWithText alloc]initWithFrame:CGRectZero];
				aView.tag = landTitleView;
				[self.resizableView addSubview:aView];
				[aView release];
			}
			aView.font = boldFont;
			aView.text = testText;
			[aView setNeedsLayout];
			[aView setNeedsDisplay];
		} else {
			[[self.resizableView viewWithTag:landTitleView]removeFromSuperview];
		}
		
		if (land) {
			// add som view with text
			ResizableViewWithText *aView = (ResizableViewWithText *)[self.resizableView viewWithTag:landView];
			if (!aView) {
				aView = [[ResizableViewWithText alloc]initWithFrame:CGRectZero];
				aView.tag = landView;
				[self.resizableView addSubview:aView];
				[aView release];
			}
			aView.font = normalFont;
			aView.text = land;
			[aView setNeedsLayout];
			[aView setNeedsDisplay];
		} else {
			[[self.resizableView viewWithTag:landView]removeFromSuperview];
		}
		
		if (building) {
			// add som view with text
			NSString *testText = @"Building";
			ResizableViewWithText *aView = (ResizableViewWithText *)[self.resizableView viewWithTag:buildingTitleView];
			if (!aView) {
				aView = [[ResizableViewWithText alloc]initWithFrame:CGRectZero];
				aView.tag = buildingTitleView;
				[self.resizableView addSubview:aView];
				[aView release];
			}
			aView.font = boldFont;
			aView.text = testText;
			[aView setNeedsLayout];
			[aView setNeedsDisplay];
		} else {
			[[self.resizableView viewWithTag:buildingTitleView]removeFromSuperview];
		}
		
		if (building) {
			// add som view with text
			ResizableViewWithText *aView = (ResizableViewWithText *)[self.resizableView viewWithTag:buildingView];
			if (!aView) {
				aView = [[ResizableViewWithText alloc]initWithFrame:CGRectZero];
				aView.tag = buildingView;
				[self.resizableView addSubview:aView];
				[aView release];
			}
			aView.font = normalFont;
			aView.text = building;
			[aView setNeedsLayout];
			[aView setNeedsDisplay];
		} else {
			[[self.resizableView viewWithTag:buildingView]removeFromSuperview];
		}
		
		if (municipality) {
			// add som view with text
			NSString *testText = @"Municipality";
			ResizableViewWithText *aView = (ResizableViewWithText *)[self.resizableView viewWithTag:municipalityTitleView];
			if (!aView) {
				aView = [[ResizableViewWithText alloc]initWithFrame:CGRectZero];
				aView.tag = municipalityTitleView;
				[self.resizableView addSubview:aView];
				[aView release];
			}
			aView.font = boldFont;
			aView.text = testText;
			[aView setNeedsLayout];
			[aView setNeedsDisplay];
		} else {
			[[self.resizableView viewWithTag:municipalityTitleView]removeFromSuperview];
		}
		
		if (municipality) {
			// add som view with text
			ResizableViewWithText *aView = (ResizableViewWithText *)[self.resizableView viewWithTag:municipalityView];
			if (!aView) {
				aView = [[ResizableViewWithText alloc]initWithFrame:CGRectZero];
				aView.tag = municipalityView;
				[self.resizableView addSubview:aView];
				[aView release];
			}
			aView.font = normalFont;
			aView.text = municipality;
			[aView setNeedsLayout];
			[aView setNeedsDisplay];
		} else {
			[[self.resizableView viewWithTag:municipalityView]removeFromSuperview];
		}
		
		if (close_to) {
			// add som view with text
			NSString *testText = @"Close To";
			ResizableViewWithText *aView = (ResizableViewWithText *)[self.resizableView viewWithTag:close_toTitleView];
			if (!aView) {
				aView = [[ResizableViewWithText alloc]initWithFrame:CGRectZero];
				aView.tag = close_toTitleView;
				[self.resizableView addSubview:aView];
				[aView release];
			}
			aView.font = boldFont;
			aView.text = testText;
			[aView setNeedsLayout];
			[aView setNeedsDisplay];
		} else {
			[[self.resizableView viewWithTag:close_toTitleView]removeFromSuperview];
		}
		
		if (close_to) {
			// add som view with text
			ResizableViewWithText *aView = (ResizableViewWithText *)[self.resizableView viewWithTag:close_toView];
			if (!aView) {
				aView = [[ResizableViewWithText alloc]initWithFrame:CGRectZero];
				aView.tag = close_toView;
				[self.resizableView addSubview:aView];
				[aView release];
			}
			aView.font = normalFont;
			aView.text = close_to;
			[aView setNeedsLayout];
			[aView setNeedsDisplay];
		} else {
			[[self.resizableView viewWithTag:close_toView]removeFromSuperview];
		}
		
		if (features) {
			// add som view with text
			NSString *testText = @"Features";
			ResizableViewWithText *aView = (ResizableViewWithText *)[self.resizableView viewWithTag:featuresTitleView];
			if (!aView) {
				aView = [[ResizableViewWithText alloc]initWithFrame:CGRectZero];
				aView.tag = featuresTitleView;
				[self.resizableView addSubview:aView];
				[aView release];
			}
			aView.font = boldFont;
			aView.text = testText;
			[aView setNeedsLayout];
			[aView setNeedsDisplay];
		} else {
			[[self.resizableView viewWithTag:featuresTitleView]removeFromSuperview];
		}
		
		if (features) {
			// add som view with text
			ResizableViewWithText *aView = (ResizableViewWithText *)[self.resizableView viewWithTag:featuresView];
			if (!aView) {
				aView = [[ResizableViewWithText alloc]initWithFrame:CGRectZero];
				aView.tag = featuresView;
				[self.resizableView addSubview:aView];
				[aView release];
			}
			aView.font = normalFont;
			aView.text = features;
			[aView setNeedsLayout];
			[aView setNeedsDisplay];
		} else {
			[[self.resizableView viewWithTag:featuresView]removeFromSuperview];
		}
	} else {
		if (bond) {
			// add som view with text
			NSString *testText = @"Bond";
			ResizableViewWithText *aView = (ResizableViewWithText *)[self.resizableView viewWithTag:bondTitleView];
			if (!aView) {
				aView = [[ResizableViewWithText alloc]initWithFrame:CGRectZero];
				aView.tag = bondTitleView;
				[self.resizableView addSubview:aView];
				[aView release];
			}
			aView.font = boldFont;
			aView.text = testText;
			[aView setNeedsLayout];
			[aView setNeedsDisplay];
		} else {
			[[self.resizableView viewWithTag:bondTitleView]removeFromSuperview];
		}
		
		if (bond) {
			// add som view with text
			ResizableViewWithText *aView = (ResizableViewWithText *)[self.resizableView viewWithTag:bondView];
			if (!aView) {
				aView = [[ResizableViewWithText alloc]initWithFrame:CGRectZero];
				aView.tag = bondView;
				[self.resizableView addSubview:aView];
				[aView release];
			}
			aView.font = normalFont;
			aView.text = bond;
			[aView setNeedsLayout];
			[aView setNeedsDisplay];
		} else {
			[[self.resizableView viewWithTag:bondView]removeFromSuperview];
		}
	}
	
	
	if (inspections) {
		// add som view with text
		NSString *testText = @"Inspections";
		ResizableViewWithText *aView = (ResizableViewWithText *)[self.resizableView viewWithTag:inspectionsTitleView];
		if (!aView) {
			aView = [[ResizableViewWithText alloc]initWithFrame:CGRectZero];
			aView.tag = inspectionsTitleView;
			[self.resizableView addSubview:aView];
			[aView release];
		}
		aView.font = boldFont;
		aView.text = testText;
		[aView setNeedsLayout];
		[aView setNeedsDisplay];
	} else {
		[[self.resizableView viewWithTag:inspectionsTitleView]removeFromSuperview];
	}
	
	
	if (inspections) {
		// add som view with text
		ResizableViewWithText *aView = (ResizableViewWithText *)[self.resizableView viewWithTag:inspectionsView];
		if (!aView) {
			aView = [[ResizableViewWithText alloc]initWithFrame:CGRectZero];
			aView.tag = inspectionsView;
			[self.resizableView addSubview:aView];
			[aView release];
		}
		aView.font = normalFont;
		aView.text = inspections;
		[aView setNeedsLayout];
		[aView setNeedsDisplay];
	} else {
		[[self.resizableView viewWithTag:inspectionsView]removeFromSuperview];
	}
	
	if (copyright) {
		// add som view with text
		NSString *testText = @"Source";
		ResizableViewWithText *aView = (ResizableViewWithText *)[self.resizableView viewWithTag:copyrightTitleView];
		if (!aView) {
			aView = [[ResizableViewWithText alloc]initWithFrame:CGRectZero];
			aView.tag = copyrightTitleView;
			[self.resizableView addSubview:aView];
			[aView release];
		}
		aView.font = boldFont;
		aView.text = testText;
		[aView setNeedsLayout];
		[aView setNeedsDisplay];
	} else {
		[[self.resizableView viewWithTag:copyrightTitleView]removeFromSuperview];
	}
	
	
	if (copyright) {
		// add som view with text
		ResizableViewWithText *aView = (ResizableViewWithText *)[self.resizableView viewWithTag:copyrightView];
		if (!aView) {
			aView = [[ResizableViewWithText alloc]initWithFrame:CGRectZero];
			aView.tag = copyrightView;
			aView.target = self;
			aView.selector = @selector(openInBrowser:);
			[self.resizableView addSubview:aView];
			[aView release];
		}
		aView.font = normalFont;
		aView.text = copyright;
		[aView setNeedsLayout];
		[aView setNeedsDisplay];
	} else {
		[[self.resizableView viewWithTag:copyrightView]removeFromSuperview];
	}
	
	[self.resizableView setNeedsLayout];
	[self.resizableView setNeedsDisplay];
	
}

- (void)openInBrowser:(id)sender
{
	NSString *website_id = [self.appDelegate.userdb stringForQuery:@"select website_id from properties where id = ?", self.property_id];
	
	NSString *urlString = [NSString stringWithFormat:@"http://www.realestate.com.au/cgi-bin/rsearch?a=o&id=%@", website_id];
	
	[[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
	
	[_property_id release];
	[_resizableView release];
	
	[super dealloc];
}


@end
