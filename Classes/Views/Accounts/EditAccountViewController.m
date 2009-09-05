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
#import "AccountManagerViewController.h"
#import "ActivityView.h"
#import "SegmentedListPicker.h"
#import "AccountModel.h"
#import "XMPPClient.h"
#import "XMPPClientManager.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface EditAccountViewController (PrivateAPI)

- (void)exitView;
- (void)initAccountList;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation EditAccountViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize passwordTextField;
@synthesize reenterPasswordTextField;
@synthesize doneButton;
@synthesize deleteButton;
@synthesize addButton;
@synthesize sendPasswordButton;
@synthesize managerView;
@synthesize accountsViewController;
@synthesize activeAccounts;

//===================================================================================================================================
#pragma mark EditAccountViewController

//-----------------------------------------------------------------------------------------------------------------------------------
- (IBAction)doneButtonPressed:(id)sender {
    AccountModel* acct = [self account];
    [AccountModel setAllNotDisplayed];
    acct.displayed = YES;
    [acct update];
    [self.managerView dismiss];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (IBAction)addButtonPressed:(id)sender {
    [self.view removeFromSuperview];
    [self.managerView showAddAccountView];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (IBAction)deleteButtonPressed:(id)sender {
    AccountModel* acct = [self account];
    [[XMPPClientManager instance] removeXMPPClientForAccount:acct];
    [acct destroy];
    [self.activeAccounts removeItem:[acct jid]];
    [[[XMPPClientManager instance] multicastDelegate] didRemoveAccount];
    [self.view removeFromSuperview];
    [self.managerView showView];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (IBAction)sendPasswordButtonPressed:(id)sender {
	NSString* password = self.passwordTextField.text;
	NSString* reenterPassword = self.reenterPasswordTextField.text;
    if (![password isEqualToString:@""] && [password isEqualToString:reenterPassword]) {
        AccountModel* acct = [self account];
        acct.password = password;
        [[XMPPClientManager instance] xmppClientForAccount:self.account andDelegateTo:self];
    } else {
        [AlertViewManager showAlert:@"Password is Invalid"];
    }
}
//-----------------------------------------------------------------------------------------------------------------------------------
- (AccountModel*)account {
    NSString* acct = [self.activeAccounts selectedItem];
    return [AccountModel findByJID:acct];
}

//===================================================================================================================================
#pragma mark EditAccountViewController PrivateApi

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)exitView { 
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void) initAccountList {
    NSMutableArray* accountJIDs = [[NSMutableArray alloc] initWithCapacity:10];
    NSInteger selectedAccountIndex;
    NSArray* acctList = [AccountModel findAllActivated];
    for (int i = 0; i < [acctList count]; i++) {
        AccountModel* acct = [acctList objectAtIndex:i];
        [accountJIDs addObject:[acct jid]];
        if (acct.displayed) {
            selectedAccountIndex = i;
        }
    }
    self.activeAccounts = [[SegmentedListPicker alloc] init:accountJIDs withValueAtIndex:selectedAccountIndex  andRect:CGRectMake(15.0f, 45.0f, 240.0f, 30.0f)];
    [self.view addSubview:(UIView*)self.activeAccounts];
    [accountJIDs release];
}

//===================================================================================================================================
#pragma mark UIViewController

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithCoder:(NSCoder *)coder { 
	if (self = [super initWithCoder:coder]) { 
	} 
	return self; 
} 

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    self.passwordTextField.delegate = self;
    [self initAccountList];
    [super viewDidLoad];
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
    [textField resignFirstResponder];
	return YES; 
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [[XMPPClientManager instance] removeXMPPClientDelegate:self forAccount:self.account];
    [super dealloc];
}

@end

