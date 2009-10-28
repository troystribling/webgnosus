//
//  AccountSubCell.h
//  webgnosus
//
//  Created by Troy Stribling on 9/8/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

//-----------------------------------------------------------------------------------------------------------------------------------
@class TouchImageView;
@class SubscriptionModel;
@class AccountModel;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface AccountSubCell : UITableViewCell {
	IBOutlet UILabel* itemLabel;
	IBOutlet UILabel* messageCountLabel;
	IBOutlet UILabel* jidLabel;
    IBOutlet UIImageView* messageCountImage;
    TouchImageView* itemImage;
    AccountModel* account;
    SubscriptionModel* subscription;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UILabel* itemLabel;
@property (nonatomic, retain) UILabel* messageCountLabel;
@property (nonatomic, retain) UILabel* jidLabel;
@property (nonatomic, retain) UIImageView* messageCountImage;
@property (nonatomic, retain) TouchImageView* itemImage;
@property (nonatomic, retain) AccountModel* account;
@property (nonatomic, retain) SubscriptionModel* subscription;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setUnreadMessageCount;

@end
