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
@class ServiceItemModel;
@class AccountModel;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface EventsViewController : UITableViewController {
    NSMutableArray* messages;
    AccountModel* account;
    ServiceItemModel* item;
    NSInteger eventType;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) NSMutableArray* messages;
@property (nonatomic, retain) AccountModel* account;
@property (nonatomic, retain) ServiceItemModel* item;
@property (nonatomic, assign) NSInteger eventType;

//-----------------------------------------------------------------------------------------------------------------------------------

@end
