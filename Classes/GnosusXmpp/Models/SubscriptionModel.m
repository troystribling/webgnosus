//
//  SubscriptionModel.m
//  webgnosus
//
//  Created by Troy Stribling on 8/9/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "SubscriptionModel.h"
#import "AccountModel.h"
#import "WebgnosusDbi.h"
#import "XMPPPubSubSubscription.h"
#import "XMPPJID.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface SubscriptionModel (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation SubscriptionModel

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize pk;
@synthesize accountPk;
@synthesize subId;
@synthesize node;
@synthesize service;
@synthesize subscription;
@synthesize jid;

//===================================================================================================================================
#pragma mark ServiceItemModel

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)count {
	return [[WebgnosusDbi instance]  selectIntExpression:@"SELECT COUNT(pk) FROM subscriptions"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)drop {
	[[WebgnosusDbi instance]  updateWithStatement:@"DROP TABLE subscriptions"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)create {
	[[WebgnosusDbi instance]  updateWithStatement:@"CREATE TABLE subscriptions (pk integer primary key, subId text, node text, service text, subscription text, jid text, accountPk integer, FOREIGN KEY (accountPk) REFERENCES accounts(pk))"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAll {
	NSMutableArray* output = [NSMutableArray arrayWithCapacity:10];	
	[[WebgnosusDbi instance] selectAllForModel:[SubscriptionModel class] withStatement:@"SELECT * FROM subscriptions" andOutputTo:output];
	return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAllByAccount:(AccountModel*)requestAccount {
	NSMutableArray* output = [NSMutableArray arrayWithCapacity:10];	
	NSString *selectStatement = [NSString stringWithFormat:@"SELECT * FROM subscriptions WHERE accountPk = %d", requestAccount.pk];
	[[WebgnosusDbi instance] selectAllForModel:[SubscriptionModel class] withStatement:selectStatement andOutputTo:output];
	return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAllByAccount:(AccountModel*)requestAccount andNode:(NSString*)requestNode {
	NSMutableArray* output = [NSMutableArray arrayWithCapacity:10];	
    NSString* selectStatement = [NSString stringWithFormat:@"SELECT * FROM subscriptions WHERE node ='%@' AND accountPk = %d",  requestNode, requestAccount.pk];
	[[WebgnosusDbi instance] selectAllForModel:[SubscriptionModel class] withStatement:selectStatement andOutputTo:output];
	return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (SubscriptionModel*)findByAccount:(AccountModel*)requestAccount node:(NSString*)requestNode andSubId:(NSString*)requestSubId {
    NSString* selectStatement = [NSString stringWithFormat:@"SELECT * FROM subscriptions WHERE node ='%@' AND accountPk = %d AND subId= '%@'",  requestNode, requestAccount.pk, requestSubId];
	SubscriptionModel* model = [[[SubscriptionModel alloc] init] autorelease];
	[[WebgnosusDbi instance] selectForModel:[SubscriptionModel class] withStatement:selectStatement andOutputTo:model];
    if (model.pk == 0) {
        model = nil;
    }
	return model;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSArray*)findAllServicesByAccount:(AccountModel*)requestAccount {
	NSString* seleteStatement = [NSString stringWithFormat:@"SELECT DISTINCT service FROM subscriptions WHERE  accountPk = %d", requestAccount.pk];
	return [[WebgnosusDbi instance]  selectAllTextColumn:seleteStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)destroyAll {
	NSString* deleteStatement = [NSString stringWithFormat:@"DELETE FROM subscriptions"];
	[[WebgnosusDbi instance]  updateWithStatement:deleteStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)destroyAllByAccount:(AccountModel*)requestAccount {
	NSString* deleteStatement = [NSString stringWithFormat:@"DELETE FROM subscriptions WHERE accountPk = %d", requestAccount.pk];
	[[WebgnosusDbi instance]  updateWithStatement:deleteStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)insert:(XMPPPubSubSubscription*)insertSub forService:(NSString*)serviceJID andAccount:(AccountModel*)insertAccount {
    [self insert:insertSub forService:serviceJID node:[insertSub node] andAccount:insertAccount];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)insert:(XMPPPubSubSubscription*)insertSub forService:(NSString*)serviceJID node:insertNone andAccount:(AccountModel*)insertAccount {
    SubscriptionModel* model = [SubscriptionModel findByAccount:insertAccount node:[insertSub node] andSubId:[insertSub subId]];
    if (!model) {
        SubscriptionModel* subModel = [[SubscriptionModel alloc] init];
        if ([insertSub JID]) {
            subModel.jid = [[insertSub JID] full];
        }
        if ([insertSub subId]) {
            subModel.subId = [insertSub subId];
        } else {
            subModel.subId =@"-1";
        }
        subModel.accountPk = insertAccount.pk;
        subModel.node = insertNone;
        subModel.service = serviceJID;
        subModel.subscription = [insertSub subscription];
        [subModel insert];
        [subModel release];
    } else {
        [model update];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)destroyAllByService:(NSString*)requestService andAccount:(AccountModel*)requestAccount {
	NSString* deleteStatement = [NSString stringWithFormat:@"DELETE FROM subscriptions WHERE service = '%@' AND  accountPk = %d", requestService, requestAccount.pk];
	[[WebgnosusDbi instance]  updateWithStatement:deleteStatement];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insert {
    NSString* insertStatement;
    if (self.jid) {
        insertStatement = [NSString stringWithFormat:@"INSERT INTO subscriptions (subId, node, service, subscription, jid, accountPk) values ('%@', '%@', '%@', '%@', '%@', %d)", 
                            self.subId, self.node, self.service, self.subscription, self.jid, self.accountPk];	
    } else {
        insertStatement = [NSString stringWithFormat:@"INSERT INTO subscriptions (subId, node, service, subscription, accountPk) values ('%@', '%@', '%@', '%@', %d)", 
                           self.subId, self.node, self.service, self.subscription, self.accountPk];	
    }
    [[WebgnosusDbi instance]  updateWithStatement:insertStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)destroy {	
	NSString* destroyStatement = [NSString stringWithFormat:@"DELETE FROM subscriptions WHERE pk = %d", self.pk];	
	[[WebgnosusDbi instance]  updateWithStatement:destroyStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)load {
	NSString* selectStatement = [NSString stringWithFormat:@"SELECT * FROM subscriptions WHERE node = '%@'", self.node];
	[[WebgnosusDbi instance] selectForModel:[SubscriptionModel class] withStatement:selectStatement andOutputTo:self];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)update {
    NSString* updateStatement;
    if (self.jid) {
        updateStatement = [NSString stringWithFormat:@"UPDATE subscriptions SET subId = '%@', node = '%@', service='%@', subscription = '%@', jid = '%@', accountPk = %d WHERE pk = %d", 
            self.subId, self.node, self.service, self.subscription, self.jid, self.accountPk, self.pk];	
    } else {
        updateStatement = [NSString stringWithFormat:@"UPDATE subscriptions SET subId = '%@', node = '%@', service='%@', subscription = '%@', accountPk = %d WHERE pk = %d", 
                           self.subId, self.node, self.service, self.subscription, self.accountPk, self.pk];	
    }
	[[WebgnosusDbi instance]  updateWithStatement:updateStatement];
}

//===================================================================================================================================
#pragma mark SubscriptionModel PrivateAPI

//===================================================================================================================================
#pragma mark WebgnosusDbiDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setAttributesWithStatement:(sqlite3_stmt*)statement {
	self.pk = (int)sqlite3_column_int(statement, 0);
	char* subIdVal = (char*)sqlite3_column_text(statement, 1);
	if (subIdVal != nil) {		
		self.subId = [[NSString alloc] initWithUTF8String:subIdVal];
	}
	char* nodeVal = (char*)sqlite3_column_text(statement, 2);
	if (nodeVal != nil) {		
		self.node = [[NSString alloc] initWithUTF8String:nodeVal];
	}
	char* serviceVal = (char*)sqlite3_column_text(statement, 3);
	if (serviceVal != nil) {		
		self.service = [[NSString alloc] initWithUTF8String:serviceVal];
	}
	char* subVal = (char*)sqlite3_column_text(statement, 4);
	if (subVal != nil) {		
		self.subscription = [[NSString alloc] initWithUTF8String:subVal];
	}
	char* jidVal = (char*)sqlite3_column_text(statement, 5);
	if (jidVal != nil) {		
		self.jid = [[NSString alloc] initWithUTF8String:jidVal];
	}
	self.accountPk = (int)sqlite3_column_int(statement, 6);
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)collectAllFromResult:(sqlite3_stmt*)result andOutputTo:(NSMutableArray*)output {
	SubscriptionModel* model = [[SubscriptionModel alloc] init];
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
