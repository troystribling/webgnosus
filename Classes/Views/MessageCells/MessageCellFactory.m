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
#import "MessageModel.h"
#import "UserModel.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface MessageCellFactory (PrivateAPI)

+ (UITableViewCell*)tableView:(UITableView*)tableView cellForCommandResponseAtIndexPath:(NSIndexPath*)indexPath forMessage:(MessageModel*)message;
+ (CGFloat)tableView:(UITableView*)tableView heightForCommandResponseWithMessage:(MessageModel*)message;

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
    } else if (message.textType ==  MessageTextTypeCommandResponse) {
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
    } else if (message.textType ==  MessageTextTypeCommandResponse) {
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
    return cellHeight;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UITableViewCell*)tableView:(UITableView*)tableView cellForCommandResponseAtIndexPath:(NSIndexPath*)indexPath forMessage:(MessageModel*)message {
	UITableViewCell* cell = nil;
    return cell;
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
