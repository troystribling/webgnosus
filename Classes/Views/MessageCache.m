//
//  MessageCache.m
//  webgnosus
//
//  Created by Troy Stribling on 10/28/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "MessageCache.h"
#import "MessageModel.h"
#import "MessageCellFactory.h"
#import "CellUtils.h"
#import "LoadMessagesCell.h"
#import "XMPPClientManager.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface MessageCache (PrivateAPI)

- (void)markMessageRead:(MessageModel*)message;;
- (void)grow:(UITableView*)table;
- (id)objectAtIndex:(NSInteger)index;
- (NSInteger)messageCount;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation MessageCache

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize messageList;
@synthesize cacheIncrement;
@synthesize lastPk;
@synthesize account;

//===================================================================================================================================
#pragma mark MessageCache

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithCacheIncrement:(NSInteger)initCacheIncrement andAccount:(AccountModel*)initAccount {
	if(self = [super init]) {
        self.messageList = [NSMutableArray arrayWithCapacity:initCacheIncrement];
        self.cacheIncrement = initCacheIncrement;
        self.account = initAccount;
        self.lastPk = [MessageModel greatestPkForAccount:self.account] + 1;
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithAccount:(AccountModel*)initAccount {
	if(self = [self initWithCacheIncrement:kMESSAGE_CACHE_SIZE andAccount:initAccount]) {
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)count {
    NSInteger count = [self messageCount];
    if (count < [self totalCount]) {
        count += 1;
    }
    return count;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)load {
    NSArray* newMessages = [self addMessages];
    self.lastPk = [[newMessages lastObject] pk];
    [self.messageList addObjectsFromArray:newMessages];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self messageCount]) {
        [self grow:tableView];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    CGFloat height = kLOAD_MESSAGE_CELL_HEIGHT;
    if (indexPath.row < [self messageCount]) {
        height = [MessageCellFactory tableView:tableView heightForRowWithMessage:[self objectAtIndex:indexPath.row]];
    } 
    return height;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {   
    UITableViewCell* cell;
    if (indexPath.row < [self messageCount]) {
        MessageModel* message =[self objectAtIndex:indexPath.row];
        [self markMessageRead:message];
        cell = [MessageCellFactory tableView:tableView cellForRowAtIndexPath:indexPath forMessage:message];
    } else {
        cell = [CellUtils createCell:[LoadMessagesCell class] forTableView:tableView];
    }
    return cell;
}

//===================================================================================================================================
#pragma mark MessageCache Interface

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSArray*)addMessages {
    return [NSMutableArray arrayWithCapacity:1];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)totalCount {
    return [MessageModel countByAccount:self.account];
}

//===================================================================================================================================
#pragma mark MessageCache PrivateApi

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)grow:(UITableView*)table {
    NSInteger oldCount = [self messageCount];
    [self load];
    NSInteger deltaCount = [self messageCount] - oldCount;
    NSMutableArray* newIndexPaths = [NSMutableArray arrayWithCapacity:deltaCount];
    for (int i = 0; i < deltaCount; i++) {
        [newIndexPaths addObject:[NSIndexPath indexPathForRow:(oldCount+i) inSection:0]];
    }
    [table beginUpdates];
        [table deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:oldCount inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [table insertRowsAtIndexPaths:newIndexPaths withRowAnimation:UITableViewRowAnimationBottom];
        if ([self messageCount] != [self totalCount]) {
            [table insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[self messageCount] inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
        }
    [table endUpdates];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)markMessageRead:(MessageModel*)message {
    if (!message.messageRead) {
        message.messageRead = YES;
        [message update];
        [[[XMPPClientManager instance] messageCountUpdateDelegate] messageCountDidChange];
    }     
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)messageCount {
    return [self.messageList count];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)objectAtIndex:(NSInteger)index {
    return [self.messageList objectAtIndex:index];
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
