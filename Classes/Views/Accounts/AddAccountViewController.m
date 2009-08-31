//
//  AddAccountViewController.m
//  webgnosus
//
//  Created by Troy Stribling on 1/1/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "AddAccountViewController.h"
#import "WebgnosusClientAppDelegate.h"
#import "AccountModel.h"
#import "AlertViewManager.h"

#import "XMPPClient.h"
#import "XMPPClientManager.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface AddAccountViewController (PrivateAPI)

- (void)failureAlert:(NSString*)title message:(NSString*)message;
- (void)accountConnectionFailed;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation AddAccountViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize jidTextField;
@synthesize passwordTextField;
@synthesize account;
@synthesize managerView;
@synthesize contentView;
@synthesize editView;

//===================================================================================================================================
#pragma mark AddAccountViewController

//===================================================================================================================================
#pragma mark AddAccountViewController PrivateApi

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)accountConnectionFailed:(NSString*)title {
    [self.account destroy];
    [AlertViewManager dismissConnectionIndicator]; 
    [AlertViewManager showAlert:title];
    [[XMPPClientManager instance] removeXMPPClientForAccount:self.account];
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
	self.account = [[AccountModel alloc] init];
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
    [AlertViewManager dismissConnectionIndicator]; 
    if ([AccountModel count] == 1) {
        [self.view removeFromSuperview];
        [self.contentView removeFromSuperview];
        [self.managerView removeFromSuperview];
    } else {
    }
}

//===================================================================================================================================
#pragma mark UITextFieldDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	NSString* enteredJid = self.jidTextField.text;
	NSString* enteredPassword = self.passwordTextField.text;
	NSArray* splitJid = [enteredJid componentsSeparatedByString:@"@"];
    AccountModel* oldAccount = [AccountModel findByJid:enteredJid andResource:@"iPhone"];
	if ([splitJid count] == 2 && oldAccount == nil) {
		self.account.jid = enteredJid;
		self.account.password = enteredPassword;
        self.account.activated = YES;
        self.account.displayed = NO;
        self.account.connectionState = AccountNotConnected;
        self.account.host = [splitJid objectAtIndex:1];
        self.account.resource = @"iPhone";
        self.account.nickname = [[NSString alloc] initWithFormat:@"%@", [self.account jid]];
        self.account.port = 5222;
        [[XMPPClientManager instance] xmppClientForAccount:self.account andDelegateTo:self];
        [AlertViewManager showConnectingIndicatorInView:self.view];
        [self.account insert];
        [self.account load];
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
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
    [self.account release];
}

@end

