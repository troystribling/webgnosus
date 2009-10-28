//
//  ContactPubCell.h
//  webgnosus
//
//  Created by Troy Stribling on 10/1/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

//-----------------------------------------------------------------------------------------------------------------------------------
@class TouchImageView;
@class ServiceItemModel;
@class AccountModel;
@class SubscriptionModel;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ContactPubCell : UITableViewCell {
	IBOutlet UILabel* itemLabel;
	IBOutlet UILabel* messageCountLabel;
    IBOutlet UIImageView* messageCountImage;
    TouchImageView* itemImage;
    AccountModel* account;
    ServiceItemModel* serviceItem;
    SubscriptionModel* subscription;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UILabel* itemLabel;
@property (nonatomic, retain) UILabel* messageCountLabel;
@property (nonatomic, retain) UIImageView* messageCountImage;
@property (nonatomic, retain) TouchImageView* itemImage;
@property (nonatomic, retain) AccountModel* account;
@property (nonatomic, retain) ServiceItemModel* serviceItem;
@property (nonatomic, retain) SubscriptionModel* subscription;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setUnreadMessageCount;

@end
