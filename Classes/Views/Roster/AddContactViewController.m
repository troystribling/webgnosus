//
//  AddContactViewController.m
//  webgnosus_client
//
//  Created by Troy Stribling on 1/19/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "AddContactViewController.h"
#import "SelectAccountViewController.h"
#import "ContactModel.h"
#import "AccountModel.h"
#import "ActivityView.h"

#import "XMPPJID.h"
#import "XMPPRosterItem.h"
#import "XMPPClient.h"
#import "XMPPClientManager.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface AddContactViewController (PrivateAPI)

- (void)failureAlert:(NSString*)title message:(NSString*)message;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation AddContactViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize selectAccountButton;
@synthesize jidTextField;
@synthesize accountLabel;
@synthesize account;
@synthesize addContactIndicatorView;
@synthesize newContactJidString;

//===================================================================================================================================
#pragma mark AddContactViewController

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)selectAccountButtonPressed {
	SelectAccountViewController* selectAccountViewController = [[SelectAccountViewController alloc] initWithNibName:@"SelectAccountViewController" bundle:nil]; 
	selectAccountViewController.addContactViewController = self;
	[self.navigationController pushViewController:selectAccountViewController animated:YES]; 
	[selectAccountViewController release]; 
}

//===================================================================================================================================
#pragma mark AddContactViewController PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)failureAlert:(NSString*)title message:(NSString*)message { 
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];	
	[alert release];
}

//===================================================================================================================================
#pragma mark XMPPClientDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)sender didAddToRoster:(XMPPRosterItem*)item {
    if ([self.newContactJidString isEqualToString:[[item jid] bare]] && self.addContactIndicatorView) {
        [self.addContactIndicatorView dismiss];
        [self.addContactIndicatorView release];
        [self.jidTextField resignFirstResponder]; 
        [[XMPPClientManager instance] removeXMPPClientDelegate:self forAccount:self.account];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//===================================================================================================================================
#pragma mark UIViewController

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Add Contact";
	self.account = [AccountModel findFirst];
	self.accountLabel.text = self.account.jid;
	[self.selectAccountButton addTarget:self action:@selector(selectAccountButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	self.jidTextField.returnKeyType = UIReturnKeyDone;
    self.jidTextField.delegate = self;
	self.jidTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.jidTextField becomeFirstResponder]; 
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
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
	if ([splitJid count] == 2) {
        XMPPClient* xmppClient = [[XMPPClientManager instance] xmppClientForAccount:self.account andDelegateTo:self];
        XMPPJID* contactJID = [XMPPJID jidWithString:self.newContactJidString];
        [xmppClient addBuddy:contactJID];
        self.addContactIndicatorView = [[ActivityView alloc] initWithTitle:@"Adding Contact" inView:self.view];
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
