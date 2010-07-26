//
//  RosterItemModel.h
//  webgnosus
//
//  Created by Troy Stribling on 1/20/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "UserModel.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@class AccountModel;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface RosterItemModel : UserModel {
	NSString* status;
    NSString* show;
    NSString* presenceType;
    NSInteger priority;
	NSInteger accountPk;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) NSString* status;
@property (nonatomic, retain) NSString* show;
@property (nonatomic, retain) NSString* presenceType;
@property (nonatomic, assign) NSInteger priority;
@property (nonatomic, assign) NSInteger accountPk;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)count;
+ (NSInteger)countByAccount:(AccountModel*)requestAccount;
+ (NSInteger)countByJid:(NSString*)bareJid andAccount:(AccountModel*)requestAccount;
+ (NSInteger)maxPriorityForJid:(NSString*)bareJid andAccount:(AccountModel*)requestAccount;
+ (NSMutableArray*)findAll;
+ (NSMutableArray*)findAllByAccount:(AccountModel*)requestAccount;
+ (NSMutableArray*)findAllByJid:(NSString*)bareJid andAccount:(AccountModel*)requestAccount;
+ (NSMutableArray*)findAllByFullJid:(NSString*)requestFullJid andAccount:(AccountModel*)requestAccount;
+ (NSMutableArray*)findAllResourcesByAccount:(AccountModel*)requestAccount;
+ (RosterItemModel*)findByPk:(NSInteger)requestPk;
+ (RosterItemModel*)findByFullJid:(NSString*)requestFullJid andAccount:(AccountModel*)requestAccount;
+ (RosterItemModel*)findWithMaxPriorityByJid:(NSString*)bareJid andAccount:(AccountModel*)requestAccount;
+ (BOOL)isJidAvailable:(NSString*)bareJid;
+ (void)drop;
+ (void)create;
+ (void)destroyAllByAccount:(AccountModel*)requestAccount;
+ (void)destroyByFullJid:(NSString*)requestFullJid andAccount:(AccountModel*)requestAccount;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insert;
- (void)destroy;
- (void)load;
- (void)update;
- (BOOL)isAvailable;
- (AccountModel*)account;
- (void)setAttributesWithStatement:(sqlite3_stmt*)statement;

@end


