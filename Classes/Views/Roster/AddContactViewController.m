//
//  AddContactViewController.m
//  webgnosus
//
//  Created by Troy Stribling on 1/19/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "AddContactViewController.h"
#import "ContactModel.h"
#import "AccountModel.h"
#import "AlertViewManager.h"

#import "XMPPJID.h"
#import "XMPPRosterItem.h"
#import "XMPPClient.h"
#import "XMPPClientManager.h"
#import "XMPPMessageDelegate.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface AddContactViewController (PrivateAPI)

- (void)failureAlert:(NSString*)title message:(NSString*)message;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation AddContactViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize jidTextField;
@synthesize account;
@synthesize newContactJidString;

//===================================================================================================================================
#pragma mark AddContactViewController

//===================================================================================================================================
#pragma mark AddContactViewController PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)failureAlert:(NSString*)title message:(NSString*)message { 
    [AlertViewManager showAlert:title withMessage:message];
}

//===================================================================================================================================
#pragma mark XMPPClientDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)sender didAddToRoster:(XMPPRosterItem*)item {
    [AlertViewManager dismissActivityIndicator];
    [self.navigationController popViewControllerAnimated:YES];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceiveRosterError:(XMPPIQ*)iq {
    [AlertViewManager dismissActivityIndicator];
    [self failureAlert:@"JID is Invalid" message:@""];
}

//===================================================================================================================================
#pragma mark UIViewController

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Add Contact";
	self.account = [AccountModel findFirstDisplayed];
	self.jidTextField.returnKeyType = UIReturnKeyDone;
    self.jidTextField.delegate = self;
	self.jidTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.jidTextField becomeFirstResponder]; 
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated {
    [[XMPPClientManager instance] delegateTo:self forAccount:self.account];
	[super viewWillAppear:animated];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillDisappear:(BOOL)animated {
    [[XMPPClientManager instance] removeXMPPClientDelegate:self forAccount:self.account];
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
	self.newContactJidString = self.jidTextField.text;
	NSArray* splitJid = [self.newContactJidString componentsSeparatedByString:@"@"];
    [self.jidTextField resignFirstResponder]; 
	if ([splitJid count] == 2) {
        XMPPClient* xmppClient = [[XMPPClientManager instance] xmppClientForAccount:self.account];
        XMPPJID* contactJID = [XMPPJID jidWithString:self.newContactJidString];
        [XMPPMessageDelegate addBuddy:xmppClient JID:contactJID];
        [AlertViewManager showActivityIndicatorInView:self.view.window withTitle:@"Adding"];
	} else {
		[self failureAlert:@"JID is Invalid" message:@""];
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
