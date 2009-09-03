//
//  EditAccountViewController.m
//  webgnosus
//
//  Created by Troy Stribling on 2/6/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "EditAccountViewController.h"
#import "UICustomSwitch.h"
#import "AccountModel.h"
#import "AlertViewManager.h"
#import "ActivityView.h"

#import "XMPPClient.h"
#import "XMPPClientManager.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface EditAccountViewController (PrivateAPI)

- (void)exitView;
- (void)changePasssword;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation EditAccountViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize passwordTextField;
@synthesize doneButton;
@synthesize deleteButton;
@synthesize addButton;
@synthesize sendPasswordButton;
@synthesize managerView;
@synthesize accountsViewController;
@synthesize account;

//===================================================================================================================================
#pragma mark EditAccountViewController

//-----------------------------------------------------------------------------------------------------------------------------------
- (IBAction)doneButtonPressed:(id)sender {
    [self.managerView dismiss];
}

//===================================================================================================================================
#pragma mark EditAccountViewController PrivateApi

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)changePasssword {
    [[XMPPClientManager instance] xmppClientForAccount:self.account andDelegateTo:self];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)exitView { 
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
    [super viewDidLoad];
    self.passwordTextField.delegate = self;
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

//===================================================================================================================================
#pragma mark UITextFieldDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BOOL shouldReturn = YES;
	NSString* enteredPassword = self.passwordTextField.text;
    if (![enteredPassword isEqualToString:@""]) {
        self.account.password = enteredPassword;
        [self changePasssword];
        shouldReturn = YES;
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

