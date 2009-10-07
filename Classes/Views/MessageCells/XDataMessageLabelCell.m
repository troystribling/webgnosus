//
//  XDataMessageLabelCell.m
//  webgnosus
//
//  Created by Troy Stribling on 4/16/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XDataMessageLabelCell.h"
#import "LabelGridView.h"
#import "MessageCell.h"
#import "MessageModel.h"
#import "CellUtils.h"
#import "XMPPxData.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XDataMessageLabelCell (PrivateAPI)

+ (LabelGridView*)buildGridView:(XMPPxData*)message;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XDataMessageLabelCell

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize titleLabel;

//===================================================================================================================================
#pragma mark XDataMessageLabelCell

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSString*)formatMessageAttribute:(NSString*)attr value:(NSString*)val {
    return val;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSString*)humanizeString:(NSString*)nonHuman {
    return [nonHuman stringByReplacingOccurrencesOfString:@"_" withString:@" "];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSString*)stringifyArray:(NSArray*)stringArray {
    NSString* stringified;
    stringified = [stringArray componentsJoinedByString:@","];
    return stringified;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (CGFloat)tableView:(UITableView *)tableView heightForData:(XMPPxData*)data {
    LabelGridView* labelGridView = [self buildGridView:data];
    CGRect tableRect = [labelGridView frame];
	return tableRect.size.height + kXDATA_MESSAGE_CELL_HEIGHT_PAD;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath forMessage:(MessageModel*)message andData:(XMPPxData*)data fromJid:(NSString*)jid {        
    XDataMessageLabelCell* cell = (XDataMessageLabelCell*)[CellUtils createCell:[XDataMessageLabelCell class] forTableView:tableView];
    [self set:cell Jid:jid];
    [self setTime:cell forMessage:message];
    cell.titleLabel.text = [message.node stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    LabelGridView* labelGridView = [self buildGridView:data];
    [cell addSubview:labelGridView];
    return cell;
}

//===================================================================================================================================
#pragma mark XDataMessageLabelCell PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
+ (LabelGridView*)buildGridView:(XMPPxData*)data {
    NSMutableArray* gridArray = [self buildGridArray:data];
    UIFont* labelFont = [UIFont fontWithName:[NSString stringWithUTF8String:kLABEL_GRID_FONT] size:kLABEL_GRID_FONT_SIZE];
    NSMutableArray* labelArray = [LabelGridView buildViews:gridArray labelOffSet:kLABEL_OFFSET labelHeight:kLABEL_GRID_HEIGHT andFont:labelFont];
    LabelGridView* labelGridView = [[LabelGridView alloc] initWithLabelViews:labelArray borderWidth:kGRID_BORDER_WIDTH  maxWidth:kDISPLAY_WIDTH gridXOffset:kGRID_X_OFFSET andGridYOffset:kGRID_Y_OFFSET];
    [labelGridView setCellColor:[UIColor colorWithRed:0.94f green:0.94f blue:0.92f alpha:1.0f]];
    [labelGridView setBorderColor:[UIColor colorWithRed:0.8f green:0.8f blue:0.8f alpha:1.0f]]; 
	if ([self respondsToSelector:@selector(initLabelGridView:)] ) {
        [self initLabelGridView:labelGridView]; 
    }
    return labelGridView;
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
