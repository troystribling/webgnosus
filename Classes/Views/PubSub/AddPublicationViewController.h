//
//  AddPublicationViewController.h
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
@interface AddPublicationViewController : UIViewController  <UITextFieldDelegate> {
	IBOutlet UITextField* nodeTextField;
    AccountModel* account;
    ActivityView* addPublicationIndicatorView;
    NSString* nodeFullPath;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UITextField* nodeTextField;
@property (nonatomic, retain) AccountModel* account;
@property (nonatomic, retain) ActivityView* addPublicationIndicatorView;
@property (nonatomic, retain) NSString* nodeFullPath;

//-----------------------------------------------------------------------------------------------------------------------------------

@end
