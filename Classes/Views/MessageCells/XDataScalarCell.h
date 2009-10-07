//
//  XDataScalarCell.h
//  webgnosus
//
//  Created by Troy Stribling on 9/28/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>
#import "MessageCell.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@class XMPPxData;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XDataScalarCell : MessageCell {
    IBOutlet UILabel* titleLabel;
    IBOutlet UILabel* messageLabel;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UILabel* messageLabel;
@property (nonatomic, retain) UILabel* titleLabel;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (CGFloat)tableView:(UITableView *)tableView heightForRowWithMessage:(MessageModel*)message andData:(XMPPxData*)data;
+ (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath forMessage:(MessageModel*)message andData:(XMPPxData*)data fromJid:(NSString*)jid;

@end
