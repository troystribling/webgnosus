//
//  AccountCell.h
//  webgnosus_client
//
//  Created by Troy Stribling on 1/11/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

//-----------------------------------------------------------------------------------------------------------------------------------
@class AccountsViewController;
@class AccountModel;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface AccountCell : UITableViewCell {
	IBOutlet UILabel* jidLabel;
    IBOutlet UIImageView* connectedImage;
	AccountsViewController* accountsViewController;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UILabel* jidLabel;
@property (nonatomic, retain) UIImageView* connectedImage;
@property (nonatomic, retain) AccountsViewController* accountsViewController;

//-----------------------------------------------------------------------------------------------------------------------------------

@end
