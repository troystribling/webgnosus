//
//  AgentXmppViewController.h
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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface AgentXmppViewController : UITableViewController {
    AccountModel* account;
    UserModel* partner;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) AccountModel* account;
@property (nonatomic, retain) UserModel* partner;

//-----------------------------------------------------------------------------------------------------------------------------------

@end
