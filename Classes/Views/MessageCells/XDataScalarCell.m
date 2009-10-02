//
//  XDataScalarCell.m
//  webgnosus
//
//  Created by Troy Stribling on 9/28/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XDataScalarCell.h"
#import "XMPPxData.h"
#import "MessageCell.h"
#import "MessageModel.h"
#import "CellUtils.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XDataScalarCell (PrivateAPI)

+ (CGFloat)getMessageHeight:(XMPPxData*)data;
+ (NSString*)getLabel:(XMPPxData*)data;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XDataScalarCell

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize messageLabel;
@synthesize titleLabel;

//===================================================================================================================================
#pragma mark XDataScalarCell

//-----------------------------------------------------------------------------------------------------------------------------------
+ (CGFloat)tableView:(UITableView *)tableView heightForRowWithMessage:(MessageModel*)message andData:(XMPPxData*)data {
	CGFloat cellHeight = [self getMessageHeight:data] + kXDATA_MESSAGE_CELL_HEIGHT_PAD;
	return cellHeight;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath forMessage:(MessageModel*)message andData:(XMPPxData*)data {        
    XDataScalarCell* cell = (XDataScalarCell*)[CellUtils createCell:[XDataScalarCell class] forTableView:tableView];
    [cell setJidAndTime:message];
    cell.titleLabel.text = message.node;
    cell.messageLabel.text = [self getLabel:data];
    CGRect messageLabelRect = cell.messageLabel.frame;
    messageLabelRect.size.height = [self getMessageHeight:data];
    cell.messageLabel.frame = messageLabelRect;
    return cell;
}

//===================================================================================================================================
#pragma mark XDataScalarCell PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
+ (CGFloat)getMessageHeight:(XMPPxData*)data {
	CGFloat cellHeight = 20.0f;
    CGFloat width =  kDISPLAY_WIDTH;
    NSString* label = [self getLabel:data];
    if (label) {
        CGSize textSize = {width, 20000.0f};
        CGSize size = [label sizeWithFont:[UIFont systemFontOfSize:kMESSAGE_FONT_SIZE] constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
        cellHeight = MAX(size.height, cellHeight);
    }    
	return cellHeight;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSString*)getLabel:(XMPPxData*)data {
    return [[[[data fields] lastObject] lastObject] lastObject];
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
