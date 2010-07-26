//
//  RosterItemModel.m
//  webgnosus
//
//  Created by Troy Stribling on 1/20/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "RosterItemModel.h"
#import "AccountModel.h"
#import "WebgnosusDbi.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface RosterItemModel (PrivateAPI)

+ (void)destroyRosterItems:(NSMutableArray*)rosterItems;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation RosterItemModel

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize status;
@synthesize show;
@synthesize presenceType;
@synthesize priority;
@synthesize accountPk;

//===================================================================================================================================
#pragma mark RosterItemModel

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)count {
	return [[WebgnosusDbi instance]  selectIntExpression:@"SELECT COUNT(pk) FROM roster"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)countByAccount:(AccountModel*)requestAccount {
	NSString* countStatement = [NSString stringWithFormat:@"SELECT COUNT(pk) FROM roster WHERE accountPk = %d", requestAccount.pk];
	return [[WebgnosusDbi instance]  selectIntExpression:countStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)countByJid:(NSString*)bareJid andAccount:(AccountModel*)requestAccount {
	NSString* selectStatement = [NSString stringWithFormat:@"SELECT COUNT(pk)  FROM roster WHERE jid = '%@' AND accountPk = %d", bareJid, requestAccount.pk];
    NSInteger count = [[WebgnosusDbi instance]  selectIntExpression:selectStatement];;
	return count;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)maxPriorityForJid:(NSString*)bareJid andAccount:(AccountModel*)requestAccount {
	NSString* selectStatement = [NSString stringWithFormat:@"SELECT MAX(priority) FROM roster WHERE jid = '%@' AND accountPk = %d AND presenceType = 'available'", bareJid, requestAccount.pk];
    NSInteger maxVal = [[WebgnosusDbi instance]  selectIntExpression:selectStatement];
	return maxVal;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)drop {
	[[WebgnosusDbi instance]  updateWithStatement:@"DROP TABLE roster"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)create {
	[[WebgnosusDbi instance]  updateWithStatement:@"CREATE TABLE roster (pk integer primary key, jid text, resource text, host text, status text, show text, presenceType text, priority integer, clientName text, clientVersion text, accountPk integer, FOREIGN KEY (accountPk) REFERENCES accounts(pk))"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAll {
	NSMutableArray* output = [NSMutableArray arrayWithCapacity:10];	
    [[WebgnosusDbi instance] selectAllForModel:[RosterItemModel class] withStatement:@"SELECT * FROM roster" andOutputTo:output];
	return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAllByAccount:(AccountModel*)requestAccount {
	NSMutableArray* output = [NSMutableArray arrayWithCapacity:10];	
	NSString *selectStatement = [NSString stringWithFormat:@"SELECT * FROM roster WHERE accountPk = %d", requestAccount.pk];
	[[WebgnosusDbi instance] selectAllForModel:[RosterItemModel class] withStatement:selectStatement andOutputTo:output];
	return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAllResourcesByAccount:(AccountModel*)requestAccount {
	NSMutableArray* output = [NSMutableArray arrayWithCapacity:10];	
	NSString *selectStatement = [NSString stringWithFormat:@"SELECT * FROM roster WHERE jid = '%@' AND accountPk = %d", requestAccount.jid, requestAccount.pk];
	[[WebgnosusDbi instance] selectAllForModel:[RosterItemModel class] withStatement:selectStatement andOutputTo:output];
	return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAllByJid:(NSString*)bareJid andAccount:(AccountModel*)requestAccount {
	NSMutableArray* output = [NSMutableArray arrayWithCapacity:10];	
	NSString *selectStatement = [NSString stringWithFormat:@"SELECT * FROM roster WHERE jid = '%@' AND accountPk = %d", bareJid, requestAccount.pk];
	[[WebgnosusDbi instance] selectAllForModel:[RosterItemModel class] withStatement:selectStatement andOutputTo:output];
	return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAllByFullJid:(NSString*)requestFullJid andAccount:(AccountModel*)requestAccount {
	NSString* selectStatement;
	NSMutableArray* output = [NSMutableArray arrayWithCapacity:10];	
	NSArray* splitJid = [requestFullJid componentsSeparatedByString:@"/"];
	if ([splitJid count] > 1) {
        selectStatement = [NSString stringWithFormat:@"SELECT * FROM roster WHERE jid = '%@'  AND resource = '%@' AND accountPk = %d", 
                           [splitJid objectAtIndex:0], [splitJid objectAtIndex:1], requestAccount.pk];
    } else {
		selectStatement = [NSString stringWithFormat:@"SELECT * FROM roster WHERE jid = '%@' AND accountPk = %d", 
                           [splitJid objectAtIndex:0], requestAccount.pk];
    }
	[[WebgnosusDbi instance] selectAllForModel:[RosterItemModel class] withStatement:selectStatement andOutputTo:output];
	return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (RosterItemModel*)findByPk:(NSInteger)requestPk {
	NSString *selectStatement = [NSString stringWithFormat:@"SELECT * FROM roster WHERE pk = %d", requestPk];
	RosterItemModel* model = [[[RosterItemModel alloc] init] autorelease];
	[[WebgnosusDbi instance] selectForModel:[RosterItemModel class] withStatement:selectStatement andOutputTo:model];
    if (model.pk == 0) {
        model = nil;
    }
	return model;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (RosterItemModel*)findByFullJid:(NSString*)requestFullJid andAccount:(AccountModel*)requestAccount {
	NSString *selectStatement;
	NSArray* splitJid = [requestFullJid componentsSeparatedByString:@"/"];
	if ([splitJid count] > 1) {
		selectStatement = [NSString stringWithFormat:@"SELECT * FROM roster WHERE jid = '%@' AND resource = '%@' AND accountPk = %d LIMIT 1", 
                           [splitJid objectAtIndex:0], [splitJid objectAtIndex:1], requestAccount.pk];
	} else {
		selectStatement = [NSString stringWithFormat:@"SELECT * FROM roster WHERE jid = '%@' AND resource IS NULL AND accountPk = %d LIMIT 1", 
                               [splitJid objectAtIndex:0], requestAccount.pk];
	}
	RosterItemModel* model = [[[RosterItemModel alloc] init] autorelease];
	[[WebgnosusDbi instance] selectForModel:[RosterItemModel class] withStatement:selectStatement andOutputTo:model];
    if (model.pk == 0) {
        model = nil;
    }
	return model;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (RosterItemModel*)findWithMaxPriorityByJid:(NSString*)bareJid andAccount:(AccountModel*)requestAccount {
	NSString* selectStatement = [NSString stringWithFormat:@"SELECT * FROM roster WHERE jid = '%@' AND accountPk = %d AND presenceType = 'available' AND priority = (SELECT MAX(priority) FROM roster WHERE jid = '%@' AND accountPk = %d) LIMIT 1", bareJid, requestAccount.pk, bareJid, requestAccount.pk];
	RosterItemModel* model = [[[RosterItemModel alloc] init] autorelease];
	[[WebgnosusDbi instance] selectForModel:[RosterItemModel class] withStatement:selectStatement andOutputTo:model];
    if (model.pk == 0) {
        model = nil;
    }
	return model;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)destroyAllByAccount:(AccountModel*)requestAccount {
	NSString* deleteStatement = [NSString stringWithFormat:@"DELETE FROM roster WHERE accountPk = %d", requestAccount.pk];
	[[WebgnosusDbi instance]  updateWithStatement:deleteStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)destroyByFullJid:(NSString*)requestFullJid andAccount:(AccountModel*)requestAccount {
	NSString* deleteStatement;
	NSArray* splitJid = [requestFullJid componentsSeparatedByString:@"/"];
	if ([splitJid count] > 1) {
		deleteStatement = [NSString stringWithFormat:@"DELETE FROM roster WHERE jid = '%@' AND resource = '%@' AND accountPk = %d", 
                           [splitJid objectAtIndex:0], [splitJid objectAtIndex:1], requestAccount.pk];
	} else {
		deleteStatement = [NSString stringWithFormat:@"DELETE FROM roster WHERE jid = '%@' AND resource IS NULL AND accountPk = %d", 
                           [splitJid objectAtIndex:0], requestAccount.pk];
	}
	[[WebgnosusDbi instance]  updateWithStatement:deleteStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (BOOL)isJidAvailable:(NSString*)bareJid {
    BOOL isAvailable = NO;
   	NSMutableArray* rosterItems = [NSMutableArray arrayWithCapacity:10];	
	NSString *selectStatement = [NSString stringWithFormat:@"SELECT * FROM roster WHERE jid = '%@' AND presenceType = 'available'", bareJid];
	[[WebgnosusDbi instance] selectAllForModel:[RosterItemModel class] withStatement:selectStatement andOutputTo:rosterItems];    
    if ([rosterItems count] > 0) {
        isAvailable = YES;
    }
    return isAvailable;
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
- (void)insert {
	NSString* insertStatement;
    if (self.resource) {
        insertStatement = 
            [NSString stringWithFormat:@"INSERT INTO roster (jid, resource, host, status, show, presenceType, priority, clientName, clientVersion, accountPk) values ('%@', '%@', '%@', null, null, null, null, null, null, %d)", 
                 self.jid, self.resource, self.host, self.accountPk];	
    } else {
        insertStatement = 
            [NSString stringWithFormat:@"INSERT INTO roster (jid, resource, host, status, show, presenceType, priority, clientName, clientVersion, accountPk) values ('%@', null, '%@', null, null, null, null, null, null, %d)", 
                 self.jid, self.host, self.accountPk];	
    }
	[[WebgnosusDbi instance]  updateWithStatement:insertStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)update {
    NSString *updateStatement;
    if (self.resource) {
        updateStatement = 
            [NSString stringWithFormat:@"UPDATE roster SET jid = '%@', resource = '%@', host = '%@', status = '%@', show = '%@', presenceType = '%@', priority = %d, clientName = '%@', clientVersion = '%@', accountPk = %d WHERE pk = %d", 
                 self.jid, self.resource, self.host, self.status, self.show, self.presenceType, self.priority, self.clientName, self.clientVersion, self.accountPk, self.pk];	
    } else {
        updateStatement = 
            [NSString stringWithFormat:@"UPDATE roster SET jid = '%@', host = '%@', status = '%@', show = '%@', presenceType = '%@', priority = %d, clientName = '%@', clientVersion = '%@', accountPk = %d WHERE pk = %d", 
                 self.jid, self.host, self.status, self.show, self.presenceType, self.priority, self.clientName, self.clientVersion, self.accountPk, self.pk];	
    }
	[[WebgnosusDbi instance]  updateWithStatement:updateStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)destroy {	
	NSString *insertStatement = [NSString stringWithFormat:@"DELETE FROM roster WHERE pk = %d", self.pk];	
	[[WebgnosusDbi instance]  updateWithStatement:insertStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)load {
	NSString* selectStatement;
    if (self.resource) {
		selectStatement = [NSString stringWithFormat:@"SELECT * FROM roster WHERE jid = '%@' AND resource = '%@' AND accountPk = %d", self.jid, self.resource, self.accountPk];
    } else {
		selectStatement = [NSString stringWithFormat:@"SELECT * FROM roster WHERE jid = '%@' AND accountPk = %d", self.jid, self.accountPk];
    }
	[[WebgnosusDbi instance] selectForModel:[RosterItemModel class] withStatement:selectStatement andOutputTo:self];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)isAvailable {
    BOOL rosterItemIsAvailable = NO;
    if ([self.presenceType isEqual:@"available"]) {
        rosterItemIsAvailable = YES;
    }
    return rosterItemIsAvailable;
}

//===================================================================================================================================
#pragma mark RosterItemModel PrivateApi

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setAttributesWithStatement:(sqlite3_stmt*)statement {
    self.pk = (int)sqlite3_column_int(statement, 0);
    char* jidVal = (char*)sqlite3_column_text(statement, 1);
    if (jidVal != nil) {		
        self.jid = [[NSString alloc] initWithUTF8String:jidVal];
    }
    char* resourceVal = (char*)sqlite3_column_text(statement, 2);
    if (resourceVal != nil) {		
        self.resource = [[NSString alloc] initWithUTF8String:resourceVal];
    }
    char* hostVal = (char*)sqlite3_column_text(statement, 3);
    if (hostVal != nil) {		
        self.host = [[NSString alloc] initWithUTF8String:hostVal];
    }
    char* statusVal = (char*)sqlite3_column_text(statement, 4);
    if (statusVal != nil) {
        self.status = [[NSString alloc] initWithUTF8String:statusVal];
    }
    char* showVal = (char*)sqlite3_column_text(statement, 5);
    if (showVal != nil) {
        self.show = [[NSString alloc] initWithUTF8String:showVal];
    }
    char* typeVal = (char*)sqlite3_column_text(statement, 6);
    if (typeVal != nil) {
        self.presenceType = [[NSString alloc] initWithUTF8String:typeVal];
    }
    self.priority = (int)sqlite3_column_int(statement, 7);
    char* clientNameVal = (char*)sqlite3_column_text(statement, 8);
    if (clientNameVal != nil) {
        self.clientName = [[NSString alloc] initWithUTF8String:clientNameVal];
    }
    char* clientVersionVal = (char*)sqlite3_column_text(statement, 9);
    if (clientVersionVal != nil) {
        self.clientVersion = [[NSString alloc] initWithUTF8String:clientVersionVal];
    }
    self.accountPk = (int)sqlite3_column_int(statement, 10);
}

//===================================================================================================================================
#pragma mark WebgnosusDbiDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)collectAllFromResult:(sqlite3_stmt*)result andOutputTo:(NSMutableArray*)output {
	RosterItemModel* model = [[RosterItemModel alloc] init];
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
