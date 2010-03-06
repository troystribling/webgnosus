//
//  XDataMessageCell.m
//  webgnosus
//
//  Created by Troy Stribling on 4/16/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XDataMessageCell.h"
#import "LabelGridView.h"
#import "MessageCell.h"
#import "MessageModel.h"
#import "MessageViewFactory.h"
#import "CellUtils.h"
#import "XMPPxData.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XDataMessageCell (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XDataMessageCell

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize nodeLabel;

//===================================================================================================================================
#pragma mark XDataMessageCell

//-----------------------------------------------------------------------------------------------------------------------------------
+ (CGFloat)tableView:(UITableView *)tableView heightForRowWithMessage:(MessageModel*)message {
    UIView* dataView = [MessageViewFactory viewForMessage:message];
    CGRect dataRect = [dataView frame];
	return dataRect.size.height + kXDATA_MESSAGE_CELL_HEIGHT_PAD;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath forMessage:(MessageModel*)message fromJid:(NSString*)jid {  
    XDataMessageCell* cell = (XDataMessageCell*)[CellUtils createCell:[XDataMessageCell class] forTableView:tableView];
    [self set:cell Jid:jid];
    [self setTime:cell forMessage:message];
    cell.nodeLabel.text = [message.node stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    UIView* dataView = [MessageViewFactory viewForMessage:message];
    CGRect dataRect = [dataView frame];
    UIView* container = [[UIView alloc] initWithFrame:CGRectMake(kXDATA_MESSAGE_CELL_X_OFFSET, kXDATA_MESSAGE_CELL_Y_OFFSET, dataRect.size.width,  dataRect.size.width)];
    [container addSubview:dataView];
    [cell addSubview:container];
    return cell;
}

//===================================================================================================================================
#pragma mark XDataMessageCell PrivateAPI

//===================================================================================================================================
#pragma mark UITableViewCell

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
