//
//  HistoryViewController.h
//  webgnosus
//
//  Created by Troy Stribling on 1/11/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

//-----------------------------------------------------------------------------------------------------------------------------------
@class AccountModel;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface HistoryViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate> {
	UIBarButtonItem* editAccountsButton;
    NSMutableArray* messages;
    AccountModel* account;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) NSMutableArray* messages;
@property (nonatomic, retain) UIBarButtonItem* editAccountsButton;
@property (nonatomic, retain) AccountModel* account;

//-----------------------------------------------------------------------------------------------------------------------------------

@end
