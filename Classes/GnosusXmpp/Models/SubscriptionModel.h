//
//  SubscriptionModel.h
//  webgnosus
//
//  Created by Troy Stribling on 8/9/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import <sqlite3.h>

//-----------------------------------------------------------------------------------------------------------------------------------
@class AccountModel;
@class XMPPPubSubSubscription;
@class XMPPJID;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface SubscriptionModel : NSObject {
    NSInteger pk;
	NSInteger accountPk;
	NSString* subId;
    NSString* node;
    NSString* service;
    NSString* subscription;
    NSString* jid;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, assign) NSInteger pk;
@property (nonatomic, assign) NSInteger accountPk;
@property (nonatomic, assign) NSString* subId;
@property (nonatomic, retain) NSString* node;
@property (nonatomic, retain) NSString* service;
@property (nonatomic, retain) NSString* subscription;
@property (nonatomic, retain) NSString* jid;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)count;
+ (void)drop;
+ (void)create;
+ (NSMutableArray*)findAll;
+ (NSMutableArray*)findAllByAccount:(AccountModel*)requestAccount;
+ (NSMutableArray*)findAllByAccount:(AccountModel*)requestAccount andNode:(NSString*)requestNode;
+ (SubscriptionModel*)findByAccount:(AccountModel*)requestAccount node:(NSString*)requestNode andSubId:(NSString*)requestSubId;
+ (NSArray*)findAllServicesByAccount:(AccountModel*)requestAccount;
+ (void)destroyAll;
+ (void)destroyAllByAccount:(AccountModel*)requestAccount;
+ (void)insert:(XMPPPubSubSubscription*)insertSub forService:(NSString*)serviceJID andAccount:(AccountModel*)insertAccount;
+ (void)insert:(XMPPPubSubSubscription*)insertSub forService:(NSString*)serviceJID node:insertNone andAccount:(AccountModel*)insertAccount;
+ (void)destroyAllByService:(NSString*)requestService andAccount:(AccountModel*)requestAccount;
    
//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insert;
- (void)destroy;
- (void)load;
- (void)update;

@end
