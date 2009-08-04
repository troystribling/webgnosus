//
//  AddAccountViewController.m
//  webgnosus_client
//
//  Created by Troy Stribling on 1/1/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "AddAccountViewController.h"
#import "AccountOptionsController.h"
#import "WebgnosusClientAppDelegate.h"
#import "AccountModel.h"
#import "ModelUpdateDelgate.h"

#import "XMPPClient.h"
#import "XMPPClientManager.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface AddAccountViewController (PrivateAPI)

- (void)optionsButtonWasPressed ;
- (void)failureAlert:(NSString*)title message:(NSString*)message;
- (void)accountConnectionFailed;
- (void)exitView;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation AddAccountViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize jidTextField;
@synthesize passwordTextField;
@synthesize activationSwitch;
@synthesize optionsButton;
@synthesize account;
@synthesize host;
@synthesize resource;
@synthesize nickname;
@synthesize port;

//===================================================================================================================================
#pragma mark AddAccountViewController

//===================================================================================================================================
#pragma mark AddAccountViewController PrivateApi

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)optionsButtonWasPressed { 
	AccountOptionsController* addContactViewController = [[AccountOptionsController alloc] initWithNibName:@"AccountOptionsController" bundle:nil]; 
    addContactViewController.addAccountViewController = self;
	[self.navigationController pushViewController:addContactViewController animated:YES]; 
	[addContactViewController release]; 
}	

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)accountConnectionFailed:(NSString*)title {
    [self.account destroy];
	[self.activationSwitch setOn:NO animated:YES];
    [ModelUpdateDelgate dismissConnectionIndicator]; 
    [ModelUpdateDelgate showAlert:title];
    [[XMPPClientManager instance] removeXMPPClientForAccount:self.account];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)exitView { 
    [self.jidTextField resignFirstResponder]; 
    [self.navigationController popViewControllerAnimated:YES];
}

//===================================================================================================================================
#pragma mark UIViewController

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithNibName:(NSString*)nibName bundle:(NSBundle*)nibBundle { 
	if (self = [super initWithNibName:nibName bundle:nibBundle]) { 
        self.optionsButton = [[UIBarButtonItem alloc] initWithTitle:@"Options" style:UIBarButtonItemStylePlain target:self action:@selector(optionsButtonWasPressed)];
	} 
	return self; 
} 

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	self.account = [[AccountModel alloc] init];
    self.navigationItem.rightBarButtonItem = self.optionsButton;
	self.title = @"Add Account";
	self.jidTextField.returnKeyType = UIReturnKeyDone;
    self.jidTextField.delegate = self;
	self.jidTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
	self.passwordTextField.returnKeyType = UIReturnKeyDone;
    self.passwordTextField.delegate = self;
	self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.jidTextField becomeFirstResponder]; 
    [super viewDidLoad];
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
    [ModelUpdateDelgate dismissConnectionIndicator]; 
    [self exitView];
}

//===================================================================================================================================
#pragma mark UITextFieldDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BOOL shouldReturn = YES;
	NSString* enteredJid = self.jidTextField.text;
	NSString* enteredPassword = self.passwordTextField.text;
	NSArray* splitJid = [enteredJid componentsSeparatedByString:@"@"];
    AccountModel* oldAccount = [AccountModel findByJid:enteredJid andResource:@"iPhone"];
	if ([splitJid count] == 2 && oldAccount == nil) {
		self.account.jid = enteredJid;
		self.account.password = enteredPassword;
        self.account.activated = self.activationSwitch.on;
        self.account.connectionState = AccountNotConnected;
		if ([self.host isEqualToString:@""] || self.host == nil) {
			self.account.host = [splitJid objectAtIndex:1];
		} else {
			self.account.host = self.host;
		}
		if ([self.resource isEqualToString:@""] || self.resource == nil) {
			self.account.resource = @"iPhone";
		} else {
			self.account.resource = self.resource;
        }
		if ([self.nickname isEqualToString:@""] || self.nickname == nil) {
			self.account.nickname = [[NSString alloc] initWithFormat:@"%@", [self.account fullJID]];
		} else {
			self.account.nickname = self.nickname;
        }
		if (self.port == 0) {
            self.account.port = 5222;
		} else {
			self.account.port = self.port;
        }
        if (self.activationSwitch.on) {
            [[XMPPClientManager instance] xmppClientForAccount:self.account andDelegateTo:self];
            [ModelUpdateDelgate showConnectingIndicatorInView:self.view];
            shouldReturn = NO;
        }     
        [self.account insert];
        [self.account load];
	} else {
        if (oldAccount) {
            [ModelUpdateDelgate showAlert:@"Account Exists"];
        } else {
            [ModelUpdateDelgate showAlert:@"JID is Invalid"];
        }
		shouldReturn = NO;
	}
	if (shouldReturn) {
		[self exitView];
	}
	return shouldReturn; 
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end

