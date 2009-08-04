//
//  ChatViewController.h
//  webgnosus_client
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
@interface ChatViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate> {
	UIBarButtonItem* sendMessageButton;
    NSMutableArray* items;
    AccountModel* account;
    UserModel* partner;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UIBarButtonItem* sendMessageButton;
@property (nonatomic, retain) NSMutableArray* items;
@property (nonatomic, retain) AccountModel* account;
@property (nonatomic, retain) UserModel* partner;

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithNibName:(NSString*)nibName bundle:(NSBundle*)nibBundle andTitle:(NSString*)viewTitle;
- (void)sendMessageButtonWasPressed:(id)sender;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface NSObject (ChatViewController)

- (void)setAccount:(AccountModel*)model;
- (void)setPartner:(UserModel*)model;

@end

