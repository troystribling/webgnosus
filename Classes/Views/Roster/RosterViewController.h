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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface RosterViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate> {
	UIBarButtonItem* addContactButton;
	UIBarButtonItem* editAccountsButton;
	NSMutableArray* roster;
    NSMutableArray* accounts;
    NSInteger selectedRoster;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UIBarButtonItem* addContactButton;
@property (nonatomic, retain) UIBarButtonItem* editAccountsButton;
@property (nonatomic, retain) NSMutableArray* roster;
@property (nonatomic, retain) NSMutableArray* accounts;
@property (nonatomic, assign) NSInteger selectedRoster;

//-----------------------------------------------------------------------------------------------------------------------------------

@end
