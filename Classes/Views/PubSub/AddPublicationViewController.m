//
//  AddPublicationViewController.m
//  webgnosus
//
//  Created by Troy Stribling on 9/11/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "AddPublicationViewController.h"
#import "AlertViewManager.h"
#import "AccountModel.h"
#import "ServiceItemModel.h"
#import "XMPPPubSub.h"
#import "XMPPJID.h"
#import "XMPPClient.h"
#import "XMPPClientManager.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface AddPublicationViewController (PrivateAPI)

- (void)failureAlert:(NSString*)message;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation AddPublicationViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize nodeTextField;
@synthesize account;

//===================================================================================================================================
#pragma mark AddPublicationViewController

//===================================================================================================================================
#pragma mark AddPublicationViewController PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)failureAlert:(NSString*)message { 
    [AlertViewManager showAlert:@"Error Creating Node" withMessage:message];
}

//===================================================================================================================================
#pragma mark XMPPClientDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceiveSubscriptionsError:(XMPPIQ*)iq {
    [AlertViewManager dismissActivityIndicator];
    [self.nodeTextField becomeFirstResponder]; 
    [self failureAlert:@"Invalid Node"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceiveSubscriptionsResult:(XMPPIQ*)iq {
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didDiscoverAllUserPubSubNodes:(XMPPJID*)jid {
    [AlertViewManager dismissActivityIndicator];
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
	self.title = @"Publication";
	self.account = [AccountModel findFirstDisplayed];
	self.nodeTextField.returnKeyType = UIReturnKeyDone;
    self.nodeTextField.delegate = self;
	self.nodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.nodeTextField becomeFirstResponder]; 
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
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
    if (![self.nodeTextField.text isEqualToString:@""]) {
        XMPPClient* client = [[XMPPClientManager instance] xmppClientForAccount:self.account andDelegateTo:self];
        NSString* nodeFullPath = [[NSString alloc] initWithFormat:@"%@/%@", [[self.account toJID] pubSubRoot], self.nodeTextField.text];
        if (![ServiceItemModel findByNode:nodeFullPath]) {
            [XMPPPubSub create:client JID:[self.account pubSubService] node:nodeFullPath];
            [self.nodeTextField resignFirstResponder]; 
            [AlertViewManager showActivityIndicatorInView:self.view.window withTitle:@"Adding Node"];
        } else {
            [self failureAlert:@"Node exists"];
        }
        [nodeFullPath release];
    } else {
        [self failureAlert:@"Node must not be empty"];
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
