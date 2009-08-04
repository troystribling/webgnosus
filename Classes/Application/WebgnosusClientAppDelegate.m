//
//  WebgnosusClientAppDelegate.m
//  webgnosus
//
//  Created by Troy Stribling on 1/1/09.
//  Copyright Plan-B Research 2009. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPPresence.h"
#import "XMPPClient.h"
#import "XMPPJID.h"
#import "XMPPIQ.h"
#import "XMPPClientManager.h"
#import "DDXML.h"

#import "WebgnosusClientAppDelegate.h"
#import "WebgnosusDbi.h"
#import "RosterViewController.h"
#import "AccountsViewController.h"
#import "HistoryViewController.h"
#import "AcceptBuddyRequestView.h"
#import "AccountModel.h"
#import "ActivityView.h"
#import "ContactModel.h"
#import "RosterItemModel.h"

#import "ModelUpdateDelgate.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface WebgnosusClientAppDelegate (PrivateAPI)

- (void)openActivatedAccounts;
- (UINavigationController*)createNavigationController:(UIViewController*)viewController;
- (void)accountConnectionFailedForClient:(XMPPClient*)sender;
- (void)updateAccountConnectionState:(AccountConnectionState)title forClient:(XMPPClient*)client;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation WebgnosusClientAppDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize window;
@synthesize rosterViewController;
@synthesize historyViewController;
@synthesize accountsViewController;

@synthesize tabBarController;
@synthesize navAccountsViewController;
@synthesize navRosterViewController;
@synthesize navHistoryViewController;

//===================================================================================================================================
#pragma mark WebgnosusClientAppDelegate

//===================================================================================================================================
#pragma mark WebgnosusClientAppDelegate PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)openActivatedAccounts {
    NSMutableArray* accounts = [AccountModel findAll];
	for (int i = 0; i < [accounts count]; i++) {
        AccountModel* account = [accounts objectAtIndex:i];
        account.connectionState = AccountNotConnected;
        [account update];
    }
    [accounts release];
    accounts = [AccountModel findAllActivated];
	for (int i = 0; i < [accounts count]; i++) {
        AccountModel* account = [accounts objectAtIndex:i];
        [account update];
        [RosterItemModel destroyAllByAccount:account];
        [ContactModel destroyAllByAccount:account];
        [[XMPPClientManager instance] openConnectionForAccount:account];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)updateAccountConnectionState:(AccountConnectionState)state forClient:(XMPPClient*)client { 
    AccountModel* account = [ModelUpdateDelgate accountForXMPPClient:client];
    account.connectionState = state;
    [account update];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (UINavigationController*)createNavigationController:(UIViewController*)viewController {
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    navController.navigationBar.tintColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0];
    return navController;
}

//===================================================================================================================================
#pragma mark UIApplicationDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)applicationDidFinishLaunching:(UIApplication *)application {   
	WebgnosusDbi* dbi = [WebgnosusDbi instance];
	if (![dbi copyDbFile]) {
		NSLog (@"Database inilaization failed");
		return;
	}	
	[dbi open];
	[[XMPPClientManager instance] setDelegate:self];
    [self openActivatedAccounts];
    self.tabBarController = [[UITabBarController alloc] init];	
	self.navRosterViewController = [self createNavigationController:self.rosterViewController];
    self.navRosterViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Roster" image:[UIImage imageNamed:@"tabbar-roster.png"] tag:1];
	self.navHistoryViewController = [self createNavigationController:self.historyViewController];	
    self.navHistoryViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"History" image:[UIImage imageNamed:@"tabbar-streams.png"] tag:0];
	self.navAccountsViewController = [self createNavigationController:self.accountsViewController];	
    self.navAccountsViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Accounts" image:[UIImage imageNamed:@"tabbar-accounts.png"] tag:2];
	self.tabBarController.viewControllers = [NSArray arrayWithObjects:self.navRosterViewController, self.navHistoryViewController, self.navAccountsViewController, nil];	
	[window addSubview:tabBarController.view];	
    [window makeKeyAndVisible];
}

//===================================================================================================================================
#pragma mark UIAlertViewDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    AcceptBuddyRequestView* buddyRequestView = (AcceptBuddyRequestView*)alertView;
    if (buttonIndex == 0) {
        [ModelUpdateDelgate xmppClient:buddyRequestView.xmppClient rejectBuddyRequest:buddyRequestView.buddyJid];        
    } else if (buttonIndex == 1) {
        [ModelUpdateDelgate xmppClient:buddyRequestView.xmppClient acceptBuddyRequest:buddyRequestView.buddyJid];        
    }
}

//===================================================================================================================================
#pragma mark NSobject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
	[self.historyViewController release]; 
	[self.rosterViewController release];
	[self.accountsViewController release]; 
	[self.navHistoryViewController release];
	[self.navRosterViewController release];
	[self.navAccountsViewController release];
	[self.tabBarController release];
    [self.window release]; 
	[super dealloc];
}

