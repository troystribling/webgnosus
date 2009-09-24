//
//  AddSubscriptionViewController.m
//  webgnosus
//
//  Created by Troy Stribling on 9/11/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "AddSubscriptionViewController.h"
#import "XMPPClient.h"
#import "XMPPIQ.h"
#import "AccountModel.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface AddSubscriptionViewController (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation AddSubscriptionViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize jidTextField;
@synthesize nodeTextField;
@synthesize account;
@synthesize addSubscriptionIndicatorView;

//===================================================================================================================================
#pragma mark AddSubscriptionViewController

//===================================================================================================================================
#pragma mark AddSubscriptionViewController PrivateAPI

//===================================================================================================================================
#pragma mark XMPPClientDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceivePubSubSubscribeError:(XMPPIQ*)iq {
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceivePubSubSubscribeResult:(XMPPIQ*)iq {
}

//===================================================================================================================================
#pragma mark UIViewController

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    }
    return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Add Subscription";
	self.account = [AccountModel findFirstDisplayed];
	self.nodeTextField.returnKeyType = UIReturnKeyDone;
    self.nodeTextField.delegate = self;
	self.nodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
	self.jidTextField.returnKeyType = UIReturnKeyDone;
    self.jidTextField.delegate = self;
	self.jidTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.jidTextField becomeFirstResponder]; 
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}


@end
