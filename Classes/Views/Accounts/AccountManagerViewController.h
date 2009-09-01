//
//  AccountManagerViewController.h
//  webgnosus
//
//  Created by Troy Stribling on 1/1/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

//-----------------------------------------------------------------------------------------------------------------------------------
@class AddAccountViewController;
@class EditAccountViewController;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface AccountManagerViewController : UIViewController {
    IBOutlet AddAccountViewController* addAccountViewController;
    IBOutlet EditAccountViewController* editAccountViewController;
    UIView* contentView;
    UIView* contentViewBorder;
    NSString* currentView;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UIView* contentView;
@property (nonatomic, retain) UIView* contentViewBorder;
@property (nonatomic, retain) NSString* currentView;
@property (nonatomic, retain) AddAccountViewController* addAccountViewController;
@property (nonatomic, retain) EditAccountViewController* editAccountViewController;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addAsSubview:(UIView*)parent;
- (void)dismiss;
- (void)showEditAccountView;
- (void)showAddAccountView;

@end
