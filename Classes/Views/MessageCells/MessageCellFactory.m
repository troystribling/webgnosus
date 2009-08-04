//
//  MessageCellFactory.m
//  webgnosus_client
//
//  Created by Troy Stribling on 2/27/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "MessageCellFactory.h"
#import "BodyMessageCell.h"
#import "UptimeCell.h"
#import "FileSystemUsageCell.h"
#import "EthernetInterfaceCell.h"
#import "ActiveUsersCell.h"
#import "ListeningTcpSocketsCell.h"
#import "UdpSocketsCell.h"
#import "ConnectedTcpSocketsCell.h"
#import "TimeSeriesCell.h"
#import "ProcessesUsingMostCpuCell.h"
#import "ProcessesUsingMostMemoryCell.h"
#import "LargestOpenFilesCell.h"
#import "LargestFilesCell.h"
#import "MessageModel.h"
#import "UserModel.h"
#import "Commands.h"

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
    if ([message.node isEqualToString:@"uptime"]) {
        cellHeight = [UptimeCell tableView:tableView heightForRowWithMessage:message withHeader:NO];
    } else if ([message.node isEqualToString:@"file_system_usage"]) {
        cellHeight = [FileSystemUsageCell tableView:tableView heightForRowWithMessage:message withHeader:YES];
    } else if ([message.node isEqualToString:@"ethernet_interfaces"]) {
        cellHeight = [EthernetInterfaceCell tableView:tableView heightForRowWithMessage:message withHeader:YES];
    } else if ([message.node isEqualToString:@"active_users"]) {
        cellHeight = [ActiveUsersCell tableView:tableView heightForRowWithMessage:message withHeader:YES];
    } else if ([message.node isEqualToString:@"listening_tcp_sockets"]) {
        cellHeight = [ListeningTcpSocketsCell tableView:tableView heightForRowWithMessage:message withHeader:YES];
    } else if ([message.node isEqualToString:@"connected_tcp_sockets"]) {
        cellHeight = [ConnectedTcpSocketsCell tableView:tableView heightForRowWithMessage:message withHeader:YES];
    } else if ([message.node isEqualToString:@"udp_sockets"]) {
        cellHeight = [UdpSocketsCell tableView:tableView heightForRowWithMessage:message withHeader:YES];
    } else if ([message.node isEqualToString:@"processes_using_most_cpu"]) {
        cellHeight = [ProcessesUsingMostCpuCell tableView:tableView heightForRowWithMessage:message withHeader:YES];
    } else if ([message.node isEqualToString:@"processes_using_most_memory"]) {
        cellHeight = [ProcessesUsingMostMemoryCell tableView:tableView heightForRowWithMessage:message withHeader:YES];
    } else if ([message.node isEqualToString:@"largest_open_files"]) {
        cellHeight = [LargestOpenFilesCell tableView:tableView heightForRowWithMessage:message withHeader:YES];
    } else if ([message.node isEqualToString:@"largest_files"]) {
        cellHeight = [LargestFilesCell tableView:tableView heightForRowWithMessage:message withHeader:YES];
    } else if ([[Commands instance] hasPerformanceCommand:message.node]) {
        cellHeight = [TimeSeriesCell tableView:tableView heightForRowWithMessage:message];
    } else {
        cellHeight = [BodyMessageCell tableView:tableView heightForRowWithMessage:message];
    }
    return cellHeight;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UITableViewCell*)tableView:(UITableView*)tableView cellForCommandResponseAtIndexPath:(NSIndexPath*)indexPath forMessage:(MessageModel*)message {
	UITableViewCell* cell = nil;
    if ([message.node isEqualToString:@"uptime"]) {
        cell = [UptimeCell tableView:tableView cellForRowAtIndexPath:indexPath forMessage:message withHeader:NO];
    } else if ([message.node isEqualToString:@"file_system_usage"]) {
        cell = [FileSystemUsageCell tableView:tableView cellForRowAtIndexPath:indexPath forMessage:message withHeader:YES];
    } else if ([message.node isEqualToString:@"ethernet_interfaces"]) {
        cell = [EthernetInterfaceCell tableView:tableView cellForRowAtIndexPath:indexPath forMessage:message withHeader:YES];
    } else if ([message.node isEqualToString:@"active_users"]) {
        cell = [ActiveUsersCell tableView:tableView cellForRowAtIndexPath:indexPath forMessage:message withHeader:YES];
    } else if ([message.node isEqualToString:@"listening_tcp_sockets"]) {
        cell = [ListeningTcpSocketsCell tableView:tableView cellForRowAtIndexPath:indexPath forMessage:message withHeader:YES];
    } else if ([message.node isEqualToString:@"connected_tcp_sockets"]) {
        cell = [ConnectedTcpSocketsCell tableView:tableView cellForRowAtIndexPath:indexPath forMessage:message withHeader:YES];
    } else if ([message.node isEqualToString:@"udp_sockets"]) {
        cell = [UdpSocketsCell tableView:tableView cellForRowAtIndexPath:indexPath forMessage:message withHeader:YES];
    } else if ([message.node isEqualToString:@"processes_using_most_cpu"]) {
        cell = [ProcessesUsingMostCpuCell tableView:tableView cellForRowAtIndexPath:indexPath forMessage:message withHeader:YES];
    } else if ([message.node isEqualToString:@"processes_using_most_memory"]) {
        cell = [ProcessesUsingMostMemoryCell tableView:tableView cellForRowAtIndexPath:indexPath forMessage:message withHeader:YES];
    } else if ([message.node isEqualToString:@"largest_open_files"]) {
        cell = [LargestOpenFilesCell tableView:tableView cellForRowAtIndexPath:indexPath forMessage:message withHeader:YES];
    } else if ([message.node isEqualToString:@"largest_files"]) {
        cell = [LargestFilesCell tableView:tableView cellForRowAtIndexPath:indexPath forMessage:message withHeader:YES];
    } else if ([[Commands instance] hasPerformanceCommand:message.node]) {
        cell = [TimeSeriesCell tableView:tableView cellForRowAtIndexPath:indexPath forMessage:message];
    } else {
        cell = [BodyMessageCell tableView:tableView cellForRowAtIndexPath:indexPath forMessage:message];
    }
    return cell;
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
