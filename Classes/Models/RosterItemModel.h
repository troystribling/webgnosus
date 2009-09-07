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
    NSString* type;
    NSInteger priority;
	NSInteger accountPk;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) NSString* status;
@property (nonatomic, retain) NSString* show;
@property (nonatomic, retain) NSString* type;
@property (nonatomic, assign) NSInteger priority;
@property (nonatomic, assign) NSInteger accountPk;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)count;
+ (NSInteger)countByAccount:(AccountModel*)account;
+ (NSInteger)countByJid:(NSString*)bareJid andAccount:(AccountModel*)account;
+ (NSInteger)maxPriorityForJid:(NSString*)bareJid andAccount:(AccountModel*)account;
+ (NSMutableArray*)findAll;
+ (NSMutableArray*)findAllByAccount:(AccountModel*)account;
+ (NSMutableArray*)findAllByJid:(NSString*)bareJid andAccount:(AccountModel*)account;
+ (NSMutableArray*)findAllResourcesByAccount:(AccountModel*)account;
+ (RosterItemModel*)findByPk:(NSInteger)requestPk;
+ (RosterItemModel*)findByFullJid:(NSString*)requestFullJid andAccount:(AccountModel*)account;
+ (RosterItemModel*)findWithMaxPriorityByJid:(NSString*)bareJid andAccount:(AccountModel*)account;
+ (BOOL)isJidAvailable:(NSString*)bareJid;
+ (void)drop;
+ (void)create;
+ (void)destroyAllByAccount:(AccountModel*)account;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insert;
- (void)destroy;
- (void)load;
- (void)update;
- (BOOL)isAvailable;
- (AccountModel*)account;
- (void)setAttributesWithStatement:(sqlite3_stmt*)statement;

@end


