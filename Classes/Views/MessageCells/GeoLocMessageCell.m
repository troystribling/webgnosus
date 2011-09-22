//
//  GeoLocMessageCell.m
//  webgnosus
//
//  Created by Troy Stribling on 8/7/10.
//  Copyright 2010 Plan-B Reserach. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "GeoLocMessageCell.h"
#import "MessageViewFactory.h"
#import "CellUtils.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface GeoLocMessageCell (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation GeoLocMessageCell

//===================================================================================================================================
#pragma mark GeoLocMessageCell

//-----------------------------------------------------------------------------------------------------------------------------------
+ (CGFloat)tableView:(UITableView *)tableView heightForRowWithMessage:(MessageModel*)message {
    UIView* dataView = [MessageViewFactory viewForMessage:message];
    CGRect dataRect = [dataView frame];
	return dataRect.size.height + kGEOLOC_MESSAGE_CELL_HEIGHT_PAD;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath forMessage:(MessageModel*)message fromJid:(NSString*)jid {  
    GeoLocMessageCell* cell = (GeoLocMessageCell*)[CellUtils createCell:[GeoLocMessageCell class] forTableView:tableView];
    [self set:cell Jid:jid];
    [self setTime:cell forMessage:message];
    UIView* dataView = [MessageViewFactory viewForMessage:message];
    CGRect dataRect = [dataView frame];
    UIView* container = [[[UIView alloc] initWithFrame:CGRectMake(kGEOLOC_MESSAGE_CELL_X_OFFSET, kGEOLOC_MESSAGE_CELL_Y_OFFSET, dataRect.size.width,  dataRect.size.width)] autorelease];
    [container addSubview:dataView];
    [cell addSubview:container];
    return cell;
}

//===================================================================================================================================
#pragma mark XDataMessageCell PrivateAPI

@end
