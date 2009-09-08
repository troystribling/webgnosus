//
//  AddAccountViewController.m
//  webgnosus
//
//  Created by Troy Stribling on 1/1/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "AddAccountViewController.h"
#import "AccountManagerViewController.h"
#import "AccountModel.h"
#import "AlertViewManager.h"

#import "XMPPClient.h"
#import "XMPPClientManager.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface AddAccountViewController (PrivateAPI)

- (void)failureAlert:(NSString*)title message:(NSString*)message;
- (void)accountConnectionFailed;
- (BOOL)saveAccount;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation AddAccountViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize jidTextField;
@synthesize passwordTextField;
@synthesize cancelButton;
@synthesize saveButton;
@synthesize account;
@synthesize managerView;
@synthesize isFirstAccount;

//===================================================================================================================================
#pragma mark AddAccountViewController

//-----------------------------------------------------------------------------------------------------------------------------------
- (IBAction)cancelButtonPressed:(id)sender {
    [self.view removeFromSuperview];
    [self.managerView showEditAccountView];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (IBAction)saveButtonPressed:(id)sender {
    [self saveAccount];
}

//===================================================================================================================================
#pragma mark AddAccountViewController PrivateApi

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)accountConnectionFailed:(NSString*)title {
    [self.account destroy];
    [AlertViewManager dismissConnectionIndicator]; 
    [AlertViewManager showAlert:title];
    [[XMPPClientManager instance] removeXMPPClientForAccount:self.account];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)saveAccount {
	NSString* enteredJid = self.jidTextField.text;
	NSString* enteredPassword = self.passwordTextField.text;
	NSArray* splitJid = [enteredJid componentsSeparatedByString:@"@"];
    AccountModel* oldAccount = [AccountModel findByJID:enteredJid];
	if ([splitJid count] == 2 && oldAccount == nil) {
        [AccountModel setAllNotDisplayed];
		self.account.jid = enteredJid;
		self.account.password = enteredPassword;
        self.account.activated = YES;
        self.account.connectionState = AccountNotConnected;
        self.account.host = [splitJid objectAtIndex:1];
        self.account.resource = @"iPhone";
        self.account.nickname = [[NSString alloc] initWithFormat:@"%@", [self.account jid]];
        self.account.port = 5222;
        self.account.displayed = YES;
        [[XMPPClientManager instance] xmppClientForAccount:self.account andDelegateTo:self];
        [AlertViewManager showConnectingIndicatorInView:self.managerView.view.window];
        [self.account insert];
        [self.account load];
        [[[XMPPClientManager instance] accountUpdateDelegate] didAddAccount];
	} else {
        if (oldAccount) {
            [AlertViewManager showAlert:@"Account Exists"];
        } else {
            [AlertViewManager showAlert:@"JID is Invalid"];
        }
	}
	return NO; 
}

//===================================================================================================================================
#pragma mark UIViewController

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithNibName:(NSString*)nibName bundle:(NSBundle*)nibBundle { 
	if (self = [super initWithNibName:nibName bundle:nibBundle]) { 
	} 
	return self; 
} 

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    if ([AccountModel count] == 0) {
        self.isFirstAccount = YES;
    } else {
        self.isFirstAccount = NO;
    }    
	self.account = [[AccountModel alloc] init];
	self.jidTextField.returnKeyType = UIReturnKeyDone;
    self.jidTextField.delegate = self;
	self.jidTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
	self.passwordTextField.returnKeyType = UIReturnKeyDone;
    self.passwordTextField.delegate = self;
	self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    if (self.isFirstAccount) {
        [self.jidTextField becomeFirstResponder]; 
    }
    [super viewDidLoad];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated {
	self.jidTextField.text = @"";
	self.passwordTextField.text = @"";
	[super viewWillAppear:animated];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillDisappear:(BOOL)animated {
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
#pragma mark XMPPClientDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClientDidNotConnect:(XMPPClient*)sender {
	[self accountConnectionFailed:@"Connection Failed"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient *)sender didNotAuthenticate:(NSXMLElement*)error {
	[self accountConnectionFailed:@"Authentication Failed"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClientDidAuthenticate:(XMPPClient *)sender {
    [[XMPPClientManager instance] removeXMPPClientDelegate:self forAccount:self.account];
    [AlertViewManager dismissConnectionIndicator]; 
    [self.view removeFromSuperview];
    if ([AccountModel count] == 1) {
        [self.managerView dismiss];
    } else {
        [self.view removeFromSuperview];
        [self.managerView showEditAccountView];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)sender didFinishReceivingRosterItems:(XMPPIQ *)iq {
}

//===================================================================================================================================
#pragma mark UITextFieldDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BOOL shouldReturn = YES;
    if (self.isFirstAccount) {
        shouldReturn = [self saveAccount];
    } 
    [textField resignFirstResponder];
    return shouldReturn;
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end

