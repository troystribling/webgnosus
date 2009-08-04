//
//  SelectAccountViewController.h
//  webgnosus_client
//
//  Created by Troy Stribling on 1/19/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

//-----------------------------------------------------------------------------------------------------------------------------------
@class AddContactViewController;
@class AccountModel;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface SelectAccountViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
	IBOutlet UIPickerView* accountPickerView;
	AddContactViewController* addContactViewController;
	NSMutableArray* accounts;
	AccountModel* account;
	UIBarButtonItem* accountSelectedButton;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UIPickerView* accountPickerView;
@property (nonatomic, retain) AddContactViewController* addContactViewController;
@property (nonatomic, retain) NSMutableArray* accounts;
@property (nonatomic, retain) UIBarButtonItem* accountSelectedButton;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)accountSelected;


@end
