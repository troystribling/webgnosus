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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface AlertViewManager : NSObject 

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)dismissConnectionIndicator;
+ (ActivityView*)connectingIndicator;
+ (void)showConnectingIndicatorInView:(UIView*)view;
+ (void)onStartDismissConnectionIndicatorAndShowErrors;
+ (void)onStartshowConnectingIndicatorInView:(UIView*)view;
+ (void)showAlertsForConnectionState:(AccountConnectionState)state titled:(NSString*)title;
+ (void)showAlert:(NSString*)title;
+ (void)showAlert:(NSString*)title withMessage:(NSString*)message;

@end
