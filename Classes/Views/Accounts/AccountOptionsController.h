//
//  AccountOptionsController.h
//  webgnosus
//
//  Created by Troy Stribling on 1/29/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

//-----------------------------------------------------------------------------------------------------------------------------------
@class AddAccountViewController;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface AccountOptionsController : UIViewController <UITextFieldDelegate> {
    IBOutlet UITextField* nicknameTextField;
	IBOutlet UITextField* hostTextField;
	IBOutlet UITextField* resourceTextField;
    IBOutlet UITextField* portTextField;
    AddAccountViewController* addAccountViewController;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain)UITextField* nicknameTextField;
@property (nonatomic, retain) UITextField* hostTextField;
@property (nonatomic, retain) UITextField* resourceTextField;
@property (nonatomic, retain) UITextField* portTextField;
@property (nonatomic, retain) AddAccountViewController* addAccountViewController;

@end
