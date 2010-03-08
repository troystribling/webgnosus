//
//  ResourceCell.h
//  webgnosus
//
//  Created by Troy Stribling on 3/7/10.
//  Copyright 2010 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

//-----------------------------------------------------------------------------------------------------------------------------------
@class AccountModel;
@class XMPPJID;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ResourceCell : UITableViewCell {
	IBOutlet UILabel* resourceLabel;
	IBOutlet UILabel* messageCountLabel;
    IBOutlet UIImageView* messageCountImage;
    XMPPJID* jid;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UILabel* resourceLabel;
@property (nonatomic, retain) UILabel* messageCountLabel;
@property (nonatomic, retain) UIImageView* messageCountImage;
@property (nonatomic, retain) XMPPJID* jid;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setUnreadMessageCount:(AccountModel*)account;

@end
