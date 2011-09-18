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
@class SectionViewController;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface RosterItemViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate> {
    NSInteger rosterMode;
    NSString* selectedMode;
    NSMutableArray* modes;
    NSMutableArray* pendingRequests;
	UIBarButtonItem* sendMessageButton;
    SectionViewController* rosterHeader;
    id items;
    AccountModel* account;
    UserModel* rosterItem;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, assign) NSInteger rosterMode;
@property (nonatomic, retain) NSString* selectedMode;
@property (nonatomic, retain) NSMutableArray* modes;
@property (nonatomic, retain) NSMutableArray* pendingRequests;
@property (nonatomic, retain) UIBarButtonItem* sendMessageButton;
@property (nonatomic, retain) SectionViewController* rosterHeader;
@property (nonatomic, retain) id items;
@property (nonatomic, retain) AccountModel* account;
@property (nonatomic, retain) UserModel* rosterItem;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (RosterItemViewController*)viewWithNibName:(NSString*)nibName bundle:(NSBundle*)nibBundle;
+ (RosterItemViewController*)viewWithNibName:(NSString*)nibName bundle:(NSBundle*)nibBundle andTitle:(NSString*)viewTitle;
- (id)initWithNibName:(NSString*)nibName bundle:(NSBundle*)nibBundle andTitle:(NSString*)viewTitle;

@end
