//
//  PubSubViewController.h
//  webgnosus
//
//  Created by Troy Stribling on 9/7/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

//-----------------------------------------------------------------------------------------------------------------------------------
@class AccountManagerViewController;
@class AccountModel;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface PubSubViewController : UITableViewController {
    IBOutlet AccountManagerViewController* accountManagerViewController;
	UIBarButtonItem* addPubSubItemButton;
	UIBarButtonItem* editAccountsButton;
	NSMutableArray* pubSubItems;
    AccountModel* account;
    NSInteger selectedItemType;
    NSInteger itemToDelete;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UIBarButtonItem* addPubSubItemButton;
@property (nonatomic, retain) UIBarButtonItem* editAccountsButton;
@property (nonatomic, retain) AccountManagerViewController* accountManagerViewController;
@property (nonatomic, retain) NSMutableArray* pubSubItems;
@property (nonatomic, retain) AccountModel* account;
@property (nonatomic, assign) NSInteger selectedItemType;
@property (nonatomic, assign) NSInteger itemToDelete;

//-----------------------------------------------------------------------------------------------------------------------------------

@end
