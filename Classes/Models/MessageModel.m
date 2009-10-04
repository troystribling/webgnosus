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
#import "RosterItemModel.h"
#import "UserModel.h"
#import "WebgnosusDbi.h"
#import "XMPPxData.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface MessageModel (PrivateAPI)

- (void)setAttributesWithStatement:(sqlite3_stmt*)statement;
- (UserModel*)findUserModel:(NSString*)jid;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation MessageModel

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize pk;
@synthesize messageText;
@synthesize createdAt;
@synthesize accountPk;
@synthesize toJid;
@synthesize fromJid;
@synthesize textType;
@synthesize node;

//===================================================================================================================================
#pragma mark MessageModel

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)count {
	return [[WebgnosusDbi instance]  selectIntExpression:@"SELECT COUNT(pk) FROM messages"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)countWithLimit:(NSInteger)requestLimit {
	NSInteger count = MIN([[WebgnosusDbi instance]  selectIntExpression:@"SELECT COUNT(pk) FROM messages"], requestLimit);
    return count;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)countByJid:(NSString*)requestJID andAccount:(AccountModel*)requestAccount {
	NSString *selectStatement = 
        [NSString stringWithFormat:@"SELECT COUNT(pk) FROM messages WHERE (toJid LIKE '%@%%' OR fromJid LIKE '%@%%') AND accountPk = %d", requestJID, requestJID, requestAccount.pk];
    NSInteger count = [[WebgnosusDbi instance] selectIntExpression:selectStatement];
	return  count;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)countByJid:(NSString*)requestJID andAccount:(AccountModel*)requestAccount withLimit:(NSInteger)requestLimit {
	NSString *selectStatement = [NSString stringWithFormat:@"SELECT COUNT(pk) FROM messages WHERE (toJid LIKE '%@%%' OR fromJid LIKE '%@%%') AND accountPk = %d ORDER BY createdAt DESC LIMIT %d", 
            requestJID, requestJID, requestAccount.pk, requestLimit];
    NSInteger count = MIN([[WebgnosusDbi instance]  selectIntExpression:selectStatement], requestLimit);
	return count;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)countByJid:(NSString*)requestJID account:(AccountModel*)requestAccount andTextType:(MessageTextType)requestType withLimit:(NSInteger)requestLimit {
	NSString *selectStatement = [NSString stringWithFormat:@"SELECT COUNT(pk) FROM messages WHERE (toJid LIKE '%@%%' OR fromJid LIKE '%@%%') AND textType = %d AND accountPk = %d ORDER BY createdAt DESC LIMIT %d", 
         requestJID, requestJID, requestType, requestAccount.pk, requestLimit];
    NSInteger count = MIN([[WebgnosusDbi instance]  selectIntExpression:selectStatement], requestLimit);
	return count;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)drop {
	[[WebgnosusDbi instance]  updateWithStatement:@"DROP TABLE messages"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)create {
	[[WebgnosusDbi instance]  updateWithStatement:@"CREATE TABLE messages (pk integer primary key, messageText text, createdAt date, toJid text, fromJid text, textType integer, node text, accountPk integer, FOREIGN KEY (accountPk) REFERENCES accounts(pk))"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAll {
	NSMutableArray* output = [NSMutableArray arrayWithCapacity:10];	
    [[WebgnosusDbi instance] selectAllForModel:[MessageModel class] withStatement:@"SELECT * FROM messages ORDER BY createdAt DESC" andOutputTo:output];
	return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAllWithLimit:(NSInteger)requestLimit {
	NSMutableArray* output = [NSMutableArray arrayWithCapacity:10];	
	NSString* selectStatement = [NSString stringWithFormat:@"SELECT * FROM messages ORDER BY createdAt DESC LIMIT %d", requestLimit];
    [[WebgnosusDbi instance] selectAllForModel:[MessageModel class] withStatement:selectStatement andOutputTo:output];
	return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAllByAccount:(AccountModel*)requestAccount {
	NSMutableArray* output = [NSMutableArray arrayWithCapacity:10];	
	NSString* selectStatement = [NSString stringWithFormat:@"SELECT * FROM messages WHERE accountPk = %d ORDER BY createdAt DESC", requestAccount.pk];
	[[WebgnosusDbi instance] selectAllForModel:[MessageModel class] withStatement:selectStatement andOutputTo:output];
	return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAllByAccount:(AccountModel*)requestAccount withLimit:(NSInteger)requestLimit {
	NSMutableArray* output = [NSMutableArray arrayWithCapacity:10];	
	NSString* selectStatement = [NSString stringWithFormat:@"SELECT * FROM messages WHERE accountPk = %d ORDER BY createdAt DESC LIMIT %d", requestAccount.pk, requestLimit];
	[[WebgnosusDbi instance] selectAllForModel:[MessageModel class] withStatement:selectStatement andOutputTo:output];
	return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAllByJid:(NSString*)requestJID andAccount:(AccountModel*)requestAccount {
	NSMutableArray* output = [NSMutableArray arrayWithCapacity:10];	
	NSString* selectStatement = [NSString stringWithFormat:@"SELECT * FROM messages WHERE (toJid LIKE '%@%%' OR fromJid LIKE '%@%%') AND accountPk = %d ORDER BY createdAt DESC", 
                                     requestJID, requestJID, requestAccount.pk];
	[[WebgnosusDbi instance] selectAllForModel:[MessageModel class] withStatement:selectStatement andOutputTo:output];
	return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAllByJid:(NSString*)requestJID account:(AccountModel*)requestAccount andTextType:(MessageTextType)requestType withLimit:(NSInteger)requestLimit {
	NSMutableArray* output = [NSMutableArray arrayWithCapacity:10];	
	NSString* selectStatement = [NSString stringWithFormat:@"SELECT * FROM messages WHERE (toJid LIKE '%@%%' OR fromJid LIKE '%@%%') AND textType = %d AND accountPk = %d ORDER BY createdAt DESC LIMIT %d", 
                                 requestJID, requestJID, requestType, requestAccount.pk, requestLimit];
	[[WebgnosusDbi instance] selectAllForModel:[MessageModel class] withStatement:selectStatement andOutputTo:output];
	return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAllCommandsByJid:(NSString*)requestJID andAccount:(AccountModel*)requestAccount withLimit:(NSInteger)requestLimit {
	NSMutableArray* output = [NSMutableArray arrayWithCapacity:10];	
	NSString* selectStatement = [NSString stringWithFormat:@"SELECT * FROM messages WHERE (toJid LIKE '%@%%' OR fromJid LIKE '%@%%') AND (textType = %d OR textType = %d) AND accountPk = %d ORDER BY createdAt DESC LIMIT %d", 
                                 requestJID, requestJID, MessageTextTypeCommandText, MessageTextTypeCommandXData, requestAccount.pk, requestLimit];
	[[WebgnosusDbi instance] selectAllForModel:[MessageModel class] withStatement:selectStatement andOutputTo:output];
	return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAllEventsByJid:(NSString*)requestJID andAccount:(AccountModel*)requestAccount withLimit:(NSInteger)requestLimit {
	NSMutableArray* output = [NSMutableArray arrayWithCapacity:10];	
	NSString* selectStatement = [NSString stringWithFormat:@"SELECT * FROM messages WHERE (toJid LIKE '%@%%' OR fromJid LIKE '%@%%') AND (textType = %d OR textType = %d OR textType = %d)  AND accountPk = %d ORDER BY createdAt DESC LIMIT %d", 
                                 requestJID, requestJID, MessageTextTypeEventText, MessageTextTypeEventEntry, MessageTextTypeEventXData, requestAccount.pk, requestLimit];
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
+ (void)destroyAllByAccount:(AccountModel*)requestAccount {
	NSString* deleteStatement = [NSString stringWithFormat:@"DELETE FROM messages WHERE accountPk = %d", requestAccount.pk];
	[[WebgnosusDbi instance]  updateWithStatement:deleteStatement];
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
    if (self.node) {
        insertStatement = [NSString stringWithFormat:@"INSERT INTO messages (messageText, createdAt, toJid, fromJid, textType, node, accountPk) values ('%@', '%@', '%@', '%@', %d, '%@', %d)", 
                            self.messageText, [self createdAtAsString], self.toJid, self.fromJid, self.textType, self.node, self.accountPk];	
    } else {
        insertStatement = [NSString stringWithFormat:@"INSERT INTO messages (messageText, createdAt, toJid, fromJid, textType, accountPk) values ('%@', '%@', '%@', '%@', %d, %d)", 
                           self.messageText, [self createdAtAsString], self.toJid, self.fromJid, self.textType, self.accountPk];	
    }
	[[WebgnosusDbi instance]  updateWithStatement:insertStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)update {
    NSString* updateStatement = [NSString stringWithFormat:@"UPDATE messages SET messageText = '%@', createdAt = '%@', toJid = '%@', fromJid = '%@', textType = %d, node = '%@', accountPk = %d WHERE pk = %d", 
                                     self.messageText, [self createdAtAsString], self.toJid, self.fromJid, self.textType, self.node, self.accountPk, self.pk];	
	[[WebgnosusDbi instance]  updateWithStatement:updateStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)destroy {	
	NSString* insertStatement = [NSString stringWithFormat:@"DELETE FROM messages WHERE pk = %d", self.pk];	
	[[WebgnosusDbi instance]  updateWithStatement:insertStatement];
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
    self.accountPk = (int)sqlite3_column_int(statement, 7);
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
