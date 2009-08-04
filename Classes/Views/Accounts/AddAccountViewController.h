//
//  AddAccountViewController.h
//  webgnosus_client
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
	IBOutlet UISwitch* activationSwitch;
	UIBarButtonItem* optionsButton;
    AccountModel* account;
    NSString* host;
    NSString* resource;
    NSString* nickname;
    NSInteger port;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UITextField* jidTextField;
@property (nonatomic, retain) UITextField* passwordTextField;
@property (nonatomic, retain) UISwitch* activationSwitch;
@property (nonatomic, retain) UIBarButtonItem* optionsButton;
@property (nonatomic, assign) AccountModel* account;
@property (nonatomic, retain) NSString* host;
@property (nonatomic, retain) NSString* resource;
@property (nonatomic, retain) NSString* nickname;
@property (nonatomic, assign) NSInteger port;

//-----------------------------------------------------------------------------------------------------------------------------------

@end
