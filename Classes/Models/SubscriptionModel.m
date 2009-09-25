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
	[[WebgnosusDbi instance]  updateWithStatement:@"CREATE TABLE subscriptions (pk integer primary key, subId text, node text, subscription text, jid text, accountPk integer, FOREIGN KEY (accountPk) REFERENCES accounts(pk))"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAll {
	NSMutableArray* output = [[NSMutableArray alloc] initWithCapacity:10];	
	[[WebgnosusDbi instance] selectAllForModel:[SubscriptionModel class] withStatement:@"SELECT * FROM subscriptions" andOutputTo:output];
	return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAllByAccount:(AccountModel*)requestAccount {
	NSMutableArray* output = [[NSMutableArray alloc] initWithCapacity:10];	
	NSString *selectStatement = [[NSString alloc] initWithFormat:@"SELECT * FROM subscriptions WHERE accountPk = %d", requestAccount.pk];
	[[WebgnosusDbi instance] selectAllForModel:[SubscriptionModel class] withStatement:selectStatement andOutputTo:output];
	return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (SubscriptionModel*)findByAccount:(AccountModel*)requestAccount andNode:(NSString*)requestNode {
    NSString* selectStatement = [[NSString alloc] initWithFormat:@"SELECT * FROM subscriptions WHERE node ='%@' AND accountPk = %d",  requestNode, requestAccount.pk];
	SubscriptionModel* model = [[[SubscriptionModel alloc] init] autorelease];
	[[WebgnosusDbi instance] selectForModel:[SubscriptionModel class] withStatement:selectStatement andOutputTo:model];
    [selectStatement release];
    if (model.pk == 0) {
        model = nil;
    }
	return model;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)destroyAllByAccount:(AccountModel*)requestAccount {
	NSString* deleteStatement = 
    [[NSString alloc] initWithFormat:@"DELETE FROM subscriptions WHERE accountPk = %d", requestAccount.pk];
	[[WebgnosusDbi instance]  updateWithStatement:deleteStatement];
    [deleteStatement release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)insert:(XMPPPubSubSubscription*)sub forAccount:(AccountModel*)account {
    if (account) {
        SubscriptionModel* subModel = [[SubscriptionModel alloc] init];
        subModel.accountPk = account.pk;
        subModel.node = [sub node];
        subModel.subId = [sub subId];
        subModel.jid = [[sub JID] full];
        subModel.subscription = [sub subscription];
        [subModel insert];
        [subModel release];
    }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insert {
    NSString* insertStatement;
    if (self.jid) {
        insertStatement = [[NSString alloc] initWithFormat:@"INSERT INTO subscriptions (subId, node, subscription, jid, accountPk) values (%d, '%@', '%@', '%@', %d)", 
                            self.subId, self.node, self.subscription, self.jid, self.accountPk];	
    } else {
        insertStatement = [[NSString alloc] initWithFormat:@"INSERT INTO subscriptions (subId, node, subscription, accountPk) values (%d, '%@', '%@', %d)", 
                           self.subId, self.node, self.subscription, self.accountPk];	
    }
    [[WebgnosusDbi instance]  updateWithStatement:insertStatement];
    [insertStatement release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)destroy {	
	NSString* destroyStatement = [[NSString alloc] initWithFormat:@"DELETE FROM subscriptions WHERE pk = %d", self.pk];	
	[[WebgnosusDbi instance]  updateWithStatement:destroyStatement];
    [destroyStatement release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)load {
	NSString* selectStatement = [[NSString alloc] initWithFormat:@"SELECT * FROM subscriptions WHERE node = '%@'", self.node];
	[[WebgnosusDbi instance] selectForModel:[SubscriptionModel class] withStatement:selectStatement andOutputTo:self];
    [selectStatement release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)update {
	NSString* updateStatement = 
        [[NSString alloc] initWithFormat:@"UPDATE subscriptions SET subId = %d, node = '%@', subscription = '%@', jid = '%@', accountPk = %d WHERE pk = %d", 
            self.subId, self.node, self.subscription, self.jid, self.accountPk, self.pk];	
	[[WebgnosusDbi instance]  updateWithStatement:updateStatement];
    [updateStatement release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPJID*)nodeToJID {
    NSArray* comp = [self.node componentsSeparatedByString:@"/"];
    return [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@", [comp objectAtIndex:3], [comp objectAtIndex:2]]];
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
	char* subVal = (char*)sqlite3_column_text(statement, 3);
	if (subVal != nil) {		
		self.subscription = [[NSString alloc] initWithUTF8String:subVal];
	}
	char* jidVal = (char*)sqlite3_column_text(statement, 4);
	if (jidVal != nil) {		
		self.jid = [[NSString alloc] initWithUTF8String:jidVal];
	}
	self.accountPk = (int)sqlite3_column_int(statement, 5);
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
