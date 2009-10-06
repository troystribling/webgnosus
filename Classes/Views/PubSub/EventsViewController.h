//
//  EventsViewController.h
//  webgnosus
//
//  Created by Troy Stribling on 9/7/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

//-----------------------------------------------------------------------------------------------------------------------------------
@class AccountModel;
@class UserModel;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface EventsViewController : UITableViewController {
    NSMutableArray* events;
    AccountModel* account;
    NSString* service;
    NSString* node;
    NSString* name;
    NSInteger eventType;
	UIBarButtonItem* addEventButton;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) NSMutableArray* events;
@property (nonatomic, retain) AccountModel* account;
@property (nonatomic, retain) NSString* service;
@property (nonatomic, retain) NSString* node;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, assign) NSInteger eventType;
@property (nonatomic, retain) UIBarButtonItem* addEventButton;

//-----------------------------------------------------------------------------------------------------------------------------------

@end
