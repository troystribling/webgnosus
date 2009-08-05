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
@class AccountsViewController;
@class UICustomSwitch;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface EditAccountViewController : UIViewController <UITextFieldDelegate> {
	IBOutlet UILabel* jidLabel;
	IBOutlet UITextField* nicknameTextField;
	IBOutlet UITextField* passwordTextField;
    IBOutlet UICustomSwitch* activationSwitch;
    BOOL didChangeAccountActivation;
    AccountsViewController* accountsViewController;
    AccountModel* account;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UILabel* jidLabel;
@property (nonatomic, retain) UITextField* nicknameTextField;
@property (nonatomic, retain) UITextField* passwordTextField;
@property (nonatomic, retain) UICustomSwitch* activationSwitch;
@property (nonatomic, retain) AccountsViewController* accountsViewController;
@property (nonatomic, retain) AccountModel* account;
@property (nonatomic, assign) BOOL didChangeAccountActivation;

//-----------------------------------------------------------------------------------------------------------------------------------
- (IBAction)accountActivationChanged;

@end
