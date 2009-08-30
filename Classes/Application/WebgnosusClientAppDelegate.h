//
//  WebgnosusClientAppDelegate.h
//  webgnosus
//
//  Created by Troy Stribling on 1/1/09.
//  Copyright Plan-B Research 2009. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

//-----------------------------------------------------------------------------------------------------------------------------------
@class RosterViewController;
@class AccountManagerViewController;
@class HistoryViewController;
@class EditAccountViewController;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface WebgnosusClientAppDelegate : NSObject <UIApplicationDelegate, UIAlertViewDelegate> {
    IBOutlet UIWindow* window;
    IBOutlet RosterViewController* rosterViewController;
    IBOutlet AccountManagerViewController* accountManagerViewController;
    IBOutlet EditAccountViewController* editAccountViewController;
	IBOutlet HistoryViewController* historyViewController;

    UITabBarController* tabBarController;
    UINavigationController* navAccountsViewController;
    UINavigationController* navEditAccountViewController;
    UINavigationController* navRosterViewController;	
    UINavigationController* navHistoryViewController;	
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UIWindow* window;
@property (nonatomic, retain) AccountManagerViewController* accountManagerViewController;
@property (nonatomic, retain) EditAccountViewController* editAccountViewController;;
@property (nonatomic, retain) RosterViewController* rosterViewController;
@property (nonatomic, retain) HistoryViewController* historyViewController;

@property (nonatomic, retain) UITabBarController* tabBarController;
@property (nonatomic, retain) UINavigationController* navAccountsViewController;
@property (nonatomic, retain) UINavigationController* navEditAccountViewController;
@property (nonatomic, retain) UINavigationController* navRosterViewController;
@property (nonatomic, retain) UINavigationController* navHistoryViewController;

//-----------------------------------------------------------------------------------------------------------------------------------

@end

