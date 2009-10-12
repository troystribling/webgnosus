//
//  ServiceChangeViewController.h
//  webgnosus
//
//  Created by Troy Stribling on 10/11/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

//-----------------------------------------------------------------------------------------------------------------------------------
@class AccountModel;
@class ServiceViewController;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ServiceChangeViewController : UIViewController <UITextFieldDelegate> {
	IBOutlet UITextField* addressTextField;
	IBOutlet UITextField* nodeTextField;
    ServiceViewController* serviceController;
    AccountModel* account;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UITextField* addressTextField;
@property (nonatomic, retain) UITextField* nodeTextField;
@property (nonatomic, retain) ServiceViewController* serviceController;
@property (nonatomic, retain) AccountModel* account;

//-----------------------------------------------------------------------------------------------------------------------------------


@end
