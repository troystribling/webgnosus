//
//  AddPublicationViewController.m
//  webgnosus
//
//  Created by Troy Stribling on 9/11/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "AddPublicationViewController.h"
#import "ActivityView.h"
#import "AccountModel.h"
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
@synthesize addPublicationIndicatorView;

//===================================================================================================================================
#pragma mark AddPublicationViewController

//===================================================================================================================================
#pragma mark AddPublicationViewController PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)failureAlert:(NSString*)message { 
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Creating Node" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];	
	[alert release];
}

//===================================================================================================================================
#pragma mark XMPPClientDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceiveSubscriptionsError:(XMPPIQ*)iq {
    [self.addPublicationIndicatorView dismiss];
    [self failureAlert:@"Invalid Node Specification"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceiveSubscriptionsResult:(XMPPIQ*)iq {
    [self.addPublicationIndicatorView dismiss];
    [self.nodeTextField resignFirstResponder]; 
    [[XMPPClientManager instance] removeXMPPClientDelegate:self forAccount:self.account];
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
	self.title = @"Add Publication Node";
	self.account = [AccountModel findFirstDisplayed];
	self.nodeTextField.returnKeyType = UIReturnKeyDone;
    self.nodeTextField.delegate = self;
	self.nodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.nodeTextField becomeFirstResponder]; 
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
        NSString* newNode = [[NSString alloc] initWithFormat:@"%@/%@", [[self.account toJID] pubSubRoot], self.nodeTextField.text];
//        [XMPPPubSub create:client JID:[iq fromJID] node:newNode];
        self.addPublicationIndicatorView = [[ActivityView alloc] initWithTitle:@"Adding Node" inView:self.view];
        [newNode release];
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
