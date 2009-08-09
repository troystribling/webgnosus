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
@synthesize type;
@synthesize priority;
@synthesize accountPk;

//===================================================================================================================================
#pragma mark RosterItemModel

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)count {
	return [[WebgnosusDbi instance]  selectIntExpression:@"SELECT COUNT(pk) FROM roster"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)countByJid:(NSString*)bareJid andAccount:(AccountModel*)account {
	NSString* selectStatement = [[NSString alloc] initWithFormat:@"SELECT COUNT(pk)  FROM roster WHERE jid = '%@' AND accountPk = %d", bareJid, account.pk];
    NSInteger count = [[WebgnosusDbi instance]  selectIntExpression:selectStatement];;
    [selectStatement release];
	return count;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)maxPriorityForJid:(NSString*)bareJid andAccount:(AccountModel*)account {
	NSString* selectStatement = [[NSString alloc] initWithFormat:@"SELECT MAX(priority) FROM roster WHERE jid = '%@' AND accountPk = %d AND type = 'available'", bareJid, account.pk];
    NSInteger maxVal = [[WebgnosusDbi instance]  selectIntExpression:selectStatement];
    [selectStatement release];
	return maxVal;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)drop {
	[[WebgnosusDbi instance]  updateWithStatement:@"DROP TABLE roster"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)create {
	[[WebgnosusDbi instance]  updateWithStatement:@"CREATE TABLE roster (pk integer primary key, jid text, resource text, host text, status text, show text, type text, priority integer, clientName text, clientVersion text, accountPk integer, FOREIGN KEY (accountPk) REFERENCES accounts(pk))"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAll {
	NSMutableArray* output = [[NSMutableArray alloc] initWithCapacity:10];	
		[[WebgnosusDbi instance] selectAllForModel:[RosterItemModel class] withStatement:@"SELECT * FROM roster" andOutputTo:output];
	return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAllByAccount:(AccountModel*)account {
	NSMutableArray* output = [[NSMutableArray alloc] initWithCapacity:10];	
	NSString *selectStatement = 
        [[NSString alloc] initWithFormat:@"SELECT * FROM roster WHERE accountPk = %d", account.pk];
	[[WebgnosusDbi instance] selectAllForModel:[RosterItemModel class] withStatement:selectStatement andOutputTo:output];
    [selectStatement release];
	return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAllResourcesByAccount:(AccountModel*)account {
	NSMutableArray* output = [[NSMutableArray alloc] initWithCapacity:10];	
	NSString *selectStatement = 
        [[NSString alloc] initWithFormat:@"SELECT * FROM roster WHERE jid = '%@' AND accountPk = %d AND resource <> '%@'", account.jid, account.pk, account.resource];
	[[WebgnosusDbi instance] selectAllForModel:[RosterItemModel class] withStatement:selectStatement andOutputTo:output];
    [selectStatement release];
	return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAllByJid:(NSString*)bareJid andAccount:(AccountModel*)account {
	NSMutableArray* output = [[NSMutableArray alloc] initWithCapacity:10];	
	NSString *selectStatement = 
        [[NSString alloc] initWithFormat:@"SELECT * FROM roster WHERE jid = '%@' AND accountPk = %d", bareJid, account.pk];
	[[WebgnosusDbi instance] selectAllForModel:[RosterItemModel class] withStatement:selectStatement andOutputTo:output];
    [selectStatement release];
	return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (RosterItemModel*)findByPk:(NSInteger)requestPk {
	NSString *selectStatement = 
    [[NSString alloc] initWithFormat:@"SELECT * FROM roster WHERE pk = %d", requestPk];
	RosterItemModel* model = [[RosterItemModel alloc] init];
	[[WebgnosusDbi instance] selectForModel:[RosterItemModel class] withStatement:selectStatement andOutputTo:model];
    if (model.pk == 0) {
        model = nil;
    }
    [selectStatement release];
	return model;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (RosterItemModel*)findByFullJid:(NSString*)requestFullJid andAccount:(AccountModel*)account {
	NSString *selectStatement;
	NSArray* splitJid = [requestFullJid componentsSeparatedByString:@"/"];
	if ([splitJid count] > 1) {
        NSInteger resourceCount = [splitJid count] - 1;
        id* resourceList = calloc(resourceCount, sizeof(id));
        [splitJid getObjects:resourceList range:NSMakeRange(1, resourceCount)];
        NSArray* resourceArray = [NSArray arrayWithObjects:resourceList count:resourceCount];
        NSString* resourceString = [resourceArray componentsJoinedByString:@"/"];
		selectStatement = [[NSString alloc] initWithFormat:@"SELECT * FROM roster WHERE jid = '%@' AND resource = '%@' AND accountPk = %d", 
                               [splitJid objectAtIndex:0], resourceString, account.pk];
	} else {
		selectStatement = [[NSString alloc] initWithFormat:@"SELECT * FROM roster WHERE jid = '%@' AND resource IS NULL AND accountPk = %d", 
                               [splitJid objectAtIndex:0], account.pk];
	}
	RosterItemModel* model = [[RosterItemModel alloc] init];
	[[WebgnosusDbi instance] selectForModel:[RosterItemModel class] withStatement:selectStatement andOutputTo:model];
    [selectStatement release];
    if (model.pk == 0) {
        model = nil;
    }
	return model;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (RosterItemModel*)findWithMaxPriorityByJid:(NSString*)bareJid andAccount:(AccountModel*)account {
	NSString *selectStatement = [[NSString alloc] initWithFormat:@"SELECT * FROM roster WHERE jid = '%@' AND accountPk = %d AND type = 'available' AND clientName = 'AgnetXMPP' AND priority = (SELECT MAX(priority) FROM roster WHERE jid = '%@' AND accountPk = %d) ORDER BY clientName ASC LIMIT 1", bareJid, account.pk, bareJid, account.pk];
	RosterItemModel* agentXMppModel = [[RosterItemModel alloc] init];
	[[WebgnosusDbi instance] selectForModel:[RosterItemModel class] withStatement:selectStatement andOutputTo:agentXMppModel];
    if (agentXMppModel.pk == 0) {
        agentXMppModel = nil;
    }
	selectStatement = [[NSString alloc] initWithFormat:@"SELECT * FROM roster WHERE jid = '%@' AND accountPk = %d AND type = 'available' AND priority = (SELECT MAX(priority) FROM roster WHERE jid = '%@' AND accountPk = %d) ORDER BY clientName ASC LIMIT 1", bareJid, account.pk, bareJid, account.pk];
	RosterItemModel* model = [[RosterItemModel alloc] init];
	[[WebgnosusDbi instance] selectForModel:[RosterItemModel class] withStatement:selectStatement andOutputTo:model];
    [selectStatement release];
    if (model.pk == 0) {
        model = nil;
    }
    if (agentXMppModel && model) {
        if (model.priority == agentXMppModel.priority)
        {
            model = agentXMppModel;
        }
    }
	return model;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)destroyAllByAccount:(AccountModel*)account {
	NSString* deleteStatement = 
        [[NSString alloc] initWithFormat:@"DELETE FROM roster WHERE accountPk = %d", account.pk];
	[[WebgnosusDbi instance]  updateWithStatement:deleteStatement];
    [deleteStatement release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (BOOL)isJidAvailable:(NSString*)bareJid {
    BOOL isAvailable = NO;
   	NSMutableArray* rosterItems = [[NSMutableArray alloc] initWithCapacity:10];	
	NSString *selectStatement = 
        [[NSString alloc] initWithFormat:@"SELECT * FROM roster WHERE jid = '%@' AND type = 'available'", bareJid];
	[[WebgnosusDbi instance] selectAllForModel:[RosterItemModel class] withStatement:selectStatement andOutputTo:rosterItems];    
    [selectStatement release];
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
            [[NSString alloc] initWithFormat:@"INSERT INTO roster (jid, resource, host, status, show, type, priority, clientName, clientVersion, accountPk) values ('%@', '%@', '%@', null, null, null, null, null, null, %d)", 
                 self.jid, self.resource, self.host, self.accountPk];	
    } else {
        insertStatement = 
            [[NSString alloc] initWithFormat:@"INSERT INTO roster (jid, resource, host, status, show, type, priority, clientName, clientVersion, accountPk) values ('%@', null, '%@', null, null, null, null, null, null, %d)", 
                 self.jid, self.host, self.accountPk];	
    }
	[[WebgnosusDbi instance]  updateWithStatement:insertStatement];
    [insertStatement release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)update {
    NSString *updateStatement;
    if (self.resource) {
        updateStatement = 
            [[NSString alloc] initWithFormat:@"UPDATE roster SET jid = '%@', resource = '%@', host = '%@', status = '%@', show = '%@', type = '%@', priority = %d, clientName = '%@', clientVersion = '%@', accountPk = %d WHERE pk = %d", 
                 self.jid, self.resource, self.host, self.status, self.show, self.type, self.priority, self.clientName, self.clientVersion, self.accountPk, self.pk];	
    } else {
        updateStatement = 
            [[NSString alloc] initWithFormat:@"UPDATE roster SET jid = '%@', host = '%@', status = '%@', show = '%@', type = '%@', priority = %d, clientName = '%@', clientVersion = '%@', accountPk = %d WHERE pk = %d", 
                 self.jid, self.host, self.status, self.show, self.type, self.priority, self.clientName, self.clientVersion, self.accountPk, self.pk];	
    }
	[[WebgnosusDbi instance]  updateWithStatement:updateStatement];
    [updateStatement release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)destroy {	
	NSString *insertStatement = 
		[[NSString alloc] initWithFormat:@"DELETE FROM roster WHERE pk = %d", self.pk];	
	[[WebgnosusDbi instance]  updateWithStatement:insertStatement];
    [insertStatement release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)load {
	NSString* selectStatement;
    if (self.resource) {
		selectStatement = [[NSString alloc] initWithFormat:@"SELECT * FROM roster WHERE jid = '%@' AND resource = '%@' AND accountPk = %d", self.jid, self.resource, self.accountPk];
    } else {
		selectStatement = [[NSString alloc] initWithFormat:@"SELECT * FROM roster WHERE jid = '%@' AND accountPk = %d", self.jid, self.accountPk];
    }
	[[WebgnosusDbi instance] selectForModel:[RosterItemModel class] withStatement:selectStatement andOutputTo:self];
    [selectStatement release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)isAvailable {
    BOOL rosterItemIsAvailable = NO;
    if ([self.type isEqual:@"available"]) {
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
        self.type = [[NSString alloc] initWithUTF8String:typeVal];
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

@end
