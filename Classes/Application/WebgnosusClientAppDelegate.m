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
#import "MessageModel.h"
#import "AlertViewManager.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface WebgnosusClientAppDelegate (PrivateAPI)

- (void)openActivatedAccounts;
- (UINavigationController*)createNavigationController:(UIViewController*)viewController;
- (void)accountConnectionFailedForClient:(XMPPClient*)sender;
- (void)createTabBarController;
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
@synthesize navRosterViewController;
@synthesize navPubSubViewController;
@synthesize navHistoryViewController;
@synthesize tabBarController;

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
    [ServiceModel destroyAll];
    [ServiceItemModel destroyAll];
    [ServiceFeatureModel destroyAll];
    [SubscriptionModel destroyAll];
	for (int i = 0; i < [accounts count]; i++) {
        AccountModel* account = [accounts objectAtIndex:i];
        [account update];
        [RosterItemModel destroyAllByAccount:account];
        [ContactModel destroyAllByAccount:account];
        [[XMPPClientManager instance] connectXmppClientForAccount:account];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (UINavigationController*)createNavigationController:(UIViewController*)viewController {
    UINavigationController* navController = [[[UINavigationController alloc] initWithRootViewController:viewController] autorelease];
    navController.navigationBar.tintColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    return navController;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)createTabBarController {
    self.navRosterViewController = [self createNavigationController:self.rosterViewController];
    self.navRosterViewController.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"Roster" image:[UIImage imageNamed:@"tabbar-roster.png"] tag:1] autorelease];
    self.navPubSubViewController = [self createNavigationController:self.pubSubViewController];	
    self.navPubSubViewController.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"Events" image:[UIImage imageNamed:@"tabbar-events.png"] tag:2] autorelease];
    UINavigationController* navServiceViewController = [self createNavigationController:self.serviceViewController];	
    navServiceViewController.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"Services" image:[UIImage imageNamed:@"tabbar-services.png"] tag:2] autorelease];
    self.navHistoryViewController = [self createNavigationController:self.historyViewController];	
    self.navHistoryViewController.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"History" image:[UIImage imageNamed:@"tabbar-history.png"] tag:0] autorelease];
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];	
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:self.navRosterViewController, self.navPubSubViewController, navServiceViewController, self.navHistoryViewController, nil];	
	[self.window addSubview:self.tabBarController.view];	
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)createAccountManager {
    [AccountManagerViewController inView:window];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setUnreadMessages {
    AccountModel* activeAccount = [AccountModel findFirstDisplayed];
    NSInteger msgCount = [MessageModel countUnreadMessagesByAccount:activeAccount];
    if (msgCount > 0) {
        self.navRosterViewController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", msgCount];
    } else {
        self.navRosterViewController.tabBarItem.badgeValue = nil;
    }
    NSInteger eventCount = [MessageModel countUnreadEventsByAccount:activeAccount];
    if (eventCount > 0) {
        self.navPubSubViewController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", eventCount];
    } else {
        self.navPubSubViewController.tabBarItem.badgeValue = nil;
    }
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
    [[XMPPClientManager instance] addMessageCountUpdateDelegate:self];
    [[XMPPClientManager instance] addAccountUpdateDelegate:self];
    [self createTabBarController];
    [self openActivatedAccounts];
    [AlertViewManager onStartshowConnectingIndicatorInView:window];
    NSInteger count = [AccountModel count];
    if (count == 0) {
        [self createAccountManager];
    }
    [self setUnreadMessages];
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
    [window release];
    [rosterViewController release];
    [pubSubViewController release];
    [historyViewController release];
    [serviceViewController release];
    [navRosterViewController release];
    [navPubSubViewController release];
    [navHistoryViewController release];
    [tabBarController release];
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
#pragma mark XMPPClientManagerMessageCountUpdateDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)messageCountDidChange {
    [self setUnreadMessages];
}

//===================================================================================================================================
#pragma mark XMPPClientManagerAccountUpdateDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)didAddAccount {
    [self setUnreadMessages];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)didRemoveAccount {
    [self setUnreadMessages];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)didUpdateAccount {
    [self setUnreadMessages];
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
