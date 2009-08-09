//
//  SubscriptionsModel.m
//  webgnosus
//
//  Created by Troy Stribling on 8/9/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "SubscriptionsModel.h"
#import "WebgnosusDbi.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface SubscriptionsModel (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation SubscriptionsModel

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
	[[WebgnosusDbi instance]  updateWithStatement:@"CREATE TABLE subscriptions (pk integer primary key, subId integer, node text, subscription text, jid text, accountPk integer, FOREIGN KEY (accountPk) REFERENCES accounts(pk))"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAll {
	NSMutableArray* output = [[NSMutableArray alloc] initWithCapacity:10];	
	[[WebgnosusDbi instance] selectAllForModel:[SubscriptionsModel class] withStatement:@"SELECT * FROM subscriptions" andOutputTo:output];
	return output;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insert {
	NSString* insertStatement = [[NSString alloc] initWithFormat:@"INSERT INTO subscriptions (subId, node, subscription, jid, accountPk) values (%d, '%@', '%@', '%@', %d)", 
                                 self.subId, self.node, self.subscription, self.jid, self.accountPk];	
    [[WebgnosusDbi instance]  updateWithStatement:insertStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)destroy {	
	NSString *insertStatement = [[NSString alloc] initWithFormat:@"DELETE FROM subscriptions WHERE pk = %d", self.pk];	
	[[WebgnosusDbi instance]  updateWithStatement:insertStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)load {
	NSString* selectStatement = [[NSString alloc] initWithFormat:@"SELECT * FROM subscriptions WHERE node = '%@'", self.node];
	[[WebgnosusDbi instance] selectForModel:[SubscriptionsModel class] withStatement:selectStatement andOutputTo:self];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)update {
	NSString* updateStatement = 
    [[NSString alloc] initWithFormat:@"UPDATE subscriptions SET subId = %d, node = '%@', subscription = '%@', jid = '%@', accountPk = %d WHERE pk = %d", 
     self.subId, self.node, self.subscription, self.jid, self.accountPk, self.pk];	
	[[WebgnosusDbi instance]  updateWithStatement:updateStatement];
}

//===================================================================================================================================
#pragma mark SubscriptionsModel PrivateAPI

//===================================================================================================================================
#pragma mark WebgnosusDbiDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setAttributesWithStatement:(sqlite3_stmt*)statement {
	self.pk = (int)sqlite3_column_int(statement, 0);
	self.subId = (int)sqlite3_column_int(statement, 1);
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
	SubscriptionsModel* model = [[SubscriptionsModel alloc] init];
	[model setAttributesWithStatement:result];
	[output addObject:model];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)collectFromResult:(sqlite3_stmt*)result andOutputTo:(id)output {
	[output setAttributesWithStatement:result];
}

//===================================================================================================================================
#pragma mark NSObject

@end
