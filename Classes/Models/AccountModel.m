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
@synthesize displayed;
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
+ (NSInteger)displayedCount {
	return [[WebgnosusDbi instance]  selectIntExpression:@"SELECT COUNT(pk) FROM accounts WHERE displayed = 1"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)drop {
	[[WebgnosusDbi instance]  updateWithStatement:@"DROP TABLE accounts"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)create {
	[[WebgnosusDbi instance]  updateWithStatement:@"CREATE TABLE accounts (pk integer primary key, jid text, password text, resource text, nickname text, host text, activated integer, displayed integer, connectionState integer, port integer)"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAll {
	NSMutableArray* output = [NSMutableArray arrayWithCapacity:10];	
	[[WebgnosusDbi instance] selectAllForModel:[AccountModel class] withStatement:@"SELECT * FROM accounts" andOutputTo:output];
	return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (AccountModel*)findFirst {
	AccountModel* model = [[[AccountModel alloc] init] autorelease];
	[[WebgnosusDbi instance] selectForModel:[AccountModel class] withStatement:@"SELECT * FROM accounts LIMIT 1" andOutputTo:model];
    if (model.pk == 0) {
        model = nil;
    }
	return model;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (AccountModel*)findFirstDisplayed {
	AccountModel* model = [[[AccountModel alloc] init] autorelease];
	[[WebgnosusDbi instance] selectForModel:[AccountModel class] withStatement:@"SELECT * FROM accounts WHERE displayed = 1 LIMIT 1" andOutputTo:model];
    if (model.pk == 0) {
        model = nil;
    }
	return model;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (AccountModel*)findByJID:(NSString*)requestJID {
	NSString* selectStatement = [NSString stringWithFormat:@"SELECT * FROM accounts WHERE jid = '%@'", requestJID];
	AccountModel* model = [[[AccountModel alloc] init] autorelease];
	[[WebgnosusDbi instance] selectForModel:[AccountModel class] withStatement:selectStatement andOutputTo:model];
    if (model.pk == 0) {
        model = nil;
    }
	return model;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (AccountModel*)findByPk:(NSInteger)requestPk {
	NSString *selectStatement = [NSString stringWithFormat:@"SELECT * FROM accounts WHERE pk = %d", requestPk];
	AccountModel* model = [[[AccountModel alloc] init] autorelease];
	[[WebgnosusDbi instance] selectForModel:[AccountModel class] withStatement:selectStatement andOutputTo:model];
    if (model.pk == 0) {
       model = nil;
    }
	return model;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAllActivated {
	NSMutableArray* output = [NSMutableArray arrayWithCapacity:10];	
	[[WebgnosusDbi instance] selectAllForModel:[AccountModel class] withStatement:@"SELECT * FROM accounts WHERE activated = 1" andOutputTo:output];
	return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAllActivatedByConnectionState:(AccountConnectionState)state {
	NSMutableArray* output = [NSMutableArray arrayWithCapacity:10];	
	NSString* selectStatement = [NSString stringWithFormat:@"SELECT * FROM accounts WHERE activated = 1 AND connectionState = %d", state];
	[[WebgnosusDbi instance] selectAllForModel:[AccountModel class] withStatement:selectStatement andOutputTo:output];
    return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (BOOL)triedToConnectAll { 
    NSUInteger count = [[WebgnosusDbi instance]  selectIntExpression:@"SELECT COUNT(pk) FROM accounts WHERE connectionState < 4"];
    return count == 0 ? YES : NO;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAllReady {
	NSMutableArray* output = [NSMutableArray arrayWithCapacity:10];	
	[[WebgnosusDbi instance] selectAllForModel:[AccountModel class] withStatement:@"SELECT * FROM accounts WHERE activated = 1 AND connectionState  = 3" andOutputTo:output];
    return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)setAllNotDisplayed {
    [[WebgnosusDbi instance]  updateWithStatement:@"UPDATE accounts SET displayed = 0 WHERE displayed = 1"];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insert {
	NSString* insertStatement;
	if (self.resource) {
		insertStatement = 
			[NSString stringWithFormat:@"INSERT INTO accounts (jid, password, resource, nickname, host, activated, displayed, connectionState, port) values ('%@', '%@', '%@', '%@', '%@', %d, %d, %d, %d)",
                self.jid, self.password, self.resource, self.nickname, self.host, [self activatedAsInteger], [self displayedAsInteger], self.connectionState, self.port];	
	} else {
		insertStatement = 
			[NSString stringWithFormat:@"INSERT INTO accounts (jid, password, resource, nickname, host, activated, displayed, connectionState, port) values ('%@', '%@', null, '%@', '%@', %d, %d, %d, %d)", 
                self.jid, self.password, self.nickname, self.host, [self activatedAsInteger], [self displayedAsInteger], self.connectionState, self.port];	
	}
	[[WebgnosusDbi instance]  updateWithStatement:insertStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)update {
	NSString* updateStatement;
	if (self.resource) {
		updateStatement = 
			[NSString stringWithFormat:@"UPDATE accounts SET jid = '%@', password = '%@', resource = '%@', nickname = '%@', host = '%@', activated = %d, displayed = %d, connectionState = %d, port = %d WHERE pk = %d", 
                 self.jid, self.password, self.resource, self.nickname, self.host, [self activatedAsInteger], [self displayedAsInteger], self.connectionState, self.port, self.pk];	
	} else {
		updateStatement = 
			[NSString stringWithFormat:@"UPDATE accounts SET jid = '%@', password = '%@', nickname = '%@', host = '%@', activated = %d, displayed = %d, connectionState = %d, port = %d WHERE pk = %d", 
                 self.jid, self.password, self.nickname, self.host, [self activatedAsInteger], [self displayedAsInteger], self.connectionState, self.port, self.pk];	
	}
	[[WebgnosusDbi instance]  updateWithStatement:updateStatement];
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
- (NSInteger)displayedAsInteger {
	return self.displayed == YES ? 1 : 0;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setDisplayedAsInteger:(NSInteger)value {
	if (value == 1) {
		self.displayed = YES; 
	} else {
		self.displayed = NO;
	};
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)destroy {	
    [ContactModel destroyAllByAccount:self];
    [RosterItemModel destroyAllByAccount:self];
    [MessageModel destroyAllByAccount:self];
    [SubscriptionModel destroyAllByAccount:self];
	NSString *insertStatement = [NSString stringWithFormat:@"DELETE FROM accounts WHERE pk = %d", self.pk];	
	[[WebgnosusDbi instance]  updateWithStatement:insertStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)load {
	NSString* selectStatement;
	if (self.resource) {
		selectStatement = [NSString stringWithFormat:@"SELECT * FROM accounts WHERE jid = '%@' AND host = '%@' AND resource = '%@'", self.jid, self.host, self.resource];
	} else {
		selectStatement = [NSString stringWithFormat:@"SELECT * FROM accounts WHERE jid = '%@' AND host = '%@'", self.jid, self.host];
	}
	[[WebgnosusDbi instance] selectForModel:[AccountModel class] withStatement:selectStatement andOutputTo:self];
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
	[self setDisplayedAsInteger:(int)sqlite3_column_int(statement, 7)];
	self.connectionState = (int)sqlite3_column_int(statement, 8);
	self.port = (int)sqlite3_column_int(statement, 9);
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

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
