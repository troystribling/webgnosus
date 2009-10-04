//
//  RosterViewController.h
//  webgnosus
//
//  Created by Troy Stribling on 1/19/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

//-----------------------------------------------------------------------------------------------------------------------------------
@class RosterCell;
@class AccountModel;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface RosterViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate> {
	UIBarButtonItem* addContactButton;
	UIBarButtonItem* editAccountsButton;
	NSMutableArray* roster;
    AccountModel* account;
    NSInteger selectedRoster;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UIBarButtonItem* addContactButton;
@property (nonatomic, retain) UIBarButtonItem* editAccountsButton;
@property (nonatomic, retain) NSMutableArray* roster;
@property (nonatomic, retain) AccountModel* account;
@property (nonatomic, assign) NSInteger selectedRoster;

//-----------------------------------------------------------------------------------------------------------------------------------

@end
