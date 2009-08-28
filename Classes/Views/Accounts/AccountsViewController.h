//
//  AccountsViewController.h
//  webgnosus
//
//  Created by Troy Stribling on 1/1/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

//-----------------------------------------------------------------------------------------------------------------------------------
@class AccountCell;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface AccountsViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate> {
	UIBarButtonItem* addAccountButton;
    UITabBarController* accountTabBarController;
	NSMutableArray* accounts;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UIBarButtonItem* addAccountButton;
@property (nonatomic, retain) UITabBarController* accountTabBarController;
@property (nonatomic, retain) NSMutableArray* accounts;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addAccountButtonWasPressed; 
- (AccountCell*)createAccountCellFromNib;

@end
