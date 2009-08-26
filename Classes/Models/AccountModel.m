//
//  AccountModel.m
//  webgnosus
//
//  Created by Troy Stribling on 1/6/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "AccountModel.h"
#import "ContactModel.h"
#import "RosterItemModel.h"
#import "MessageModel.h"
#import "SubscriptionModel.h"
#import "ServiceModel.h"
#import "ServiceFeatureModel.h"
#import "ServiceItemModel.h"
#import "WebgnosusDbi.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface AccountModel (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation AccountModel

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize password;
@synthesize activated;
@synthesize connectionState;
@synthesize port;

//===================================================================================================================================
#pragma mark AccountModel

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)count {
	return [[WebgnosusDbi instance]  selectIntExpression:@"SELECT COUNT(pk) FROM accounts"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)activateCount {
	return [[WebgnosusDbi instance]  selectIntExpression:@"SELECT COUNT(pk) FROM accounts WHERE activated = 1"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)drop {
	[[WebgnosusDbi instance]  updateWithStatement:@"DROP TABLE accounts"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)create {
	[[WebgnosusDbi instance]  updateWithStatement:@"CREATE TABLE accounts (pk integer primary key, jid text, password text, resource text, nickname text, host text, activated integer, connectionState integer, port integer)"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAll {
	NSMutableArray* output = [[NSMutableArray alloc] initWithCapacity:10];	
	[[WebgnosusDbi instance] selectAllForModel:[AccountModel class] withStatement:@"SELECT * FROM accounts" andOutputTo:output];
	return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (AccountModel*)findFirst {
	AccountModel* model = [[AccountModel alloc] init];
	[[WebgnosusDbi instance] selectForModel:[AccountModel class] withStatement:@"SELECT * FROM accounts LIMIT 1" andOutputTo:model];
	return model;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (AccountModel*)findByJid:(NSString*)requestJid andResource:(NSString*)requestResource {
	NSString *selectStatement;
	if (requestResource) {
		selectStatement = [[NSString alloc] initWithFormat:@"SELECT * FROM accounts WHERE jid = '%@' AND resource = '%@'", requestJid, requestResource];
	} else {
		selectStatement = [[NSString alloc] initWithFormat:@"SELECT * FROM accounts WHERE jid = '%@' AND resource IS NULL", requestJid];
	}
	AccountModel* model = [[AccountModel alloc] init];
	[[WebgnosusDbi instance] selectForModel:[AccountModel class] withStatement:selectStatement andOutputTo:model];
    [selectStatement release];
    if (model.pk == 0) {
        model = nil;
    }
	return model;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (AccountModel*)findByFullJid:(NSString*)requestFullJid {
	NSString *selectStatement;
	NSArray* splitJid = [requestFullJid componentsSeparatedByString:@"/"];
	if ([splitJid count] > 1) {
        NSInteger resourceCount = [splitJid count] - 1;
        id* resourceList = calloc(resourceCount, sizeof(id));
        [splitJid getObjects:resourceList range:NSMakeRange(1, resourceCount)];
        NSArray* resourceArray = [NSArray arrayWithObjects:resourceList count:resourceCount];
        NSString* resourceString = [resourceArray componentsJoinedByString:@"/"];
		selectStatement = [[NSString alloc] initWithFormat:@"SELECT * FROM accounts WHERE jid = '%@' AND resource = '%@'", 
                               [splitJid objectAtIndex:0], resourceString];
	} else {
		selectStatement = [[NSString alloc] initWithFormat:@"SELECT * FROM accounts WHERE jid = '%@' AND resource IS NULL", 
                               [splitJid objectAtIndex:0]];
	}
	AccountModel* model = [[AccountModel alloc] init];
	[[WebgnosusDbi instance] selectForModel:[AccountModel class] withStatement:selectStatement andOutputTo:model];
    [selectStatement release];
    if (model.pk == 0) {
        model = nil;
    }
	return model;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (AccountModel*)findByPk:(NSInteger)requestPk {
	NSString *selectStatement = 
		[[NSString alloc] initWithFormat:@"SELECT * FROM accounts WHERE pk = %d", requestPk];
	AccountModel* model = [[AccountModel alloc] init];
	[[WebgnosusDbi instance] selectForModel:[AccountModel class] withStatement:selectStatement andOutputTo:model];
    [selectStatement release];
    if (model.pk == 0) {
       model = nil;
    }
	return model;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAllActivated {
	NSMutableArray* output = [[NSMutableArray alloc] initWithCapacity:10];	
	[[WebgnosusDbi instance] selectAllForModel:[AccountModel class] withStatement:@"SELECT * FROM accounts WHERE activated = 1" andOutputTo:output];
	return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAllActivatedByConnectionState:(AccountConnectionState)state {
	NSMutableArray* output = [[NSMutableArray alloc] initWithCapacity:10];	
	NSString* selectStatement = [[NSString alloc] initWithFormat:@"SELECT * FROM accounts WHERE activated = 1 AND connectionState = %d", state];
	[[WebgnosusDbi instance] selectAllForModel:[AccountModel class] withStatement:selectStatement andOutputTo:output];
    return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (BOOL)triedToConnectAll { 
    NSUInteger count = [[WebgnosusDbi instance]  selectIntExpression:@"SELECT COUNT(pk) FROM accounts WHERE connectionState < 3"];
    return count == 0 ? YES : NO;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAllReady {
	NSMutableArray* output = [[NSMutableArray alloc] initWithCapacity:10];	
	[[WebgnosusDbi instance] selectAllForModel:[AccountModel class] withStatement:@"SELECT * FROM accounts WHERE activated = 1 AND connectionState  = 3" andOutputTo:output];
    return output;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insert {
	NSString* insertStatement;
	if (self.resource) {
		insertStatement = 
			[[NSString alloc] initWithFormat:@"INSERT INTO accounts (jid, password, resource, nickname, host, activated, connectionState, port) values ('%@', '%@', '%@', '%@', '%@', %d, %d, %d)",
                self.jid, self.password, self.resource, self.nickname, self.host, [self activatedAsInteger], self.connectionState, self.port];	
	} else {
		insertStatement = 
			[[NSString alloc] initWithFormat:@"INSERT INTO accounts (jid, password, resource, nickname, host, activated, connectionState, port) values ('%@', '%@', null, '%@', '%@', %d, %d, %d)", 
                self.jid, self.password, self.nickname, self.host, [self activatedAsInteger], self.connectionState, self.port];	
	}
	[[WebgnosusDbi instance]  updateWithStatement:insertStatement];
    [insertStatement release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)update {
	NSString* updateStatement;
	if (self.resource) {
		updateStatement = 
			[[NSString alloc] initWithFormat:@"UPDATE accounts SET jid = '%@', password = '%@', resource = '%@', nickname = '%@', host = '%@', activated = %d, connectionState = %d, port = %d WHERE pk = %d", 
                 self.jid, self.password, self.resource, self.nickname, self.host, [self activatedAsInteger], self.connectionState, self.port, self.pk];	
	} else {
		updateStatement = 
			[[NSString alloc] initWithFormat:@"UPDATE accounts SET jid = '%@', password = '%@', nickname = '%@', host = '%@', activated = %d, connectionState = %d, port = %d WHERE pk = %d", 
                 self.jid, self.password, self.nickname, self.host, [self activatedAsInteger], self.connectionState, self.port, self.pk];	
	}
	[[WebgnosusDbi instance]  updateWithStatement:updateStatement];
    [updateStatement release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)activatedAsInteger {
	return self.activated == YES ? 1 : 0;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setActivatedAsInteger:(NSInteger)value {
	if (value == 1) {
		self.activated = YES; 
	} else {
		self.activated = NO;
	};
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)destroy {	
    [ContactModel destroyAllByAccount:self];
    [RosterItemModel destroyAllByAccount:self];
    [MessageModel destroyAllByAccount:self];
    [ServiceFeatureModel destroyAllByAccount:self];
    [ServiceItemModel destroyAllByAccount:self];
    [ServiceModel destroyAllByAccount:self];
    [SubscriptionModel destroyAllByAccount:self];
	NSString *insertStatement = [[NSString alloc] initWithFormat:@"DELETE FROM accounts WHERE pk = %d", self.pk];	
	[[WebgnosusDbi instance]  updateWithStatement:insertStatement];
    [insertStatement release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)load {
	NSString* selectStatement;
	if (self.resource) {
		selectStatement = [[NSString alloc] initWithFormat:@"SELECT * FROM accounts WHERE jid = '%@' AND host = '%@' AND resource = '%@'", self.jid, self.host, self.resource];
	} else {
		selectStatement = [[NSString alloc] initWithFormat:@"SELECT * FROM accounts WHERE jid = '%@' AND host = '%@'", self.jid, self.host];
	}
	[[WebgnosusDbi instance] selectForModel:[AccountModel class] withStatement:selectStatement andOutputTo:self];
    [selectStatement release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)isReady {
    if (self.connectionState == AccountAuthenticated || self.connectionState == AccountRosterUpdated) {
        return YES;
    } 
    return NO;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)hasError {
    if (self.connectionState > AccountRosterUpdated) {
        return YES;
    }
    return NO;
}

//===================================================================================================================================
#pragma mark AccountModel PrivateAPI

//===================================================================================================================================
#pragma mark WebgnosusDbiDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setAttributesWithStatement:(sqlite3_stmt*)statement {
	self.pk = (int)sqlite3_column_int(statement, 0);
	char* jidVal = (char*)sqlite3_column_text(statement, 1);
	if (jidVal != nil) {		
		self.jid = [[NSString alloc] initWithUTF8String:jidVal];
	}
	char* passwordVal = (char*)sqlite3_column_text(statement, 2);
	if (passwordVal != nil) {
		self.password = [[NSString alloc] initWithUTF8String:passwordVal];
	}
	char* resourceVal = (char*)sqlite3_column_text(statement, 3);
	if (resourceVal != nil) {
		self.resource = [[NSString alloc] initWithUTF8String:resourceVal];
	}
	char* nicknameVal = (char*)sqlite3_column_text(statement, 4);
	if (nicknameVal != nil) {
		self.nickname = [[NSString alloc] initWithUTF8String:nicknameVal];
	}
	char* hostVal = (char*)sqlite3_column_text(statement, 5);
	if (hostVal != nil) {
		self.host = [[NSString alloc] initWithUTF8String:hostVal];
	}
	[self setActivatedAsInteger:(int)sqlite3_column_int(statement, 6)];
	self.connectionState = (int)sqlite3_column_int(statement, 7);
	self.port = (int)sqlite3_column_int(statement, 8);
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)collectAllFromResult:(sqlite3_stmt*)result andOutputTo:(NSMutableArray*)output {
	AccountModel* model = [[AccountModel alloc] init];
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


@end
