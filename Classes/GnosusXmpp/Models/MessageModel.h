//
//  Message.h
//  webgnosus
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
@class XMPPEntry;
@class XMPPClient;
@class XMPPMessage;
@class XMPPIQ;

//-----------------------------------------------------------------------------------------------------------------------------------
typedef enum tagMessageTextType {
    MessageTextTypeBody,
    MessageTextTypeCommandText,
    MessageTextTypeCommandXData,
    MessageTextTypeEventText,
    MessageTextTypeEventEntry,
    MessageTextTypeEventxData
} MessageTextType;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface MessageModel : NSObject {
	NSInteger pk;
	NSInteger accountPk;
    MessageTextType textType;
    BOOL messageRead;
    NSString* messageText;
    NSDate* createdAt;
	NSString* toJid;
	NSString* fromJid;
    NSString* node;
    NSString* itemId;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, assign) NSInteger pk;
@property (nonatomic, assign) NSInteger accountPk;
@property (nonatomic, assign) MessageTextType textType;
@property (nonatomic, assign) BOOL messageRead;
@property (nonatomic, retain) NSString* messageText;
@property (nonatomic, retain) NSDate* createdAt;
@property (nonatomic, retain) NSString* toJid;
@property (nonatomic, retain) NSString* fromJid;
@property (nonatomic, retain) NSString* node;
@property (nonatomic, retain) NSString* itemId;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)count;
+ (NSInteger)countByAccount:(AccountModel*)requestAccount;
+ (NSInteger)countMessagesByJid:(NSString*)requestJID andAccount:(AccountModel*)requestAccount;
+ (NSInteger)countCommandsByJid:(NSString*)requestJID andAccount:(AccountModel*)requestAccount;
+ (NSInteger)countSubscribedEventsByNode:(NSString*)requestNode andAccount:(AccountModel*)requestAccount;
+ (NSInteger)countPublishedEventsByNode:(NSString*)requestNode andAccount:(AccountModel*)requestAccount;
+ (NSInteger)countUnreadMessagesByFromJid:(NSString*)requestFromJid andAccount:(AccountModel*)requestAccount;
+ (NSInteger)countUnreadEventsByNode:(NSString*)requestNode andAccount:(AccountModel*)requestAccount;
+ (NSInteger)countUnreadMessagesByAccount:(AccountModel*)requestAccount;
+ (NSInteger)countUnreadEventsByAccount:(AccountModel*)requestAccount;
+ (NSInteger)greatestPkForAccount:(AccountModel*)requestAccount;
+ (void)drop;
+ (void)create;
+ (NSMutableArray*)findAll;
+ (NSMutableArray*)findAllByAccount:(AccountModel*)requestAccount withPkGreaterThan:(NSInteger)maxPk andLimit:(NSInteger)requestLimit;
+ (NSMutableArray*)findAllMessagesByJid:(NSString*)requestJID forAccount:(AccountModel*)requestAccount withPkGreaterThan:(NSInteger)requestPk andLimit:(NSInteger)requestLimit;
+ (NSMutableArray*)findAllCommandsByJid:(NSString*)requestJID forAccount:(AccountModel*)requestAccount withPkGreaterThan:(NSInteger)requestPk andLimit:(NSInteger)requestLimit;
+ (NSMutableArray*)findAllSubscribedEventsByNode:(NSString*)requestNode forAccount:(AccountModel*)requestAccount withPkGreaterThan:(NSInteger)requestPk andLimit:(NSInteger)requestLimit;
+ (NSMutableArray*)findAllPublishedEventsByNode:(NSString*)requestNode forAccount:(AccountModel*)requestAccount withPkGreaterThan:(NSInteger)requestPk andLimit:(NSInteger)requestLimit;
+ (NSMutableArray*)findAllByJid:(NSString*)requestJID andAccount:(AccountModel*)requestAccount withLimit:(NSInteger)requestLimit;
+ (MessageModel*)findEventByNode:(NSString*)requestNode andItemId:(NSString*)requestItemId andAccount:(AccountModel*)requestAccount;
+ (MessageModel*)findByPk:(NSInteger)requestPk;
+ (void)markReadByFromJid:(NSString*)requestFromJid textType:(MessageTextType)requestTextType andAccount:(AccountModel*)requestAccount;
+ (void)destroyAllByAccount:(AccountModel*)requestAccount;
+ (void)insert:(XMPPClient*)client message:(XMPPMessage*)message;
+ (void)insertEvent:(XMPPClient*)client forMessage:(XMPPMessage*)message;
+ (void)insertPubSubItems:(XMPPClient*)client forIq:(XMPPIQ*)iq;
+ (void)insert:(XMPPClient*)client commandResult:(XMPPIQ*)iq;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insert;
- (void)destroy;
- (void)update;
- (NSString*)createdAtAsString;
- (NSInteger)messageReadAsInteger;
- (void)setMessageReadAsInteger:(NSInteger)value;
- (XMPPxData*)parseXDataMessage;
- (XMPPEntry*)parseEntryMessage;

@end
