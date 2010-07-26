//
//  AlertViewManager.m
//  webgnosus
//
//  Created by Troy Stribling on 8/11/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "AlertViewManager.h"
#import "ActivityView.h"

//-----------------------------------------------------------------------------------------------------------------------------------
static ActivityView* ActivityIndicatorView = nil;
static BOOL DismissConnectionIndicatorOnStart = YES;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface AlertViewManager (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation AlertViewManager

//-----------------------------------------------------------------------------------------------------------------------------------

//===================================================================================================================================
#pragma mark AlertViewManager

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)dismissActivityIndicator { 
    if (ActivityIndicatorView) {
        [ActivityIndicatorView dismiss]; 
        [ActivityIndicatorView release];
        ActivityIndicatorView = nil;
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (ActivityView*)activityIndicatorIndicator { 
    return ActivityIndicatorView;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)showActivityIndicatorInView:(UIView*)view withTitle:(NSString*)title {
    if (!ActivityIndicatorView) {
        ActivityIndicatorView = [[ActivityView alloc] initWithTitle:title inView:view];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)onStartshowConnectingIndicatorInView:(UIView*)view {
    if ([AccountModel activateCount] == 0) {
        DismissConnectionIndicatorOnStart = NO;
    }
    if (DismissConnectionIndicatorOnStart) {
        [self showActivityIndicatorInView:view withTitle:@"Connecting"];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)onStartDismissConnectionIndicatorAndShowErrors {
    if (DismissConnectionIndicatorOnStart) {
        if ([AccountModel triedToConnectAll]) {
            [self dismissActivityIndicator]; 
            [self showAlertsForConnectionState:AccountConnectionError titled:@"Connection Failed"];
            [self showAlertsForConnectionState:AccountAuthenticationError titled:@"Authentication Failed"];
            [self showAlertsForConnectionState:AccountRosterUpdateError titled:@"Roster Update Failed"];
            [self showAlertsForConnectionState:AccountDiscoError titled:@"Disco Failed"];
            [self showAlertsForConnectionState:AccountSubscriptionsUpdateError titled:@"Subscriptions Update Failed"];
            DismissConnectionIndicatorOnStart = NO;
        }
    } 
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)showAlertsForConnectionState:(AccountConnectionState)state titled:(NSString*)title {
    NSMutableArray* accounts = [AccountModel findAllActivatedByConnectionState:state];
    for (int i = 0; i < [accounts count]; i++) {
        AccountModel* account = [accounts objectAtIndex:i];
        [self showAlert:title withMessage:[[NSString alloc] initWithFormat:@"%@", [account fullJID]]];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)showAlert:(NSString*)title {
    [self showAlert:title withMessage:@""];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)showAlert:(NSString*)title withMessage:(NSString*)message {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];	
    [alert release];
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
