//
//  Message.h
//  webgnosus_client
//
//  Created by Troy Stribling on 2/24/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import <sqlite3.h>

//-----------------------------------------------------------------------------------------------------------------------------------
@class AccountModel;
@class UserModel;
@class XMPPxData;

//-----------------------------------------------------------------------------------------------------------------------------------
typedef enum tagMessageTextType {
    MessageTextTypeBody,
    MessageTextTypeCommandResponse
} MessageTextType;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface MessageModel : NSObject {
	NSInteger pk;
    NSString* messageText;
    NSDate* createdAt;
	NSInteger accountPk;
	NSString* toJid;
	NSString* fromJid;
    MessageTextType textType;
    NSString* node;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, assign) NSInteger pk;
@property (nonatomic, retain) NSString* messageText;
@property (nonatomic, retain) NSDate* createdAt;
@property (nonatomic, assign) NSInteger accountPk;
@property (nonatomic, assign) NSString* toJid;
@property (nonatomic, assign) NSString* fromJid;
@property (nonatomic, assign) MessageTextType textType;
@property (nonatomic, assign) NSString* node;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)count;
+ (NSInteger)countWithLimit:(NSInteger)limit;
+ (NSInteger)countByJid:(NSString*)jid andAccount:(AccountModel*)account;
+ (NSInteger)countByJid:(NSString*)jid andAccount:(AccountModel*)account withLimit:(NSInteger)limit;
+ (void)drop;
+ (void)create;
+ (NSMutableArray*)findAll;
+ (NSMutableArray*)findAllWithLimit:(NSInteger)limit;
+ (NSMutableArray*)findAllByAccount:(AccountModel*)account;
+ (NSMutableArray*)findAllByJid:(NSString*)jid andAccount:(AccountModel*)account;
+ (NSMutableArray*)findAllByJid:(NSString*)jid andAccount:(AccountModel*)account withLimit:(NSInteger)limit;
+ (MessageModel*)findByPk:(NSInteger)requestPk;
+ (void)destroyAllByAccount:(AccountModel*)account;
+ (XMPPxData*)parseXDataMessage:(MessageModel*)message;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insert;
- (void)destroy;
- (void)update;
- (NSString*)createdAtAsString;

@end
