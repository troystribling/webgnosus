//
//  AddContactViewController.h
//  webgnosus
//
//  Created by Troy Stribling on 1/19/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

//-----------------------------------------------------------------------------------------------------------------------------------
@class AccountModel;
@class ActivityView;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface AddContactViewController : UIViewController <UITextFieldDelegate> {
	IBOutlet UIButton* selectAccountButton;
	IBOutlet UITextField* jidTextField;
	IBOutlet UILabel* accountLabel;
    AccountModel* account;
    ActivityView* addContactIndicatorView;
    NSString* newContactJidString;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UIButton* selectAccountButton;
@property (nonatomic, retain) UITextField* jidTextField;
@property (nonatomic, retain) UILabel* accountLabel;
@property (nonatomic, retain) AccountModel* account;
@property (nonatomic, retain) ActivityView* addContactIndicatorView;
@property (nonatomic, retain) NSString* newContactJidString;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)selectAccountButtonPressed;

@end
