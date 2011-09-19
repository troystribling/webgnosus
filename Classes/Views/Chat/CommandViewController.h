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
@class ServiceItemModel;
@class CommandFormViewController;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface CommandViewController : UITableViewController {
    AccountModel* account;
    UserModel* rosterItem;
    NSMutableDictionary* commands;
    ServiceItemModel* commandRequest;
    NSMutableArray* sectionViewControllers;
    CommandFormViewController* formController;
    BOOL formDisplayed;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) AccountModel* account;
@property (nonatomic, retain) UserModel* rosterItem;
@property (nonatomic, retain) NSMutableDictionary* commands;
@property (nonatomic, retain) ServiceItemModel* commandRequest;
@property (nonatomic, retain) NSMutableArray* sectionViewControllers;
@property (nonatomic, retain) CommandFormViewController* formController;
@property (nonatomic, assign) BOOL formDisplayed;

//-----------------------------------------------------------------------------------------------------------------------------------

@end