//===================================================================================================================================
#pragma mark XMPPClientDelegate

//===================================================================================================================================
#pragma mark Connection

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClientConnecting:(XMPPClient*)sender {
	[ModelUpdateDelgate xmppClientConnecting:sender];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClientDidConnect:(XMPPClient*)sender {
    [self updateAccountConnectionState:AccountConnected forClient:sender];
	[ModelUpdateDelgate xmppClientDidConnect:sender];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClientDidNotConnect:(XMPPClient*)sender {
    [self updateAccountConnectionState:AccountConnectionError forClient:sender];
	[ModelUpdateDelgate xmppClientDidNotConnect:sender];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClientDidDisconnect:(XMPPClient*)sender {
    [self updateAccountConnectionState:AccountNotConnected forClient:sender];
	[ModelUpdateDelgate xmppClientDidDisconnect:sender];
}

//===================================================================================================================================
#pragma mark Authentication

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClientDidAuthenticate:(XMPPClient*)sender {
    [self updateAccountConnectionState:AccountAuthenticated forClient:sender];
	[ModelUpdateDelgate xmppClientDidAuthenticate:sender];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)sender didNotAuthenticate:(NSXMLElement*)error {
    [self updateAccountConnectionState:AccountAuthenticationError forClient:sender];
	[ModelUpdateDelgate xmppClient:sender didNotAuthenticate:error];
}

//===================================================================================================================================
#pragma mark IQ

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)sender didReceiveIQ:(XMPPIQ*)iq {
	[ModelUpdateDelgate xmppClient:sender didReceiveIQ:iq];
}

//===================================================================================================================================
#pragma mark Message

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)sender didReceiveMessage:(XMPPMessage*)message {
	[ModelUpdateDelgate xmppClient:sender didReceiveMessage:message];
}

//===================================================================================================================================
#pragma mark Roster

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)sender didAddToRoster:(XMPPRosterItem*)item {
    [ModelUpdateDelgate xmppClient:sender didAddToRoster:item];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)sender didRemoveFromRoster:(XMPPRosterItem*)item {
	[ModelUpdateDelgate xmppClient:sender didRemoveFromRoster:item];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)sender didFinishReceivingRosterItems:(XMPPIQ *)iq {
    [self updateAccountConnectionState:AccountRosterUpdated forClient:sender];
	[ModelUpdateDelgate xmppClient:sender didFinishReceivingRosterItems:iq];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)sender didReceivePresence:(XMPPPresence*)presence {
	[ModelUpdateDelgate xmppClient:sender didReceivePresence:presence];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)sender didReceiveErrorPresence:(XMPPPresence*)presence {
    NSString* title = [[presence toJID] full];
    NSString* message = [[NSString alloc] initWithFormat:@"Error with contact '%@'", [[presence fromJID] full]];
    [ModelUpdateDelgate showAlert:title withMessage:message];
	[ModelUpdateDelgate xmppClient:sender didReceiveErrorPresence:presence];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)sender didReceiveBuddyRequest:(XMPPJID*)buddyJid {
    AccountModel* account = [ModelUpdateDelgate accountForXMPPClient:sender];
    if (account) {
        ContactModel* contact = [ContactModel findByJid:[buddyJid bare] andAccount:account];	
        if (contact == nil) {
            AcceptBuddyRequestView* buddyRequestView = [[AcceptBuddyRequestView alloc] initWithClient:sender buddyJid:buddyJid andDelegate:self];
            [buddyRequestView show];	
            [buddyRequestView release];
        } else {
            [ModelUpdateDelgate xmppClient:sender acceptBuddyRequest:buddyJid];        
        }
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)sender didAcceptBuddyRequest:(XMPPJID*)buddyJid {
	[ModelUpdateDelgate xmppClient:sender didAcceptBuddyRequest:buddyJid];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)sender didRejectBuddyRequest:(XMPPJID*)buddyJid {
	[ModelUpdateDelgate xmppClient:sender didRejectBuddyRequest:buddyJid];
}

//===================================================================================================================================
#pragma mark Service Discovery

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)sender didReceiveClientVersionResult:(XMPPIQ*)iq {
	[ModelUpdateDelgate xmppClient:sender didReceiveClientVersionResult:iq];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)sender didReceiveClientVersionRequest:(XMPPIQ*)iq {
	[ModelUpdateDelgate xmppClient:sender didReceiveClientVersionRequest:iq];
}

//===================================================================================================================================
#pragma mark Commands
//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)sender didReceiveCommandResult:(XMPPIQ*)iq {
	[ModelUpdateDelgate xmppClient:sender didReceiveCommandResult:iq];
}

@end
