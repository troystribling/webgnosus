//
//  MessageModel.m
//  webgnosus
//
//  Created by Troy Stribling on 2/24/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "MessageModel.h"
#import "AccountModel.h"
#import "ContactModel.h"
#import "SubscriptionModel.h"
#import "RosterItemModel.h"
#import "UserModel.h"
#import "WebgnosusDbi.h"
#import "XMPPxData.h"
#import "XMPPEntry.h"
#import "XMPPClient.h"
#import "XMPPMessage.h"
#import "XMPPIQ.h"
#import "XMPPJID.h"
#import "XMPPPubSubEvent.h"
#import "XMPPPubSubItem.h"
#import "XMPPPubSubItems.h"
#import "XMPPPubSub.h"
#import "XMPPCommand.h"
#import "XMPPMessageDelegate.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface MessageModel (PrivateAPI)

+ (void)insert:(XMPPClient*)client pubSubItems:(XMPPPubSubItems*)items fromJID:(XMPPJID*)fromJID withReadFlag:(BOOL)readFlag;
- (void)setAttributesWithStatement:(sqlite3_stmt*)statement;
- (UserModel*)findUserModel:(NSString*)jid;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation MessageModel

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize pk;
@synthesize accountPk;
@synthesize textType;
@synthesize messageRead;
@synthesize messageText;
@synthesize createdAt;
@synthesize toJid;
@synthesize fromJid;
@synthesize node;
@synthesize itemId;

