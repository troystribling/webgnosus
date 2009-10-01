//
//  XDataMessageLabelCell.h
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
@interface XDataMessageLabelCell : MessageCell {
    IBOutlet UILabel* titleLabel;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UILabel* titleLabel;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)removeUnderscores:(NSArray*)withUnderscores;
+ (NSString*)formatMessageAttribute:(NSString*)attr value:(NSString*)val;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (CGFloat)tableView:(UITableView *)tableView heightForData:(XMPPxData*)data;
+ (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath forMessage:(MessageModel*)message andData:(XMPPxData*)data;
@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface NSObject (XDataMessageLabelCell)

+ (NSMutableArray*)buildGridArray:(XMPPxData*)data;
+ (void)initLabelGridView:(LabelGridView*)labelGridView;

@end

