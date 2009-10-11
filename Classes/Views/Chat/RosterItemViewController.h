//
//  RosterItemViewController.h
//  webgnosus
//
//  Created by Troy Stribling on 2/28/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

//-----------------------------------------------------------------------------------------------------------------------------------
@class AccountModel;
@class UserModel;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface RosterItemViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate> {
    NSInteger rosterMode;
    NSString* selectedMode;
    NSMutableArray* modes;
	UIBarButtonItem* sendMessageButton;
    NSMutableArray* items;
    AccountModel* account;
    UserModel* rosterItem;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, assign) NSInteger rosterMode;
@property (nonatomic, retain) NSString* selectedMode;
@property (nonatomic, retain) NSMutableArray* modes;
@property (nonatomic, retain) UIBarButtonItem* sendMessageButton;
@property (nonatomic, retain) NSMutableArray* items;
@property (nonatomic, retain) AccountModel* account;
@property (nonatomic, retain) UserModel* rosterItem;

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithNibName:(NSString*)nibName bundle:(NSBundle*)nibBundle andTitle:(NSString*)viewTitle;

@end
