//
//  CommandViewController.h
//  webgnosus
//
//  Created by Troy Stribling on 3/23/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

//-----------------------------------------------------------------------------------------------------------------------------------
@class AccountModel;
@class UserModel;
@class ActivityView;
@class ServiceItemModel;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface CommandViewController : UITableViewController {
    AccountModel* account;
    UserModel* rosterItem;
    NSMutableArray* commands;
    ServiceItemModel* commandRequest;
    ActivityView* commandRequestIndicatorView;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) AccountModel* account;
@property (nonatomic, retain) UserModel* rosterItem;
@property (nonatomic, retain) NSMutableArray* commands;
@property (nonatomic, retain) ServiceItemModel* commandRequest;
@property (nonatomic, retain) ActivityView* commandRequestIndicatorView;

//-----------------------------------------------------------------------------------------------------------------------------------

@end
