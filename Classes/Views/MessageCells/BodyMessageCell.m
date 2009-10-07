//
//  BodyMessageCell.m
//  webgnosus
//
//  Created by Troy Stribling on 2/27/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "BodyMessageCell.h"
#import "MessageCell.h"
#import "MessageModel.h"
#import "CellUtils.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface BodyMessageCell (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation BodyMessageCell

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize messageLabel;

//===================================================================================================================================
#pragma mark BodyMessageCell

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSString*)getMessageText:(MessageModel*)message {
    return message.messageText;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (CGFloat)tableView:(UITableView *)tableView heightForRowWithMessage:(MessageModel*)message {
	CGFloat cellHeight = [self getMessageHeight:[self getMessageText:message]] + kMESSAGE_HEIGHT_PAD;
	return cellHeight;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath forMessage:(MessageModel*)message { 
    return [self tableView:tableView cellForRowAtIndexPath:indexPath forMessage:message fromJid:[message fromJid]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath forMessage:(MessageModel*)message fromJid:(NSString*)jid {        
    BodyMessageCell* cell = (BodyMessageCell*)[CellUtils createCell:[BodyMessageCell class] forTableView:tableView];
    [self set:cell Jid:jid];
    [self setTime:cell forMessage:message];
    cell.messageLabel.text = [self getMessageText:message];
    CGRect messageLabelRect = cell.messageLabel.frame;
    messageLabelRect.size.height = [self getMessageHeight:[self getMessageText:message]];
    cell.messageLabel.frame = messageLabelRect;
    return cell;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (CGFloat)getMessageHeight:(NSString*)messageText {
	CGFloat cellHeight = 20.0f;
    CGFloat width =  kDISPLAY_WIDTH;
    if (messageText) {
        CGSize textSize = {width, 20000.0f};
        CGSize size = [messageText sizeWithFont:[UIFont systemFontOfSize:kMESSAGE_FONT_SIZE] constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
        cellHeight = MAX(size.height, cellHeight);
    }    
	return cellHeight;
}

//===================================================================================================================================
#pragma mark UITableViewCell

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
