//
//  XDataMessageCell.h
//  webgnosus
//
//  Created by Troy Stribling on 4/16/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>
#import "MessageCell.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@class LabelGridView;
@class XMPPxData;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XDataMessageCell : MessageCell {
    IBOutlet UILabel* titleLabel;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UILabel* titleLabel;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (CGFloat)tableView:(UITableView *)tableView heightForRowWithMessage:(MessageModel*)message;
+ (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath forMessage:(MessageModel*)message fromJid:(NSString*)jid;

@end

