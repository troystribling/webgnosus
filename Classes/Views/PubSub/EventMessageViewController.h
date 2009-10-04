//
//  EventMessageViewController.h
//  webgnosus
//
//  Created by Troy Stribling on 10/3/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>
//-----------------------------------------------------------------------------------------------------------------------------------
@class AccountModel;
@class UserModel;
@class ServiceItemModel;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface EventMessageViewController : UIViewController {
    IBOutlet UITextView* messageView;
	IBOutlet UIBarButtonItem* sendMessageButton;
    ServiceItemModel* serviceItem;
    AccountModel* account;
    UserModel* rosterItem;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UITextView* messageView;
@property (nonatomic, retain) UIBarButtonItem* sendMessageButton;
@property (nonatomic, retain) ServiceItemModel* serviceItem;
@property (nonatomic, retain) AccountModel* account;
@property (nonatomic, retain) UserModel* rosterItem;

//-----------------------------------------------------------------------------------------------------------------------------------
- (IBAction)sendMessageButtonWasPressed:(id)sender;

@end
