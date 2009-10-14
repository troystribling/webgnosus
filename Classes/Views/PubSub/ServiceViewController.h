//
//  ServiceViewController.h
//  webgnosus
//
//  Created by Troy Stribling on 10/11/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

//-----------------------------------------------------------------------------------------------------------------------------------
@class AccountModel;
@class ServiceItemModel;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ServiceViewController : UITableViewController {
	UIBarButtonItem* editAccountsButton;
	UIBarButtonItem* searchServiceButton;
    NSMutableArray* serviceItems;
    NSString* node;
    NSString* service;
    AccountModel* account;
    ServiceItemModel* selectedItem;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UIBarButtonItem* editAccountsButton;
@property (nonatomic, retain) UIBarButtonItem* searchServiceButton;
@property (nonatomic, retain) NSMutableArray* serviceItems;
@property (nonatomic, retain) NSString* node;
@property (nonatomic, retain) NSString* service;
@property (nonatomic, retain) AccountModel* account;
@property (nonatomic, retain) ServiceItemModel* selectedItem;

//-----------------------------------------------------------------------------------------------------------------------------------

@end
