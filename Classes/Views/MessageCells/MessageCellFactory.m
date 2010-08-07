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
#import "XDataMessageCell.h"
#import "GeoLocMessageCell.h"
#import "XMPPxData.h"
#import "XMPPJID.h"
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

+ (NSString*)jidFromNode:(NSString*)node;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation MessageCellFactory

//-----------------------------------------------------------------------------------------------------------------------------------

//===================================================================================================================================
#pragma mark MessageCellFactory

//-----------------------------------------------------------------------------------------------------------------------------------
+ (CGFloat)tableView:(UITableView *)tableView heightForRowWithMessage:(MessageModel*)message {
	CGFloat cellHeight = kMESSAGE_CELL_HEIGHT_DEFAULT;
    if (message.textType ==  MessageTextTypeCommandXData) {
        cellHeight = [XDataMessageCell tableView:tableView heightForRowWithMessage:message];
    } else if (message.textType ==  MessageTextTypeEventxData) {
        cellHeight = [XDataMessageCell tableView:tableView heightForRowWithMessage:message];
    } else if (message.textType ==  MessageTextTypeEventEntry) {
        cellHeight = [XDataMessageCell tableView:tableView heightForRowWithMessage:message];
    } else if (message.textType ==  MessageTextTypeEventText) {
        cellHeight = [XDataMessageCell tableView:tableView heightForRowWithMessage:message];
    } else if (message.textType ==  MessageTextTypeGeoLocData) {
        cellHeight = [GeoLocMessageCell tableView:tableView heightForRowWithMessage:message];
    } else {
        cellHeight = [BodyMessageCell tableView:tableView heightForRowWithMessage:message];
    }
	return cellHeight;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath forMessage:(MessageModel*)message {        
	UITableViewCell* cell = nil;
    if (message.textType ==  MessageTextTypeCommandXData) {
        cell = [XDataMessageCell tableView:tableView cellForRowAtIndexPath:indexPath forMessage:message fromJid:[[XMPPJID jidWithString:message.fromJid] bare]];
    } else if (message.textType ==  MessageTextTypeEventxData) {
        cell = [XDataMessageCell tableView:tableView cellForRowAtIndexPath:indexPath forMessage:message fromJid:[self jidFromNode:message.node]];
    } else if (message.textType ==  MessageTextTypeEventEntry) {
        cell = [XDataMessageCell tableView:tableView cellForRowAtIndexPath:indexPath forMessage:message fromJid:[self jidFromNode:message.node]];
    } else if (message.textType ==  MessageTextTypeEventText) {
        cell = [XDataMessageCell tableView:tableView cellForRowAtIndexPath:indexPath forMessage:message fromJid:[self jidFromNode:message.node]];
    } else if (message.textType ==  MessageTextTypeGeoLocData) {
        cell = [GeoLocMessageCell tableView:tableView cellForRowAtIndexPath:indexPath forMessage:message fromJid:[[XMPPJID jidWithString:message.fromJid] bare]];
    } else {
        cell = [BodyMessageCell tableView:tableView cellForRowAtIndexPath:indexPath forMessage:message fromJid:[[XMPPJID jidWithString:message.fromJid] bare]];
    }
	return cell;
}

//===================================================================================================================================
#pragma mark MessageCellFactory PrivateAPI

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
