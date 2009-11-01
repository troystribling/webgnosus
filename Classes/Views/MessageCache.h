//
//  MessageCache.h
//  webgnosus
//
//  Created by Troy Stribling on 10/28/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

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
- (id)initWithCacheIncrement:(NSInteger)initCacheIncrement andAccount:(AccountModel*)initAccount;
- (id)initWithAccount:(AccountModel*)initAccount;
- (NSInteger)count;
- (void)load;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath;

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSArray*)addMessages;
- (NSInteger)totalCount;

@end
