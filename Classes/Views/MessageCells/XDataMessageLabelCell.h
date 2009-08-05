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
@protocol XDataMessageLabelGridView

@required

+ (NSMutableArray*)messageAttributes;

@optional

+ (void)initLabelGridView:(LabelGridView*)labelGridView;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XDataMessageLabelCell : MessageCell <XDataMessageLabelGridView> {
    IBOutlet UILabel* titleLabel;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UILabel* titleLabel;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)messageAttributesToHeader;
+ (NSString*)formatMessageAttribute:(NSString*)attr value:(NSString*)val;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (CGFloat)tableView:(UITableView *)tableView heightForRowWithMessage:(MessageModel*)message withHeader:(BOOL)withHeader;
+ (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath forMessage:(MessageModel*)message withHeader:(BOOL)withHeader;
@end
