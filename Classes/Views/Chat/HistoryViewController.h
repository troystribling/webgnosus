//
//  HistoryViewController.h
//  webgnosus
//
//  Created by Troy Stribling on 1/11/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>
#import "GeoLocManager.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@class AccountModel;
@class HistoryMessageCache;
@class SectionViewController;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface HistoryViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, GeoLocUpdateDelegate> {
    HistoryMessageCache* messages;
	UIBarButtonItem* editAccountsButton;
    AccountModel* account;
    SectionViewController* sectionViewController;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) HistoryMessageCache* messages;
@property (nonatomic, retain) UIBarButtonItem* editAccountsButton;
@property (nonatomic, retain) AccountModel* account;
@property (nonatomic, retain) SectionViewController* sectionViewController;

//-----------------------------------------------------------------------------------------------------------------------------------

@end
