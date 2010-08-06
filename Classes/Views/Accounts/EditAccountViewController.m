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
#import "ServiceItemModel.h"
#import "AlertViewManager.h"
#import "AccountManagerViewController.h"
#import "SegmentedListPicker.h"
#import "AccountModel.h"
#import "GeoLocManager.h"
#import "XMPPClient.h"
#import "XMPPClientManager.h"
#import "XMPPRegisterQuery.h"
#import "XMPPGeoLocUpdate.h"
#import "XMPPPubSub.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface EditAccountViewController (PrivateAPI)

- (void)initAccountList;
- (void)updateStatus;
- (void)trackingSwitchChanged:(id)sender;

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
@synthesize trackingSwitch;
@synthesize statusLabel;
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
    [[[XMPPClientManager instance] accountUpdateDelegate] didUpdateAccount];
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
    GeoLocManager* geoLoc = [GeoLocManager instance];
    if ([geoLoc accountUpdatesEnabled:acct]) {
        [geoLoc removeUpdateDelegatesForAccount:acct];
        [geoLoc stopIfNotUpdating];
    }
    [acct destroy];
    if ([AccountModel count] > 0) {    
        [self.activeAccounts removeItem:[acct bareJID]];
        [[[XMPPClientManager instance] accountUpdateDelegate] didRemoveAccount];
    }
    [self.view removeFromSuperview];
    [self.managerView showView];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (IBAction)sendPasswordButtonPressed:(id)sender {
	NSString* password = self.passwordTextField.text;
	NSString* reenterPassword = self.reenterPasswordTextField.text;
    [self.reenterPasswordTextField resignFirstResponder]; 
    if (![password isEqualToString:@""] && [password isEqualToString:reenterPassword]) {
        NSString* username = [[[self account] toJID] user];
        XMPPClient* client = [[XMPPClientManager instance] xmppClientForAccount:self.account];
        [XMPPRegisterQuery set:client user:username withPassword:password];
        [AlertViewManager showActivityIndicatorInView:self.view.window withTitle:@"Changing Password"];
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
- (void)trackingSwitchChanged:(id)sender {
    GeoLocManager* geoLoc = [GeoLocManager instance];
    if (self.trackingSwitch.on) {
        NSString* geoLocNode = [[self account] geoLocPubSubNode];
        [geoLoc addUpdateDelegate:[[[XMPPGeoLocUpdate alloc] init:[self account]] autorelease] forAccount:[self account]];
        if (![ServiceItemModel findByNode:geoLocNode]) {
            XMPPClient* client = [[XMPPClientManager instance] xmppClientForAccount:self.account];
            [XMPPPubSub create:client JID:[self.account pubSubService] node:geoLocNode];
            [AlertViewManager showActivityIndicatorInView:self.view.window withTitle:@"Adding Node"];
        } else {
            [geoLoc start];
        }
    } else {
        [geoLoc removeUpdateDelegatesForAccount:[self account]];
        [geoLoc stopIfNotUpdating];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void) initAccountList {
    NSMutableArray* accountJIDs = [NSMutableArray arrayWithCapacity:10];
    NSInteger selectedAccountIndex = 0;
    NSArray* acctList = [AccountModel findAllActivated];
    for (int i = 0; i < [acctList count]; i++) {
        AccountModel* acct = [acctList objectAtIndex:i];
        [accountJIDs addObject:[acct bareJID]];
        if (acct.displayed) {
            selectedAccountIndex = i;
        }
    }
    self.activeAccounts = [[SegmentedListPicker alloc] init:accountJIDs withValueAtIndex:selectedAccountIndex  andRect:CGRectMake(15.0f, 45.0f, 240.0f, 35.0f)];
    self.activeAccounts.delegate = self;
    [self updateStatus];
    [self.view addSubview:self.activeAccounts];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)updateStatus {
    AccountModel* acct = [self account];
    if (acct.connectionState == AccountConnected || acct.connectionState == AccountAuthenticated || acct.connectionState == AccountRosterUpdated ||
        acct.connectionState == AccountDiscoCompleted || acct.connectionState == AccountSubscriptionsUpdated || acct.connectionState ==  AccountRosterUpdateError ||
        acct.connectionState ==  AccountDiscoError || acct.connectionState == AccountSubscriptionsUpdateError) {
        self.statusLabel.text = @"Connected";
        self.statusLabel.textColor = [UIColor colorWithRed:0.0f green:0.5f blue:0.0f alpha:1.0f];
    } else if (acct.connectionState == AccountNotConnected) {
        self.statusLabel.text = @"Not Connected";
        self.statusLabel.textColor = [UIColor colorWithRed:0.5f green:0.0f blue:0.0f alpha:1.0f];
    } else {
        self.statusLabel.text = @"Connection Error";
        self.statusLabel.textColor = [UIColor colorWithRed:0.5f green:0.0f blue:0.0f alpha:1.0f];
    }
}

//===================================================================================================================================
#pragma mark XMPPClientDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceivePubSubCreateError:(XMPPIQ*)iq {
    [AlertViewManager dismissActivityIndicator];
    [self.trackingSwitch setOn:NO animated:YES];
    [AlertViewManager showAlert:@"geoloc node create failed"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceivePubSubCreateResult:(XMPPIQ*)iq {
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didDiscoverAllUserPubSubNodes:(XMPPJID*)jid {
    [AlertViewManager dismissActivityIndicator];
    GeoLocManager* geoLoc = [GeoLocManager instance];
    [geoLoc start];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceiveRegisterError:(XMPPIQ*)iq {
    [AlertViewManager dismissActivityIndicator];
    [AlertViewManager showAlert:@"Error Changing Password"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceiveRegisterResult:(XMPPIQ*)iq {
    [AlertViewManager dismissActivityIndicator];
    [AlertViewManager showAlert:@"Password Changed"];
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
    self.reenterPasswordTextField.delegate = self;
    [self.trackingSwitch addTarget:self action:@selector(trackingSwitchChanged:) forControlEvents:UIControlEventValueChanged];    
    [super viewDidLoad];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated {
    [self initAccountList];
    [[XMPPClientManager instance] delegateTo:self forAccount:self.account];
    if ([[GeoLocManager instance] accountUpdatesEnabled:[self account]]) {
        self.trackingSwitch.on = YES;
    } else {
        self.trackingSwitch.on = NO;
    }
	[super viewWillAppear:animated];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillDisappear:(BOOL)animated {
    [[XMPPClientManager instance] removeXMPPClientDelegate:self forAccount:self.account];
	[super viewWillDisappear:animated];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; 
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//===================================================================================================================================
#pragma mark SegmentedListPicker

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)selectedItemChanged:(SegmentedListPicker*)picker {
    [self updateStatus];
}

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
    [super dealloc];
}

@end

