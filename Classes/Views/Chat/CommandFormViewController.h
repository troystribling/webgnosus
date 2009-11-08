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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface CommandFormViewController : UIViewController {
    IBOutlet UIScrollView* formScrollView;
    IBOutlet UIButton* cancelButton;
    IBOutlet UIButton* sendButton;
    CommandFormView* formView;
    XMPPIQ* form;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UIView* formScrollView;
@property (nonatomic, retain) UIButton* cancelButton;
@property (nonatomic, retain) UIButton* sendButton;
@property (nonatomic, retain) CommandFormView* formView;
@property (nonatomic, retain) XMPPIQ* form;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)form:(XMPPIQ*)initForm inView:(UIView*)containedView;
- (id)initWithNibName:(NSString*)nibName bundle:(NSBundle*)nibBundle inView:(UIView*)parentView andForm:(XMPPIQ*)initForm;

//-----------------------------------------------------------------------------------------------------------------------------------
- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)sendButtonPressed:(id)sender;

@end