//===================================================================================================================================
#pragma mark MessageModel

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)count {
	return [[WebgnosusDbi instance]  selectIntExpression:@"SELECT COUNT(pk) FROM messages"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)countByAccount:(AccountModel*)requestAccount {
	NSString* selectStatement = [NSString stringWithFormat:@"SELECT COUNT(pk) FROM messages WHERE accountPk = %d", requestAccount.pk];
    return [[WebgnosusDbi instance]  selectIntExpression:selectStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)countMessagesByJid:(NSString*)requestJID andAccount:(AccountModel*)requestAccount {
	NSString* selectStatement = [NSString stringWithFormat:@"SELECT COUNT(pk) FROM messages WHERE (toJid LIKE '%@%%' OR fromJid LIKE '%@%%') AND textType = %d AND accountPk = %d", 
                                 requestJID, requestJID, MessageTextTypeBody, requestAccount.pk];
    return [[WebgnosusDbi instance]  selectIntExpression:selectStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)countCommandsByJid:(NSString*)requestJID andAccount:(AccountModel*)requestAccount {
	NSString* selectStatement = [NSString stringWithFormat:@"SELECT COUNT(pk) FROM messages WHERE (toJid LIKE '%@%%' OR fromJid LIKE '%@%%') AND (textType = %d OR textType = %d) AND accountPk = %d", 
                                 requestJID, requestJID, MessageTextTypeCommandText, MessageTextTypeCommandXData, requestAccount.pk];
    return [[WebgnosusDbi instance]  selectIntExpression:selectStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)countSubscribedEventsByNode:(NSString*)requestNode andAccount:(AccountModel*)requestAccount {
	NSString* selectStatement = [NSString stringWithFormat:@"SELECT COUNT(pk) FROM messages WHERE (textType = %d OR textType = %d OR textType = %d) AND node = '%@' AND itemId <> '-1' AND accountPk = %d", 
                                 MessageTextTypeEventText, MessageTextTypeEventEntry, MessageTextTypeEventxData, requestNode, requestAccount.pk];
    return [[WebgnosusDbi instance]  selectIntExpression:selectStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)countPublishedEventsByNode:(NSString*)requestNode andAccount:(AccountModel*)requestAccount {
	NSString* selectStatement = [NSString stringWithFormat:@"SELECT COUNT(pk) FROM messages WHERE (textType = %d OR textType = %d OR textType = %d) AND node = '%@'  AND itemId = '-1' AND accountPk = %d", 
                                 MessageTextTypeEventText, MessageTextTypeEventEntry, MessageTextTypeEventxData, requestNode, requestAccount.pk];
    return [[WebgnosusDbi instance]  selectIntExpression:selectStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)countUnreadMessagesByFromJid:(NSString*)requestFromJid andAccount:(AccountModel*)requestAccount {
	NSString* selectStatement = [NSString stringWithFormat:@"SELECT COUNT(pk) FROM messages WHERE fromJid LIKE '%@%%' AND (textType = 0 OR textType = 1 OR textType = 2) AND messageRead = 0 AND accountPk = %d", requestFromJid, requestAccount.pk];
    return [[WebgnosusDbi instance]  selectIntExpression:selectStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)countUnreadEventsByNode:(NSString*)requestNode andAccount:(AccountModel*)requestAccount {
	NSString* selectStatement = [NSString stringWithFormat:@"SELECT COUNT(pk) FROM messages WHERE node = '%@' AND (textType = 3 OR textType = 4 OR textType = 5) AND messageRead = 0 AND accountPk = %d", requestNode, requestAccount.pk];
    return [[WebgnosusDbi instance]  selectIntExpression:selectStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)countUnreadMessagesByAccount:(AccountModel*)requestAccount {
	NSString* selectStatement = [NSString stringWithFormat:@"SELECT COUNT(pk) FROM messages WHERE (textType = 0 OR textType = 1 OR textType = 2) AND messageRead = 0 AND accountPk = %d", requestAccount.pk];
    return [[WebgnosusDbi instance]  selectIntExpression:selectStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)countUnreadEventsByAccount:(AccountModel*)requestAccount {
	NSString* selectStatement = [NSString stringWithFormat:@"SELECT COUNT(pk) FROM messages WHERE (textType = 3 OR textType = 4 OR textType = 5) AND messageRead = 0 AND accountPk = %d", requestAccount.pk];
    return [[WebgnosusDbi instance]  selectIntExpression:selectStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)greatestPkForAccount:(AccountModel*)requestAccount {
	NSString* selectStatement = [NSString stringWithFormat:@"SELECT MAX(pk) FROM messages WHERE accountPk = %d", requestAccount.pk];
    return [[WebgnosusDbi instance]  selectIntExpression:selectStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)drop {
	[[WebgnosusDbi instance]  updateWithStatement:@"DROP TABLE messages"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)create {
	[[WebgnosusDbi instance]  updateWithStatement:@"CREATE TABLE messages (pk integer primary key, messageText text, createdAt date, toJid text, fromJid text, textType integer, node text, itemId text, messageRead integer, accountPk integer, FOREIGN KEY (accountPk) REFERENCES accounts(pk))"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAll {
	NSMutableArray* output = [NSMutableArray arrayWithCapacity:10];	
    [[WebgnosusDbi instance] selectAllForModel:[MessageModel class] withStatement:@"SELECT * FROM messages ORDER BY createdAt DESC" andOutputTo:output];
	return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAllByAccount:(AccountModel*)requestAccount withPkGreaterThan:(NSInteger)requestPk andLimit:(NSInteger)requestLimit {
	NSMutableArray* output = [NSMutableArray arrayWithCapacity:10];	
	NSString* selectStatement = [NSString stringWithFormat:@"SELECT * FROM messages WHERE accountPk = %d AND pk < %d ORDER BY pk DESC LIMIT %d", requestAccount.pk, requestPk, requestLimit];
	[[WebgnosusDbi instance] selectAllForModel:[MessageModel class] withStatement:selectStatement andOutputTo:output];
	return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAllMessagesByJid:(NSString*)requestJID forAccount:(AccountModel*)requestAccount withPkGreaterThan:(NSInteger)requestPk andLimit:(NSInteger)requestLimit  {
	NSMutableArray* output = [NSMutableArray arrayWithCapacity:10];	
	NSString* selectStatement = [NSString stringWithFormat:@"SELECT * FROM messages WHERE (toJid LIKE '%@%%' OR fromJid LIKE '%@%%') AND pk < %d AND textType = %d AND accountPk = %d ORDER BY pk DESC LIMIT %d", 
                                 requestJID, requestJID, requestPk, MessageTextTypeBody, requestAccount.pk, requestLimit];
	[[WebgnosusDbi instance] selectAllForModel:[MessageModel class] withStatement:selectStatement andOutputTo:output];
	return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAllCommandsByJid:(NSString*)requestJID forAccount:(AccountModel*)requestAccount withPkGreaterThan:(NSInteger)requestPk andLimit:(NSInteger)requestLimit  {
	NSMutableArray* output = [NSMutableArray arrayWithCapacity:10];	
	NSString* selectStatement = [NSString stringWithFormat:@"SELECT * FROM messages WHERE (toJid LIKE '%@%%' OR fromJid LIKE '%@%%')  AND pk < %d AND (textType = %d OR textType = %d) AND accountPk = %d ORDER BY pk DESC LIMIT %d", 
                                 requestJID, requestJID, requestPk, MessageTextTypeCommandText, MessageTextTypeCommandXData, requestAccount.pk, requestLimit];
	[[WebgnosusDbi instance] selectAllForModel:[MessageModel class] withStatement:selectStatement andOutputTo:output];
	return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAllSubscribedEventsByNode:(NSString*)requestNode forAccount:(AccountModel*)requestAccount withPkGreaterThan:(NSInteger)requestPk andLimit:(NSInteger)requestLimit {
	NSMutableArray* output = [NSMutableArray arrayWithCapacity:10];	
	NSString* selectStatement = [NSString stringWithFormat:@"SELECT * FROM messages WHERE (textType = %d OR textType = %d OR textType = %d)  AND pk < %d AND node = '%@' AND itemId <> '-1' AND accountPk = %d ORDER BY pk DESC LIMIT %d", 
                                 MessageTextTypeEventText, MessageTextTypeEventEntry, MessageTextTypeEventxData, requestPk, requestNode, requestAccount.pk, requestLimit];
	[[WebgnosusDbi instance] selectAllForModel:[MessageModel class] withStatement:selectStatement andOutputTo:output];
	return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAllPublishedEventsByNode:(NSString*)requestNode forAccount:(AccountModel*)requestAccount withPkGreaterThan:(NSInteger)requestPk andLimit:(NSInteger)requestLimit {
	NSMutableArray* output = [NSMutableArray arrayWithCapacity:10];	
	NSString* selectStatement = [NSString stringWithFormat:@"SELECT * FROM messages WHERE (textType = %d OR textType = %d OR textType = %d)  AND pk < %d AND node = '%@'  AND itemId = '-1' AND accountPk = %d ORDER BY pk DESC LIMIT %d", 
                                 MessageTextTypeEventText, MessageTextTypeEventEntry, MessageTextTypeEventxData, requestPk, requestNode, requestAccount.pk, requestLimit];
	[[WebgnosusDbi instance] selectAllForModel:[MessageModel class] withStatement:selectStatement andOutputTo:output];
	return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAllByJid:(NSString*)requestJID andAccount:(AccountModel*)requestAccount withLimit:(NSInteger)requestLimit {
	NSMutableArray* output = [NSMutableArray arrayWithCapacity:10];	
	NSString* selectStatement = [NSString stringWithFormat:@"SELECT * FROM messages WHERE (toJid LIKE '%@%%' OR fromJid LIKE '%@%%') AND accountPk = %d ORDER BY createdAt DESC LIMIT %d", 
                                 requestJID, requestJID, requestAccount.pk, requestLimit];
	[[WebgnosusDbi instance] selectAllForModel:[MessageModel class] withStatement:selectStatement andOutputTo:output];
	return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (MessageModel*)findByPk:(NSInteger)requestPk {
	NSString* selectStatement = [NSString stringWithFormat:@"SELECT * FROM messages WHERE pk = %d", requestPk];
	MessageModel* model = [[[MessageModel alloc] init] autorelease];
	[[WebgnosusDbi instance] selectForModel:[MessageModel class] withStatement:selectStatement andOutputTo:model];
    if (model.pk == 0) {
        model = nil;
    }
	return model;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (MessageModel*)findEventByNode:(NSString*)requestNode andItemId:(NSString*)requestItemId andAccount:(AccountModel*)requestAccount {
	NSString* selectStatement = [NSString stringWithFormat:@"SELECT * FROM messages WHERE node = '%@' AND itemId = '%@' AND accountPk = %d", requestNode, requestItemId, requestAccount.pk];
	MessageModel* model = [[[MessageModel alloc] init] autorelease];
	[[WebgnosusDbi instance] selectForModel:[MessageModel class] withStatement:selectStatement andOutputTo:model];
    if (model.pk == 0) {
        model = nil;
    }
	return model;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)markReadByFromJid:(NSString*)requestFromJid textType:(MessageTextType)requestTextType andAccount:(AccountModel*)requestAccount {
	NSString* updateStatement = [NSString stringWithFormat:@"UPDATE messages SET messageRead = 1 WHERE fromJid = '%@' AND textType = %d AND accountPk = %d", requestFromJid, requestTextType, requestAccount.pk];
	[[WebgnosusDbi instance]  updateWithStatement:updateStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)destroyAllByAccount:(AccountModel*)requestAccount {
	NSString* deleteStatement = [NSString stringWithFormat:@"DELETE FROM messages WHERE accountPk = %d", requestAccount.pk];
	[[WebgnosusDbi instance]  updateWithStatement:deleteStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)insert:(XMPPClient*)client message:(XMPPMessage*)message {
    if ([message hasBody]) {
        AccountModel* account = [XMPPMessageDelegate accountForXMPPClient:client];
        if (account) {
            MessageModel* messageModel = [[MessageModel alloc] init];
            messageModel.fromJid = [[message fromJID] full];
            messageModel.accountPk = account.pk;
            messageModel.messageText = [message body];
            messageModel.toJid = [account fullJID];
            messageModel.createdAt = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
            messageModel.textType = MessageTextTypeBody;
            messageModel.node = @"";
            messageModel.itemId = @"-1";
            messageModel.messageRead = NO;
            [messageModel insert];
            [messageModel release];
        }
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)insertEvent:(XMPPClient*)client forMessage:(XMPPMessage*)message {
    XMPPPubSubEvent* event = [message event];
    [self insert:client pubSubItems:[event items] fromJID:[message fromJID] withReadFlag:NO];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)insertPubSubItems:(XMPPClient*)client forIq:(XMPPIQ*)iq {
    XMPPPubSub* pubsub = [iq pubsub];
    [self insert:client pubSubItems:[pubsub items] fromJID:[iq fromJID] withReadFlag:YES];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)insert:(XMPPClient*)client commandResult:(XMPPIQ*)iq {
    XMPPCommand* command = [iq command];
    if (command) {
        AccountModel* account = [XMPPMessageDelegate accountForXMPPClient:client];
        if (account) {
            MessageModel* messageModel = [[MessageModel alloc] init];
            messageModel.fromJid = [[iq fromJID] full];
            messageModel.accountPk = account.pk;
            messageModel.toJid = [account fullJID];
            messageModel.createdAt = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
            messageModel.textType = MessageTextTypeCommandXData;
            messageModel.node = [command node];
            messageModel.itemId = @"-1";
            messageModel.messageRead = NO;
            XMPPxData* cmdData = [command data];
            if (cmdData) {
                messageModel.messageText = [cmdData XMLString];
            } else {
                messageModel.messageText = [command status];
            }
            [messageModel insert];
            [messageModel release];            
        }
    }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//-----------------------------------------------------------------------------------------------------------------------------------
- (AccountModel*)account {
	AccountModel* model = nil;
	if (self.accountPk) {
		model = [AccountModel findByPk:self.accountPk];
	}
	return model;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)createdAtAsString {
    return [self.createdAt description];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insert {
    NSString* insertStatement;
    if (self.node && self.itemId) {
        insertStatement = [NSString stringWithFormat:@"INSERT INTO messages (messageText, createdAt, toJid, fromJid, textType, node, itemId, messageRead, accountPk) values ('%@', '%@', '%@', '%@', %d, '%@', '%@', %d, %d)", 
                            self.messageText, [self createdAtAsString], self.toJid, self.fromJid, self.textType, self.node, self.itemId, [self messageReadAsInteger], self.accountPk];	
    } else if (self.node) {
        insertStatement = [NSString stringWithFormat:@"INSERT INTO messages (messageText, createdAt, toJid, fromJid, textType, node, messageRead, accountPk) values ('%@', '%@', '%@', '%@', %d, '%@', %d, %d)", 
                           self.messageText, [self createdAtAsString], self.toJid, self.fromJid, self.textType, self.node, [self messageReadAsInteger], self.accountPk];	
    } else if (self.itemId) {
        insertStatement = [NSString stringWithFormat:@"INSERT INTO messages (messageText, createdAt, toJid, fromJid, textType, itemId, messageRead, accountPk) values ('%@', '%@', '%@', '%@', %d, '%@', %d, %d)", 
                           self.messageText, [self createdAtAsString], self.toJid, self.fromJid, self.textType, self.itemId, [self messageReadAsInteger], self.accountPk];	
    } else {
        insertStatement = [NSString stringWithFormat:@"INSERT INTO messages (messageText, createdAt, toJid, fromJid, textType, messageRead, accountPk) values ('%@', '%@', '%@', '%@', %d, %d, %d)", 
                           self.messageText, [self createdAtAsString], self.toJid, self.fromJid, self.textType, [self messageReadAsInteger], self.accountPk];	
    }
	[[WebgnosusDbi instance]  updateWithStatement:insertStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)update {
    NSString* updateStatement;
    if (self.node && self.itemId) {
        updateStatement = [NSString stringWithFormat:@"UPDATE messages SET messageText = '%@', createdAt = '%@', toJid = '%@', fromJid = '%@', textType = %d, node = '%@', itemId = '%@', messageRead = '%d', accountPk = %d WHERE pk = %d", 
                            self.messageText, [self createdAtAsString], self.toJid, self.fromJid, self.textType, self.node, self.itemId, [self messageReadAsInteger], self.accountPk, self.pk];	
    } else if (self.node) {
        updateStatement = [NSString stringWithFormat:@"UPDATE messages SET messageText = '%@', createdAt = '%@', toJid = '%@', fromJid = '%@', textType = %d, node = '%@', messageRead = '%d', accountPk = %d WHERE pk = %d", 
                           self.messageText, [self createdAtAsString], self.toJid, self.fromJid, self.textType, self.node, [self messageReadAsInteger], self.accountPk, self.pk];	
    } else if (self.itemId) {
        updateStatement = [NSString stringWithFormat:@"UPDATE messages SET messageText = '%@', createdAt = '%@', toJid = '%@', fromJid = '%@', textType = %d, itemId = '%@', messageRead = '%d', accountPk = %d WHERE pk = %d", 
                           self.messageText, [self createdAtAsString], self.toJid, self.fromJid, self.textType, self.itemId, [self messageReadAsInteger], self.accountPk, self.pk];	
    } else {
        updateStatement = [NSString stringWithFormat:@"UPDATE messages SET messageText = '%@', createdAt = '%@', toJid = '%@', fromJid = '%@', textType = %d, messageRead = '%d', accountPk = %d WHERE pk = %d", 
                           self.messageText, [self createdAtAsString], self.toJid, self.fromJid, self.textType, [self messageReadAsInteger], self.accountPk, self.pk];	
    }
	[[WebgnosusDbi instance]  updateWithStatement:updateStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)destroy {	
	NSString* insertStatement = [NSString stringWithFormat:@"DELETE FROM messages WHERE pk = %d", self.pk];	
	[[WebgnosusDbi instance]  updateWithStatement:insertStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)messageReadAsInteger {
	return self.messageRead == YES ? 1 : 0;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setMessageReadAsInteger:(NSInteger)value {
	if (value == 1) {
		self.messageRead = YES; 
	} else {
		self.messageRead = NO;
	};
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPxData*)parseXDataMessage {
    XMPPxData* data = nil;
    NSXMLDocument* xmlDoc = [[[NSXMLDocument alloc] initWithXMLString:self.messageText options:0 error:nil] autorelease];
	NSXMLElement* dataElement = [xmlDoc rootElement];
    if ([[dataElement xmlns] isEqualToString:@"jabber:x:data"]) {
        data = [XMPPxData createFromElement:dataElement];
    }
    return data;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPEntry*)parseEntryMessage {
    XMPPEntry* entry = nil;
    NSXMLDocument* xmlDoc = [[[NSXMLDocument alloc] initWithXMLString:self.messageText options:0 error:nil] autorelease];
	NSXMLElement* entryElement = [xmlDoc rootElement];
    if ([[entryElement xmlns] isEqualToString:@"http://www.w3.org/2005/Atom"]) {
        entry = [XMPPEntry createFromElement:entryElement];
    }
    return entry;
}

//===================================================================================================================================
#pragma mark MessageModel PrivateApi

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setAttributesWithStatement:(sqlite3_stmt*)statement {
    self.pk = (int)sqlite3_column_int(statement, 0);
    char* messageTextVal = (char*)sqlite3_column_text(statement, 1);
    if (messageTextVal != nil) {		
        self.messageText = [[NSString alloc] initWithUTF8String:messageTextVal];
    }
    char* createdAtVal = (char*)sqlite3_column_text(statement, 2);
    if (createdAtVal != nil) {		
        self.createdAt = [[NSDate alloc] initWithString:[[NSString alloc]initWithUTF8String:createdAtVal]];
    }
    char* toJidVal = (char*)sqlite3_column_text(statement, 3);
    if (toJidVal != nil) {		
        self.toJid = [[NSString alloc] initWithUTF8String:toJidVal];
    }
    char* fromJidVal = (char*)sqlite3_column_text(statement, 4);
    if (fromJidVal != nil) {		
        self.fromJid = [[NSString alloc] initWithUTF8String:fromJidVal];
    }
    self.textType = (int)sqlite3_column_int(statement, 5);
    char* nodeVal = (char*)sqlite3_column_text(statement, 6);
    if (nodeVal != nil) {		
        self.node = [[NSString alloc] initWithUTF8String:nodeVal];
    }
    char* itemIdVal = (char*)sqlite3_column_text(statement, 7);
    if (itemIdVal != nil) {		
        self.itemId = [[NSString alloc] initWithUTF8String:itemIdVal];
    }
	[self setMessageReadAsInteger:(int)sqlite3_column_int(statement, 8)];
    self.accountPk = (int)sqlite3_column_int(statement, 9);
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)insert:(XMPPClient*)client pubSubItems:(XMPPPubSubItems*)items fromJID:(XMPPJID*)fromJID withReadFlag:(BOOL)readFlag {
    AccountModel* account = [XMPPMessageDelegate accountForXMPPClient:client];
    if (account) {
        NSArray* itemsArray = [items toArray];
        NSString* itemsNode = [items node];
        for (int i = 0; i < [itemsArray count]; i++) {
            XMPPPubSubItem* item = [XMPPPubSubItem createFromElement:[itemsArray objectAtIndex:i]];
            if (![MessageModel findEventByNode:itemsNode andItemId:[item itemId] andAccount:account]) {
                MessageModel* messageModel = [[MessageModel alloc] init];
                messageModel.fromJid = [fromJID full];
                messageModel.accountPk = account.pk;
                messageModel.toJid = [account fullJID];
                messageModel.createdAt = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
                messageModel.node = itemsNode;
                messageModel.itemId = [item itemId];
                messageModel.messageRead = readFlag;
                XMPPxData* data = [item data];
                XMPPEntry* entry = [item entry];
                if (data) {
                    messageModel.textType = MessageTextTypeEventxData;
                    messageModel.messageText = [data XMLString];
                } else if (entry) {
                    messageModel.textType = MessageTextTypeEventEntry;
                    messageModel.messageText = [entry XMLString];
                } else {
                    messageModel.textType = MessageTextTypeEventText;
                    messageModel.messageText = [[[item children] objectAtIndex:0] XMLString];
                }
                [messageModel insert];
                [messageModel release];
            }
        }
    }
}

//===================================================================================================================================
#pragma mark WebgnosusDbiDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)collectAllFromResult:(sqlite3_stmt*)result andOutputTo:(NSMutableArray*)output {
	MessageModel* model = [[MessageModel alloc] init];
	[model setAttributesWithStatement:result];
	[output addObject:model];
    [model release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)collectFromResult:(sqlite3_stmt*)result andOutputTo:(id)output {
	[output setAttributesWithStatement:result];
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
