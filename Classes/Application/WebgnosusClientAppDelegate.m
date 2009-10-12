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
#import "XMPPMessageDelegate.h"
#import "DDXML.h"

#import "WebgnosusClientAppDelegate.h"
#import "WebgnosusDbi.h"
#import "RosterViewController.h"
#import "AccountManagerViewController.h"
#import "PubSubViewController.h"
#import "HistoryViewController.h"
#import "ServiceViewController.h"
#import "AcceptBuddyRequestView.h"
#import "AccountModel.h"
#import "ContactModel.h"
#import "RosterItemModel.h"
#import "SubscriptionModel.h"
#import "ServiceModel.h"
#import "ServiceFeatureModel.h"
#import "ServiceItemModel.h"
#import "AlertViewManager.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface WebgnosusClientAppDelegate (PrivateAPI)

- (void)openActivatedAccounts;
- (UINavigationController*)createNavigationController:(UIViewController*)viewController;
- (void)accountConnectionFailedForClient:(XMPPClient*)sender;
- (UITabBarController*)createTabBarController;
- (void)createAccountManager;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation WebgnosusClientAppDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize window;
@synthesize rosterViewController;
@synthesize historyViewController;
@synthesize pubSubViewController;
@synthesize serviceViewController;

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
    accounts = [AccountModel findAllActivated];
    [ServiceModel destroyAllUnsyched];
    [ServiceModel resetSyncFlag];
    [ServiceItemModel destroyAllUnsyched];
    [ServiceItemModel resetSyncFlag];
    [ServiceFeatureModel destroyAllUnsyched];
    [ServiceFeatureModel resetSyncFlag];
    [SubscriptionModel destroyAllUnsyched];
    [SubscriptionModel resetSyncFlag];
	for (int i = 0; i < [accounts count]; i++) {
        AccountModel* account = [accounts objectAtIndex:i];
        [account update];
        [RosterItemModel destroyAllByAccount:account];
        [ContactModel destroyAllByAccount:account];
        [[XMPPClientManager instance] openConnectionForAccount:account];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (UINavigationController*)createNavigationController:(UIViewController*)viewController {
    UINavigationController* navController = [[[UINavigationController alloc] initWithRootViewController:viewController] autorelease];
    navController.navigationBar.tintColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0];
    return navController;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (UITabBarController*)createTabBarController {
    UITabBarController* tabBarController = [[UITabBarController alloc] init];	
    UINavigationController* navRosterViewController = [self createNavigationController:self.rosterViewController];
    navRosterViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Roster" image:[UIImage imageNamed:@"tabbar-roster.png"] tag:1];
    UINavigationController* navPubSubViewController = [self createNavigationController:self.pubSubViewController];	
    navPubSubViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Events" image:[UIImage imageNamed:@"tabbar-events.png"] tag:2];
    UINavigationController* navServiceViewController = [self createNavigationController:self.serviceViewController];	
    navServiceViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Services" image:[UIImage imageNamed:@"tabbar-services.png"] tag:2];
    UINavigationController* navHistoryViewController = [self createNavigationController:self.historyViewController];	
    navHistoryViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"History" image:[UIImage imageNamed:@"tabbar-history.png"] tag:0];
    tabBarController.viewControllers = [NSArray arrayWithObjects:navRosterViewController, navPubSubViewController, navServiceViewController, navHistoryViewController, nil];	
    return tabBarController;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)createAccountManager {
    [AccountManagerViewController inView:window];
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
	[[XMPPClientManager instance] addDelegate:[[XMPPMessageDelegate alloc] init]];
	[[XMPPClientManager instance] addDelegate:self];
    [self openActivatedAccounts];
	[window addSubview:[self createTabBarController].view];	
    [AlertViewManager onStartshowConnectingIndicatorInView:window];
    NSInteger count = [AccountModel count];
    if (count == 0) {
        [self createAccountManager];
    }
    [window makeKeyAndVisible];
}

//===================================================================================================================================
#pragma mark UIAlertViewDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    AcceptBuddyRequestView* buddyRequestView = (AcceptBuddyRequestView*)alertView;
    if (buttonIndex == 0) {
        [XMPPPresence decline:buddyRequestView.xmppClient JID:buddyRequestView.buddyJid];        
    } else if (buttonIndex == 1) {
        [XMPPMessageDelegate acceptBuddyRequest:buddyRequestView.xmppClient JID:buddyRequestView.buddyJid];
    }
}

//===================================================================================================================================
#pragma mark NSobject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
	[super dealloc];
}

//===================================================================================================================================
#pragma mark XMPPClientDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceivePubSubSubscriptionsResult:(XMPPIQ *)iq {
    AccountModel* account = [AccountModel findFirstDisplayed];
    if (!account) {
        [self createAccountManager];
    }
}

//===================================================================================================================================
#pragma mark Message

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)sender didReceiveErrorPresence:(XMPPPresence*)presence {
    NSString* title = [[presence toJID] full];
    NSString* message = [[NSString alloc] initWithFormat:@"Error with contact '%@'", [[presence fromJID] full]];
    [AlertViewManager showAlert:title withMessage:message];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)sender didReceiveBuddyRequest:(XMPPJID*)buddyJid {
    AccountModel* account = [XMPPMessageDelegate accountForXMPPClient:sender];
    if (account) {
        ContactModel* contact = [ContactModel findByJid:[buddyJid bare] andAccount:account];	
        if (contact == nil) {
            AcceptBuddyRequestView* buddyRequestView = [[AcceptBuddyRequestView alloc] initWithClient:sender buddyJid:buddyJid andDelegate:self];
            [buddyRequestView show];	
            [buddyRequestView release];
        }
    }
}

@end
