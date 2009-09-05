//
//  AddAccountViewController.h
//  webgnosus
//
//  Created by Troy Stribling on 1/1/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

//-----------------------------------------------------------------------------------------------------------------------------------
@class AccountModel;
@class AccountManagerViewController;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface AddAccountViewController : UIViewController <UITextFieldDelegate> {
	IBOutlet UITextField* jidTextField;
	IBOutlet UITextField* passwordTextField;
    IBOutlet UIButton* cancelButton;
    IBOutlet UIButton* saveButton;
    AccountManagerViewController* managerView;
    AccountModel* account;
    BOOL isFirstAccount;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UITextField* jidTextField;
@property (nonatomic, retain) UITextField* passwordTextField;
@property (nonatomic, retain) UIButton* cancelButton;
@property (nonatomic, retain) UIButton* saveButton;
@property (nonatomic, retain) AccountManagerViewController* managerView;
@property (nonatomic, retain) AccountModel* account;
@property (nonatomic, assign) BOOL isFirstAccount;

//-----------------------------------------------------------------------------------------------------------------------------------
- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;

@end
