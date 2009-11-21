//
//  ServiceCell.h
//  webgnosus
//
//  Created by Troy Stribling on 10/11/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

//-----------------------------------------------------------------------------------------------------------------------------------
@class TouchImageView;
@class ServiceModel;
@class AccountModel;
@class SubscriptionModel;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ServiceCell : UITableViewCell {
	IBOutlet UILabel* itemLabel;
    TouchImageView* itemImage;
    AccountModel* account;
    ServiceModel* service;
    NSArray* subscriptions;
    BOOL enableImageTouch;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UILabel* itemLabel;
@property (nonatomic, retain) TouchImageView* itemImage;
@property (nonatomic, retain) AccountModel* account;
@property (nonatomic, retain) ServiceModel* service;
@property (nonatomic, retain) NSArray* subscriptions;
@property (nonatomic, assign) BOOL enableImageTouch;

//-----------------------------------------------------------------------------------------------------------------------------------

@end
