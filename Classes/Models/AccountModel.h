//
//  AccountModel.h
//  webgnosus
//
//  Created by Troy Stribling on 1/6/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "UserModel.h"

//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
typedef enum {
    AccountNotConnected,
    AccountConnected,
    AccountAuthenticated,
    AccountRosterUpdated,
    AccountDiscoCompleted,
    AccountSubscriptionsUpdated,
    AccountConnectionError,
    AccountAuthenticationError,
    AccountRosterUpdateError,
    AccountDiscoError,
    AccountSubscriptionsUpdateError,
} AccountConnectionState;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface AccountModel : UserModel {
	NSString* password;
	BOOL activated;
    BOOL displayed;
    NSInteger port;
    AccountConnectionState connectionState;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) NSString* password;
@property (nonatomic, assign) BOOL activated;
@property (nonatomic, assign) BOOL displayed;
@property (nonatomic, assign) AccountConnectionState connectionState;
@property (nonatomic, assign) NSInteger port;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)count;
+ (NSInteger)activateCount;
+ (void)drop;
+ (void)create;
+ (NSMutableArray*)findAll;
+ (NSMutableArray*)findAllActivated;
+ (NSMutableArray*)findAllActivatedByConnectionState:(AccountConnectionState)connectionState;
+ (AccountModel*)findFirst;
+ (AccountModel*)findFirstDisplayed;
+ (AccountModel*)findByPk:(NSInteger)requestPk;
+ (AccountModel*)findByJID:(NSString*)requestJID;
+ (BOOL)triedToConnectAll;
+ (NSMutableArray*)findAllReady;
+ (void)setAllNotDisplayed;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insert;
- (void)destroy;
- (void)load;
- (void)update;
- (NSInteger)activatedAsInteger;
- (void)setActivatedAsInteger:(NSInteger)value;
- (NSInteger)displayedAsInteger;
- (void)setDisplayedAsInteger:(NSInteger)value;
- (BOOL)isReady;
- (BOOL)hasError;
- (void)setAttributesWithStatement:(sqlite3_stmt*)statement;

@end
