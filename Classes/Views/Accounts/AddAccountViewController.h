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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface AddAccountViewController : UIViewController <UITextFieldDelegate> {
	IBOutlet UITextField* jidTextField;
	IBOutlet UITextField* passwordTextField;
    UIView* managerView;
    UIView* contentView;
    UIView* editView;
    AccountModel* account;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UITextField* jidTextField;
@property (nonatomic, retain) UITextField* passwordTextField;
@property (nonatomic, retain) UIView* managerView;
@property (nonatomic, retain) UIView* contentView;
@property (nonatomic, retain) UIView* editView;
@property (nonatomic, assign) AccountModel* account;

//-----------------------------------------------------------------------------------------------------------------------------------

@end
