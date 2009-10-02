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
#import "XMPPxData.h"
#import "XDataScalarCell.h"
#import "XDataArrayCell.h"
#import "XDataHashCell.h"
#import "XDataArrayHashCell.h"
#import "MessageModel.h"
#import "UserModel.h"

//-----------------------------------------------------------------------------------------------------------------------------------
typedef enum tagCommandDataType {
    CommandDataText,
    CommandDataScalar,
    CommandDataArray,
    CommandDataHash,
    CommandDataArrayHash,
} CommandDataType;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface MessageCellFactory (PrivateAPI)

+ (UITableViewCell*)tableView:(UITableView*)tableView cellForCommandResponseAtIndexPath:(NSIndexPath*)indexPath forMessage:(MessageModel*)message;
+ (CGFloat)tableView:(UITableView*)tableView heightForCommandResponseWithMessage:(MessageModel*)message;
+ (CommandDataType)identifyCommandDataType:(XMPPxData*)data;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation MessageCellFactory

//-----------------------------------------------------------------------------------------------------------------------------------

//===================================================================================================================================
#pragma mark MessageCellFactory

//-----------------------------------------------------------------------------------------------------------------------------------
+ (CGFloat)tableView:(UITableView *)tableView heightForRowWithMessage:(MessageModel*)message {
	CGFloat cellHeight = kMESSAGE_HEIGHT_DEFAULT;
    if (message.textType == MessageTextTypeBody) {
        cellHeight = [BodyMessageCell tableView:tableView heightForRowWithMessage:message];
    } else if (message.textType ==  MessageTextTypeCommand) {
        cellHeight = [self tableView:tableView heightForCommandResponseWithMessage:message];
    } else {
        cellHeight = [BodyMessageCell tableView:tableView heightForRowWithMessage:message];
    }
	return cellHeight;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath forMessage:(MessageModel*)message {        
	UITableViewCell* cell = nil;
    if (message.textType == MessageTextTypeBody) {
        cell = [BodyMessageCell tableView:tableView cellForRowAtIndexPath:indexPath forMessage:message];
    } else if (message.textType ==  MessageTextTypeCommand) {
        cell = [self tableView:tableView cellForCommandResponseAtIndexPath:indexPath forMessage:message];
    } else {
        cell = [BodyMessageCell tableView:tableView cellForRowAtIndexPath:indexPath forMessage:message];
    }
	return cell;
}

//===================================================================================================================================
#pragma mark MessageCellFactory PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
+ (CGFloat)tableView:(UITableView*)tableView heightForCommandResponseWithMessage:(MessageModel*)message {
	CGFloat cellHeight = kMESSAGE_HEIGHT_DEFAULT;
    XMPPxData* data = [message parseXDataMessage];
    CommandDataType dataType = [self identifyCommandDataType:data];
    switch (dataType) {
        case CommandDataText:
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
+ (UITableViewCell*)tableView:(UITableView*)tableView cellForCommandResponseAtIndexPath:(NSIndexPath*)indexPath forMessage:(MessageModel*)message {
	UITableViewCell* cell = nil;
    XMPPxData* data = [message parseXDataMessage];
    CommandDataType dataType = [self identifyCommandDataType:data];
    switch (dataType) {
        case CommandDataText:
            cell = [BodyMessageCell tableView:tableView cellForRowAtIndexPath:indexPath forMessage:message];
            break;
        case CommandDataScalar:
            cell = [XDataScalarCell tableView:tableView cellForRowAtIndexPath:indexPath forMessage:message andData:data];
            break;
        case CommandDataArray:
            cell = [XDataArrayCell tableView:tableView cellForRowAtIndexPath:indexPath forMessage:message andData:data];
            break;
        case CommandDataHash:
            cell = [XDataHashCell tableView:tableView cellForRowAtIndexPath:indexPath forMessage:message andData:data];
            break;
        case CommandDataArrayHash:
            cell = [XDataArrayHashCell tableView:tableView cellForRowAtIndexPath:indexPath forMessage:message andData:data];
            break;
    }
    return cell;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (CommandDataType)identifyCommandDataType:(XMPPxData*)data {
    CommandDataType dataType = CommandDataText;
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

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
