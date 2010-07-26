//
//  AlertViewManager.h
//  webgnosus
//
//  Created by Troy Stribling on 8/11/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "AccountModel.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@class AccountModel;
@class ActivityView;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface AlertViewManager : NSObject 

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)dismissActivityIndicator;
+ (ActivityView*)activityIndicatorIndicator;
+ (void)showActivityIndicatorInView:(UIView*)view withTitle:(NSString*)title;
+ (void)onStartDismissConnectionIndicatorAndShowErrors;
+ (void)onStartshowConnectingIndicatorInView:(UIView*)view;
+ (void)showAlertsForConnectionState:(AccountConnectionState)state titled:(NSString*)title;
+ (void)showAlert:(NSString*)title;
+ (void)showAlert:(NSString*)title withMessage:(NSString*)message;

@end
