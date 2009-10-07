//
//  MessageCellFactory.m
//  webgnosus
//
//  Created by Troy Stribling on 2/27/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "MessageCellFactory.h"
#import "BodyMessageCell.h"
#import "EntryCell.h"
#import "XMPPxData.h"
#import "XDataScalarCell.h"
#import "XDataArrayCell.h"
#import "XDataHashCell.h"
#import "XDataArrayHashCell.h"
#import "MessageModel.h"
#import "UserModel.h"

//-----------------------------------------------------------------------------------------------------------------------------------
typedef enum tagCommandDataType {
    CommandDataUnknown,
    CommandDataScalar,
    CommandDataArray,
    CommandDataHash,
    CommandDataArrayHash,
} CommandDataType;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface MessageCellFactory (PrivateAPI)

+ (CGFloat)tableView:(UITableView*)tableView heightForXDataWithMessage:(MessageModel*)message;
+ (UITableViewCell*)tableView:(UITableView*)tableView cellForXDataAtIndexPath:(NSIndexPath*)indexPath forMessage:(MessageModel*)message fromJid:(NSString*)jid;
+ (CommandDataType)identifyXDataType:(XMPPxData*)data;
+ (NSString*)jidFromNode:(NSString*)node;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation MessageCellFactory

//-----------------------------------------------------------------------------------------------------------------------------------

//===================================================================================================================================
#pragma mark MessageCellFactory

//-----------------------------------------------------------------------------------------------------------------------------------
+ (CGFloat)tableView:(UITableView *)tableView heightForRowWithMessage:(MessageModel*)message {
	CGFloat cellHeight = kMESSAGE_HEIGHT_DEFAULT;
    if (message.textType ==  MessageTextTypeCommandXData) {
        cellHeight = [self tableView:tableView heightForXDataWithMessage:message];
    } else if (message.textType ==  MessageTextTypeEventxData) {
        cellHeight = [self tableView:tableView heightForXDataWithMessage:message];
    } else if (message.textType ==  MessageTextTypeEventEntry) {
        cellHeight = [EntryCell tableView:tableView heightForRowWithMessage:message];
    } else if (message.textType ==  MessageTextTypeEventText) {
        cellHeight = [BodyMessageCell tableView:tableView heightForRowWithMessage:message];
    } else {
        cellHeight = [BodyMessageCell tableView:tableView heightForRowWithMessage:message];
    }
	return cellHeight;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath forMessage:(MessageModel*)message {        
	UITableViewCell* cell = nil;
    if (message.textType ==  MessageTextTypeCommandXData) {
        cell = [self tableView:tableView cellForXDataAtIndexPath:indexPath forMessage:message fromJid:message.fromJid];
    } else if (message.textType ==  MessageTextTypeEventxData) {
        cell = [self tableView:tableView cellForXDataAtIndexPath:indexPath forMessage:message fromJid:[self jidFromNode:message.node]];
    } else if (message.textType ==  MessageTextTypeEventEntry) {
        cell = [EntryCell tableView:tableView cellForRowAtIndexPath:indexPath forMessage:message fromJid:[self jidFromNode:message.node]];
    } else if (message.textType ==  MessageTextTypeEventText) {
        cell = [BodyMessageCell tableView:tableView cellForRowAtIndexPath:indexPath forMessage:message fromJid:[self jidFromNode:message.node]];
    } else {
        cell = [BodyMessageCell tableView:tableView cellForRowAtIndexPath:indexPath forMessage:message];
    }
	return cell;
}

//===================================================================================================================================
#pragma mark MessageCellFactory PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
+ (CGFloat)tableView:(UITableView*)tableView heightForXDataWithMessage:(MessageModel*)message {
	CGFloat cellHeight = kMESSAGE_HEIGHT_DEFAULT;
    XMPPxData* data = [message parseXDataMessage];
    CommandDataType dataType = [self identifyXDataType:data];
    switch (dataType) {
        case CommandDataUnknown:
            cellHeight = [BodyMessageCell tableView:tableView heightForRowWithMessage:message];
            break;
        case CommandDataScalar:
            cellHeight = [XDataScalarCell tableView:tableView heightForRowWithMessage:message andData:data];
            break;
        case CommandDataArray:
            cellHeight = [XDataArrayCell tableView:tableView heightForData:data];
            break;
        case CommandDataHash:
            cellHeight = [XDataHashCell tableView:tableView heightForData:data];
            break;
        case CommandDataArrayHash:
            cellHeight = [XDataArrayHashCell tableView:tableView heightForData:data];
            break;
    }
    return cellHeight;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UITableViewCell*)tableView:(UITableView*)tableView cellForXDataAtIndexPath:(NSIndexPath*)indexPath forMessage:(MessageModel*)message fromJid:(NSString*)jid {
	UITableViewCell* cell = nil;
    XMPPxData* data = [message parseXDataMessage];
    CommandDataType dataType = [self identifyXDataType:data];
    switch (dataType) {
        case CommandDataUnknown:
            cell = [BodyMessageCell tableView:tableView cellForRowAtIndexPath:indexPath forMessage:message fromJid:jid];
            break;
        case CommandDataScalar:
            cell = [XDataScalarCell tableView:tableView cellForRowAtIndexPath:indexPath forMessage:message andData:data fromJid:jid];
            break;
        case CommandDataArray:
            cell = [XDataArrayCell tableView:tableView cellForRowAtIndexPath:indexPath forMessage:message andData:data fromJid:jid];
            break;
        case CommandDataHash:
            cell = [XDataHashCell tableView:tableView cellForRowAtIndexPath:indexPath forMessage:message andData:data fromJid:jid];
            break;
        case CommandDataArrayHash:
            cell = [XDataArrayHashCell tableView:tableView cellForRowAtIndexPath:indexPath forMessage:message andData:data fromJid:jid];
            break;
    }
    return cell;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (CommandDataType)identifyXDataType:(XMPPxData*)data {
    CommandDataType dataType = CommandDataUnknown;
    if (data) {
        NSInteger fields = [[data fields] count];
        NSInteger items = [[data items] count];
        if (fields == 1) {
            NSInteger vals = [[[[data fields] objectAtIndex:0] lastObject] count];
            if (vals > 1) {
                dataType = CommandDataArray;
            } else {
                dataType = CommandDataScalar;
            }
        } else if (fields > 1) {
            dataType = CommandDataHash;
        } else if (items > 0) {
            dataType = CommandDataArrayHash;
        }
    }    
    return dataType;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSString*)jidFromNode:(NSString*)node {
    NSArray* jidElements = [node componentsSeparatedByString:@"/"];
    return [NSString stringWithFormat:@"%@@%@", [jidElements objectAtIndex:3], [jidElements objectAtIndex:2]];
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
