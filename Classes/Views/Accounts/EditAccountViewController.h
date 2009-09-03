//
//  EditAccountViewController.h
//  webgnosus
//
//  Created by Troy Stribling on 2/6/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

//-----------------------------------------------------------------------------------------------------------------------------------
@class AccountModel;
@class AccountManagerViewController;
@class AccountsViewController;
@class UICustomSwitch;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface EditAccountViewController : UIViewController <UITextFieldDelegate> {
	IBOutlet UITextField* passwordTextField;
    IBOutlet UIButton* doneButton;
    IBOutlet UIButton* deleteButton;
    IBOutlet UIButton* addButton;
    IBOutlet UIButton* sendPasswordButton;    
    AccountManagerViewController* managerView;
    AccountsViewController* accountsViewController;
    AccountModel* account;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UITextField* passwordTextField;
@property (nonatomic, retain) UIButton* doneButton;
@property (nonatomic, retain) UIButton* deleteButton;
@property (nonatomic, retain) UIButton* addButton;
@property (nonatomic, retain) UIButton* sendPasswordButton;
@property (nonatomic, retain) AccountManagerViewController* managerView;
@property (nonatomic, retain) AccountsViewController* accountsViewController;
@property (nonatomic, retain) AccountModel* account;

//-----------------------------------------------------------------------------------------------------------------------------------
- (IBAction)doneButtonPressed:(id)sender;


@end
