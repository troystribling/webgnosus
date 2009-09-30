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

+ (LabelGridView*)buildGridView:(MessageModel*)message;
+ (LabelGridView*)buildGridView:(MessageModel*)message withHeader:(BOOL)withHeader;
+ (NSMutableArray*)buildGridArrayWithHeader:(XMPPxData*)data;
+ (NSMutableArray*)buildGridArrayWithoutHeader:(XMPPxData*)data;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XDataMessageLabelCell

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize titleLabel;

//===================================================================================================================================
#pragma mark XDataMessageLabelCell

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)messageAttributes {
    return nil;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSString*)formatMessageAttribute:(NSString*)attr value:(NSString*)val {
    return val;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)messageAttributesToHeader {
    NSMutableArray* attrs = [self messageAttributes];
    NSMutableArray* header = [[NSMutableArray alloc] initWithCapacity:[attrs count]];
    for(int j = 0; j < [attrs count]; j++) {
        [header addObject:[[attrs objectAtIndex:j] stringByReplacingOccurrencesOfString:@"_" withString:@" "]];
    }
    return header;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (CGFloat)tableView:(UITableView *)tableView heightForRowWithMessage:(MessageModel*)message withHeader:(BOOL)withHeader {
    CGRect tableRect = [[self buildGridView:message withHeader:withHeader] frame];
	return tableRect.size.height + kXDATA_MESSAGE_CELL_HEIGHT_PAD;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath forMessage:(MessageModel*)message withHeader:(BOOL)withHeader {        
    XDataMessageLabelCell* cell = (XDataMessageLabelCell*)[CellUtils createCell:[XDataMessageLabelCell class] forTableView:tableView];
    [cell setJidAndTime:message];
    cell.titleLabel.text = [message.node stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    [cell addSubview:[self buildGridView:message withHeader:withHeader]];
    return cell;
}

//===================================================================================================================================
#pragma mark XDataMessageLabelCell PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
+ (LabelGridView*)buildGridView:(MessageModel*)message {
    return [self buildGridView:message withHeader:YES];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (LabelGridView*)buildGridView:(MessageModel*)message withHeader:(BOOL)withHeader {
    XMPPxData* data = [message parseXDataMessage];
    LabelGridView* gridView = nil;
    NSMutableArray* gridArray = nil;
	if (withHeader) {
        gridArray = [self buildGridArrayWithHeader:data];
        [gridArray insertObject:[self messageAttributesToHeader] atIndex:0];
	} else {
        gridArray = [self buildGridArrayWithoutHeader:data];
    }
    UIFont* labelFont = [UIFont fontWithName:[NSString stringWithUTF8String:kLABEL_GRID_FONT] size:kLABEL_GRID_FONT_SIZE];
    NSMutableArray* labelArray = [LabelGridView buildViews:gridArray labelOffSet:kLABEL_OFFSET labelHeight:kLABEL_GRID_HEIGHT andFont:labelFont];
    gridView = [[LabelGridView alloc] initWithLabelViews:labelArray borderWidth:kGRID_BORDER_WIDTH  maxWidth:kDISPLAY_WIDTH gridXOffset:kGRID_X_OFFSET andGridYOffset:kGRID_Y_OFFSET];
    [gridView setCellColor:[UIColor colorWithRed:0.94f green:0.94f blue:0.92f alpha:1.0f]];
    [gridView setBorderColor:[UIColor colorWithRed:0.8f green:0.8f blue:0.8f alpha:1.0f]]; 
	if (withHeader) {
        [gridView setHeaderColor:[UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1.0f]]; 
    }
	if ([self respondsToSelector:@selector(initLabelGridView:)] ) {
        [self initLabelGridView:gridView]; 
    }
    [gridArray release];
    [labelFont release];
    return gridView;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)buildGridArrayWithHeader:(XMPPxData*)data {
    NSMutableArray* itemsArray = [data items];
    NSMutableArray* gridArray = [[NSMutableArray alloc] initWithCapacity:[itemsArray count]];
    NSMutableArray* attrs = [self messageAttributes];
    for(int i = 0; i < [itemsArray count]; i++) {
        NSMutableDictionary* fieldHash = [itemsArray objectAtIndex:i];
        NSMutableArray* gridRow = [[NSMutableArray alloc] initWithCapacity:[fieldHash count]];
        for(int j = 0; j < [attrs count]; j++) {
            NSString* attr = [attrs objectAtIndex:j];
            [gridRow addObject:[self formatMessageAttribute:attr value:[[fieldHash objectForKey:attr] lastObject]]];
        }
        [gridArray addObject:gridRow];
    }
    [attrs release];
    return gridArray;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)buildGridArrayWithoutHeader:(XMPPxData*)data {
    NSMutableDictionary* fieldHash = [data fields];
    NSMutableArray* gridArray = [[NSMutableArray alloc] initWithCapacity:[fieldHash count]];
    NSMutableArray* attrs = [self messageAttributes];
    NSMutableArray* header = [self messageAttributesToHeader];
    for(int j = 0; j < [attrs count]; j++) {
        NSString* dataKey = [attrs objectAtIndex:j];
        NSString* headerValue = [header objectAtIndex:j];
        [gridArray addObject:[[NSMutableArray alloc] initWithObjects:headerValue, [[fieldHash objectForKey:dataKey] lastObject], nil]];
    }
    return gridArray;
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
