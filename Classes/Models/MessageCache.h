//
//  MessageCache.h
//  webgnosus
//
//  Created by Troy Stribling on 10/28/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import <sqlite3.h>

//-----------------------------------------------------------------------------------------------------------------------------------
@class AccountModel;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface MessageCache : NSObject {
    NSMutableArray* messageList;
    NSInteger cacheIncrement;
    NSInteger lastPk;
    AccountModel* account;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) NSMutableArray* messageList;
@property (nonatomic, assign) NSInteger cacheIncrement;
@property (nonatomic, assign) NSInteger lastPk;
@property (nonatomic, retain) AccountModel* account;

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithCacheIncrement:(NSInteger)initCacheIncrement;
- (id)objectAtIndex:(NSInteger)index;
- (void)initForAccount:(AccountModel*)initAccount;
- (BOOL)grow:(NSInteger)messageIndex;
- (NSInteger)count;
- (void)flush;

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSArray*)addMessages;

@end
