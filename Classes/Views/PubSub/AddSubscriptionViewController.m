//
//  AddSubscriptionViewController.m
//  webgnosus
//
//  Created by Troy Stribling on 9/11/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "AddSubscriptionViewController.h"
#import "ActivityView.h"
#import "AlertViewManager.h"
#import "XMPPClient.h"
#import "XMPPIQ.h"
#import "XMPPPubSubSubscriptions.h"
#import "XMPPClientManager.h"
#import "XMPPJID.h"
#import "SubscriptionModel.h"
#import "AccountModel.h"
#import "ServiceModel.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface AddSubscriptionViewController (PrivateAPI)

- (void)failureAlert:(NSString*)message;

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

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)failureAlert:(NSString*)message { 
    [AlertViewManager showAlert:@"Error Subscribing" withMessage:message];
}

//===================================================================================================================================
#pragma mark XMPPClientDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceivePubSubSubscribeError:(XMPPIQ*)iq {
    [self.addSubscriptionIndicatorView dismiss];
    [self.jidTextField becomeFirstResponder]; 
    [self failureAlert:@"Invalid Node or JID"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceivePubSubSubscribeResult:(XMPPIQ*)iq {
    [self.addSubscriptionIndicatorView dismiss];
    [self.navigationController popViewControllerAnimated:YES];
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
	self.title = @"Subscription";
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
- (void)viewWillDisappear:(BOOL)animated {
    [[XMPPClientManager instance] removeXMPPClientDelegate:self forAccount:self.account];
	[super viewWillDisappear:animated];
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
#pragma mark UITextFieldDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (![self.nodeTextField.text isEqualToString:@""] || ![self.jidTextField.text isEqualToString:@""]) {
        XMPPClient* client = [[XMPPClientManager instance] xmppClientForAccount:self.account andDelegateTo:self];
        XMPPJID* userJID = [XMPPJID jidWithString:self.jidTextField.text];
        NSString* nodeFullPath = [NSString stringWithFormat:@"%@/%@", [userJID pubSubRoot], self.nodeTextField.text];
        NSString* userPubSubService = [NSString stringWithFormat:@"pubsub.%@", [userJID domain]];
        ServiceModel* service = [ServiceModel findByService:[userJID domain] type:@"service" andCategory:@"pubsub"];
        if (service)
        if (![SubscriptionModel findByAccount:self.account andNode:nodeFullPath]) {
            [XMPPPubSubSubscriptions subscribe:client JID:[XMPPJID jidWithString:userPubSubService] node:nodeFullPath];
            [self.nodeTextField resignFirstResponder]; 
            self.addSubscriptionIndicatorView = [[ActivityView alloc] initWithTitle:@"Subscribing" inView:self.view];
        } else {
            [self failureAlert:@"Subscription exists"];
        }
    } else {
        [self failureAlert:@"Node and JID Must be Specified"];
    }
	return NO; 
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}


@end
