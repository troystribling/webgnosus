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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface AddContactViewController : UIViewController <UITextFieldDelegate> {
	IBOutlet UITextField* jidTextField;
    AccountModel* account;
    NSString* newContactJidString;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UITextField* jidTextField;
@property (nonatomic, retain) AccountModel* account;
@property (nonatomic, retain) NSString* newContactJidString;

//-----------------------------------------------------------------------------------------------------------------------------------

@end
