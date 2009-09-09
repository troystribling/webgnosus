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

+ (CGFloat)getMessageHeight:(MessageModel*)message;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation BodyMessageCell

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize messageLabel;

//===================================================================================================================================
#pragma mark BodyMessageCell

//-----------------------------------------------------------------------------------------------------------------------------------
+ (CGFloat)tableView:(UITableView *)tableView heightForRowWithMessage:(MessageModel*)message {
	CGFloat cellHeight = [self getMessageHeight:message] + kMESSAGE_HEIGHT_PAD;
	return cellHeight;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath forMessage:(MessageModel*)message {        
    BodyMessageCell* cell = (BodyMessageCell*)[CellUtils createCell:[BodyMessageCell class] forTableView:tableView];
    [cell setJidAndTime:message];
    cell.messageLabel.text = message.messageText;
    CGRect messageLabelRect = cell.messageLabel.frame;
    messageLabelRect.size.height = [self getMessageHeight:message];
    cell.messageLabel.frame = messageLabelRect;
    return cell;
}

//===================================================================================================================================
#pragma mark BodyMessageCell PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
+ (CGFloat)getMessageHeight:(MessageModel*)message {
	CGFloat cellHeight = 20.0f;
    CGFloat width =  kDISPLAY_WIDTH;
    if (message.messageText) {
        CGSize textSize = {width, 20000.0f};
        CGSize size = [message.messageText sizeWithFont:[UIFont systemFontOfSize:kMESSAGE_FONT_SIZE] constrainedToSize:textSize 
                       lineBreakMode:UILineBreakModeWordWrap];
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
