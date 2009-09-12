//
//  AddSubscriptionViewController.h
//  webgnosus
//
//  Created by Troy Stribling on 9/11/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

//-----------------------------------------------------------------------------------------------------------------------------------
@class AccountModel;
@class ActivityView;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface AddSubscriptionViewController : UIViewController {
	IBOutlet UITextField* jidTextField;
	IBOutlet UITextField* nodeTextField;
    AccountModel* account;
    ActivityView* addSubscriptionIndicatorView;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UITextField* jidTextField;
@property (nonatomic, retain) UITextField* nodeTextField;
@property (nonatomic, retain) AccountModel* account;
@property (nonatomic, retain) ActivityView* addSubscriptionIndicatorView;

//-----------------------------------------------------------------------------------------------------------------------------------

@end
