//
//  BodyMessageCell.h
//  webgnosus_client
//
//  Created by Troy Stribling on 2/27/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>
#import "MessageCell.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@class MessageModel;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface BodyMessageCell : MessageCell {
    IBOutlet UILabel* messageLabel;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UILabel* messageLabel;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (CGFloat)tableView:(UITableView *)tableView heightForRowWithMessage:(MessageModel*)message;
+ (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath forMessage:(MessageModel*)message;

@end
