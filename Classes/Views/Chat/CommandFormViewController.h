//
//  CommandFormManagerViewController.h
//  webgnosus
//
//  Created by Troy Stribling on 11/5/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

//-----------------------------------------------------------------------------------------------------------------------------------
@class XMPPIQ;
@class CommandFormView;
@class AccountModel;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface CommandFormViewController : UIViewController {
    IBOutlet UIScrollView* formScrollView;
    IBOutlet UIButton* cancelButton;
    IBOutlet UIButton* sendButton;
    CommandFormView* formView;
    XMPPIQ* form;
    AccountModel* account;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UIView* formScrollView;
@property (nonatomic, retain) UIButton* cancelButton;
@property (nonatomic, retain) UIButton* sendButton;
@property (nonatomic, retain) CommandFormView* formView;
@property (nonatomic, retain) XMPPIQ* form;
@property (nonatomic, retain) AccountModel* account;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)form:(XMPPIQ*)initForm inView:(UIView*)containedView forAccount:(AccountModel*)initAccount;
- (id)initWithNibName:(NSString*)nibName bundle:(NSBundle*)nibBundle inView:(UIView*)parentView forForm:(XMPPIQ*)initForm andAccount:(AccountModel*)initAccount;

//-----------------------------------------------------------------------------------------------------------------------------------
- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)sendButtonPressed:(id)sender;

@end
