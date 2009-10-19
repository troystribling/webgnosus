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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ContactPubCell : UITableViewCell {
	IBOutlet UILabel* itemLabel;
    TouchImageView* itemImage;
    AccountModel* account;
    ServiceItemModel* serviceItem;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UILabel* itemLabel;
@property (nonatomic, retain) TouchImageView* itemImage;
@property (nonatomic, retain) AccountModel* account;
@property (nonatomic, retain) ServiceItemModel* serviceItem;

//-----------------------------------------------------------------------------------------------------------------------------------

@end
