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
#import "MessageViewFactory.h"
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
+ (CGFloat)tableView:(UITableView *)tableView heightForRowWithMessage:(MessageModel*)message {
    UIView* msgView = [MessageViewFactory viewForMessage:message];
    CGRect msgRect = [msgView frame];
	return msgRect.size.height + kMESSAGE_CELL_HEIGHT_PAD;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath forMessage:(MessageModel*)message fromJid:(NSString*)jid {        
    BodyMessageCell* cell = (BodyMessageCell*)[CellUtils createCell:[BodyMessageCell class] forTableView:tableView];
    [self set:cell Jid:jid];
    [self setTime:cell forMessage:message];
    UIView* msgView = [MessageViewFactory viewForMessage:message];
    CGRect msgRect = msgView.frame;
    UIView* container = [[[UIView alloc] initWithFrame:CGRectMake(kMESSAGE_CELL_X_OFFSET, kMESSAGE_CELL_Y_OFFSET, msgRect.size.width,  msgRect.size.width)] autorelease];
    [container addSubview:msgView];
    [cell addSubview:container];
    return cell;
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
