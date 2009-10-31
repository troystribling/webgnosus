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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface MessageCache (PrivateAPI)

- (void)load;

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
- (id)initWithCacheIncrement:(NSInteger)initCacheIncrement {
	if(self = [super init]) {
        self.messageList = [NSMutableArray arrayWithCapacity:initCacheIncrement];
        self.cacheIncrement = initCacheIncrement;
        self.lastPk = -1;
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)count {
    return [self.messageList count];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)totalCount {
    return [MessageModel countByAccount:self.account];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)objectAtIndex:(NSInteger)index {
    return [self.messageList objectAtIndex:index];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)flush {
    return [self.messageList removeAllObjects];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)initForAccount:(AccountModel*)initAccount {
    self.account = initAccount;
    self.lastPk = [MessageModel greatestPkForAccount:self.account] + 1;
    [self load];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)load {
    NSArray* newMessages = [self addMessages];
    self.lastPk = [[newMessages lastObject] pk];
    [self.messageList addObjectsFromArray:newMessages];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)grow:(UITableView*)table {
    NSInteger oldCount = [self count];
    [self load];
    NSInteger deltaCount = [self count] - oldCount;
    NSMutableArray* newIndexPaths = [NSMutableArray arrayWithCapacity:deltaCount];
    for (int i = 0; i < deltaCount; i++) {
        [newIndexPaths addObject:[NSIndexPath indexPathForRow:(deltaCount+i) inSection:0]];
    }
    [table beginUpdates];
        if ([self.messageList count] == [self totalCount]) {
            [table deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:oldCount inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
        }
        [table insertRowsAtIndexPaths:newIndexPaths withRowAnimation:UITableViewRowAnimationBottom];
    [table endUpdates];
}

//===================================================================================================================================
#pragma mark MessageCache Interface

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSArray*)addMessages {
    return [NSMutableArray arrayWithCapacity:1];
}

//===================================================================================================================================
#pragma mark MessageCache PrivateApi

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)init {
	if(self = [self initWithCacheIncrement:kMESSAGE_CACHE_SIZE]) {
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
