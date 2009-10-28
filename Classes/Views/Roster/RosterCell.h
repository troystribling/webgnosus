//
//  ContactCell.h
//  webgnosus
//
//  Created by Troy Stribling on 1/20/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

//-----------------------------------------------------------------------------------------------------------------------------------
@class RosterItemModel;
@class ContactModel;
@class AccountModel;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface RosterCell : UITableViewCell {
	IBOutlet UILabel* jidLabel;
	IBOutlet UILabel* messageCountLabel;
    IBOutlet UIImageView* activeImage;
    IBOutlet UIImageView* messageCountImage;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UILabel* jidLabel;
@property (nonatomic, retain) UILabel* messageCountLabel;
@property (nonatomic, retain) UIImageView* activeImage;
@property (nonatomic, retain) UIImageView* messageCountImage;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UIImage*)rosterItemImage:(RosterItemModel*)rosterItem;
+ (UIImage*)contactImage:(ContactModel*)contact;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setUnreadMessageCount:(AccountModel*)account;

@end
