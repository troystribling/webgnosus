//
//  ContactCell.h
//  webgnosus_client
//
//  Created by Troy Stribling on 1/20/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

//-----------------------------------------------------------------------------------------------------------------------------------
@class RosterItemModel;
@class ContactModel;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface RosterCell : UITableViewCell {
	IBOutlet UILabel* jidLabel;
    IBOutlet UIImageView* activeImage;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UILabel* jidLabel;
@property (nonatomic, retain) UIImageView* activeImage;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UIImage*)rosterItemImage:(RosterItemModel*)rosterItem;
+ (UIImage*)contactImage:(ContactModel*)contact;

//-----------------------------------------------------------------------------------------------------------------------------------

@end
