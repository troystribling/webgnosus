//
//  EditAccountViewController.m
//  webgnosus_client
//
//  Created by Troy Stribling on 2/6/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "EditAccountViewController.h"
#import "UICustomSwitch.h"
#import "AccountModel.h"
#import "ModelUpdateDelgate.h"
#import "ActivityView.h"

#import "XMPPClient.h"
#import "XMPPClientManager.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface EditAccountViewController (PrivateAPI)

- (void)setAccountActivated;
- (void)exitView;
- (void)accountConnectionFailed;
- (void)updateAccountActivation;
- (BOOL)connect;
- (BOOL)changePasssword;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation EditAccountViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize jidLabel;
@synthesize nicknameTextField;
@synthesize passwordTextField;
@synthesize activationSwitch;
@synthesize accountsViewController;
@synthesize account;
@synthesize didChangeAccountActivation;

//===================================================================================================================================
#pragma mark EditAccountViewController

//-----------------------------------------------------------------------------------------------------------------------------------
- (IBAction)accountActivationChanged {
    [self updateAccountActivation];
    self.didChangeAccountActivation = YES;
}

//===================================================================================================================================
#pragma mark EditAccountViewController PrivateApi

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)accountConnectionFailed:(NSString*)title {
	[self.activationSwitch setOn:NO animated:YES];
    [self updateAccountActivation];
    [ModelUpdateDelgate dismissConnectionIndicator]; 
    [ModelUpdateDelgate showAlert:title];
    [[XMPPClientManager instance] removeXMPPClientForAccount:self.account];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)updateAccountActivation { 
	self.account.activated = self.activationSwitch.on;
	[self.account update];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)connect { 
    if (self.activationSwitch.on) {
        [[XMPPClientManager instance] xmppClientForAccount:self.account andDelegateTo:self];
        [ModelUpdateDelgate showConnectingIndicatorInView:self.view];
        return NO;
    } else {
        self.account.connectionState = AccountNotConnected;
        [self.account update];
        [[XMPPClientManager instance] removeXMPPClientForAccount:self.account];
        return YES;
    }  
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)changePasssword {
    if (self.activationSwitch.on) {
        [[XMPPClientManager instance] xmppClientForAccount:self.account andDelegateTo:self];
    } 
    return YES;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)exitView { 
    [self.passwordTextField resignFirstResponder]; 
    [self.navigationController popViewControllerAnimated:YES];
}

//===================================================================================================================================
#pragma mark UIViewController

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithNibName:(NSString*)nibName bundle:(NSBundle*)nibBundle { 
	if (self = [super initWithNibName:nibName bundle:nibBundle]) { 
        self.didChangeAccountActivation = NO;
	} 
	return self; 
} 

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    self.activationSwitch.on = self.account.activated;
    self.jidLabel.text = [self.account fullJID];
	self.title = @"Edit Account";
    self.nicknameTextField.text = self.account.nickname;
    self.nicknameTextField.delegate = self;
	self.nicknameTextField.returnKeyType = UIReturnKeyDone;
	self.nicknameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextField.delegate = self;
	self.passwordTextField.returnKeyType = UIReturnKeyDone;
	self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.passwordTextField becomeFirstResponder]; 
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; 
}

//===================================================================================================================================
#pragma mark XMPPClientDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClientDidNotConnect:(XMPPClient *)sender {
    [self accountConnectionFailed:@"Connection Failed"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient *)sender didNotAuthenticate:(NSXMLElement *)error {
    [self accountConnectionFailed:@"Authentication Falied"];
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
	NSString* enteredPassword = self.passwordTextField.text;
    NSString* enteredNickname = self.nicknameTextField.text;
    if (![enteredPassword isEqualToString:@""]) {
        self.account.password = enteredPassword;
        shouldReturn = [self changePasssword];
    }
    if (self.didChangeAccountActivation) {
        shouldReturn = [self connect];
    }
    if ([enteredNickname isEqualToString:@""]) {
        self.account.nickname = [self.account fullJID];
    } else {
        self.account.nickname = enteredNickname;
    }
    [self.account update];
	if (shouldReturn) {
		[self exitView];
	}
	return shouldReturn; 
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [[XMPPClientManager instance] removeXMPPClientDelegate:self forAccount:self.account];
    [super dealloc];
}

@end

