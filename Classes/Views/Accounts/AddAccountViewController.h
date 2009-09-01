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
    AccountManagerViewController* managerView;
    AccountModel* account;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UITextField* jidTextField;
@property (nonatomic, retain) UITextField* passwordTextField;
@property (nonatomic, retain) AccountManagerViewController* managerView;
@property (nonatomic, assign) AccountModel* account;

//-----------------------------------------------------------------------------------------------------------------------------------

@end
