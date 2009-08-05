//
//  ContactModel.m
//  webgnosus
//
//  Created by Troy Stribling on 2/5/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "ContactModel.h"
#import "AccountModel.h"
#import "WebgnosusDbi.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ContactModel (PrivateAPI)

- (void)setAttributesWithStatement:(sqlite3_stmt*)statement;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ContactModel

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize accountPk;
@synthesize latestClient;
@synthesize contactState;

//===================================================================================================================================
#pragma mark ContactModel

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)count {
	return [[WebgnosusDbi instance]  selectIntExpression:@"SELECT COUNT(pk) FROM contacts"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)drop {
	[[WebgnosusDbi instance]  updateWithStatement:@"DROP TABLE contacts"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)create {
	[[WebgnosusDbi instance]  updateWithStatement:@"CREATE TABLE contacts (pk integer primary key, jid text, host text, nickname text, clientName text, clientVersion text, contactState integer, accountPk integer, FOREIGN KEY (accountPk) REFERENCES accounts(pk))"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAll {
	NSMutableArray* output = [[NSMutableArray alloc] initWithCapacity:10];	
    [[WebgnosusDbi instance] selectAllForModel:[ContactModel class] withStatement:@"SELECT * FROM contacts" andOutputTo:output];
	return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAllByAccount:(AccountModel*)account {
	NSMutableArray* output = [[NSMutableArray alloc] initWithCapacity:10];	
	NSString *selectStatement = 
    [[NSString alloc] initWithFormat:@"SELECT * FROM contacts WHERE accountPk = %d", account.pk];
	[[WebgnosusDbi instance] selectAllForModel:[ContactModel class] withStatement:selectStatement andOutputTo:output];
	return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (ContactModel*)findByPk:(NSInteger)requestPk {
	NSString *selectStatement = [[NSString alloc] initWithFormat:@"SELECT * FROM contacts WHERE pk = %d", requestPk];
	ContactModel* model = [[ContactModel alloc] init];
	[[WebgnosusDbi instance] selectForModel:[ContactModel class] withStatement:selectStatement andOutputTo:model];
    if (model.pk == 0) {
        model = nil;
    }
	return model;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (ContactModel*)findByJid:(NSString*)requestJid andAccount:(AccountModel*)account {
	NSString *selectStatement = [[NSString alloc] initWithFormat:@"SELECT * FROM contacts WHERE jid = '%@' AND accountPk = %d", 
                                    requestJid, account.pk];
	ContactModel* model = [[ContactModel alloc] init];
	[[WebgnosusDbi instance] selectForModel:[ContactModel class] withStatement:selectStatement andOutputTo:model];
    if (model.pk == 0) {
        model = nil;
    }
	return model;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)destroyAllByAccount:(AccountModel*)account {
	NSString* deleteStatement = 
        [[NSString alloc] initWithFormat:@"DELETE FROM contacts WHERE accountPk = %d", account.pk];
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
- (void)insert {
	NSString* insertStatement = [[NSString alloc] initWithFormat:@"INSERT INTO contacts (jid, host, nickname, clientName, clientVersion, contactState, accountPk) values ('%@', '%@', '%@', '%@', '%@', %d, %d)", 
                                     self.jid, self.host, self.nickname, self.clientName, self.clientVersion, self.contactState, self.accountPk];	
	[[WebgnosusDbi instance]  updateWithStatement:insertStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)update {
    NSString* updateStatement = [[NSString alloc] initWithFormat:@"UPDATE contacts SET jid = '%@', host = '%@', nickname = '%@', clientName = '%@', clientVersion = '%@', contactState = %d, accountPk = %d WHERE pk = %d", 
         self.jid, self.host, self.nickname, self.clientName, self.clientVersion, self.contactState, self.accountPk, self.pk];	
	[[WebgnosusDbi instance]  updateWithStatement:updateStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)destroy {	
	NSString *insertStatement = [[NSString alloc] initWithFormat:@"DELETE FROM contacts WHERE pk = %d", self.pk];	
	[[WebgnosusDbi instance]  updateWithStatement:insertStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)load {
	NSString* selectStatement = [[NSString alloc] initWithFormat:@"SELECT * FROM contacts WHERE jid = '%@' AND accountPk = %d", self.jid, self.accountPk];
	[[WebgnosusDbi instance] selectForModel:[AccountModel class] withStatement:selectStatement andOutputTo:self];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)hasError {
    if (self.contactState == ContactHasError) {
        return YES;
    } 
    return NO;
}

//===================================================================================================================================
#pragma mark ContactModel PrivateApi

//===================================================================================================================================
#pragma mark WebgnosusDbiDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setAttributesWithStatement:(sqlite3_stmt*)statement {
    self.pk = (int)sqlite3_column_int(statement, 0);
    char* jidVal = (char*)sqlite3_column_text(statement, 1);
    if (jidVal != nil) {		
        self.jid = [[NSString alloc] initWithUTF8String:jidVal];
    }
    char* hostVal = (char*)sqlite3_column_text(statement, 2);
    if (hostVal != nil) {		
        self.host = [[NSString alloc] initWithUTF8String:hostVal];
    }
    char* nicknameVal = (char*)sqlite3_column_text(statement, 3);
    if (nicknameVal != nil) {
        self.nickname = [[NSString alloc] initWithUTF8String:nicknameVal];
    }
    char* clientNameVal = (char*)sqlite3_column_text(statement, 4);
    if (clientNameVal != nil) {
        self.clientName = [[NSString alloc] initWithUTF8String:clientNameVal];
    }
    char* clientVersionVal = (char*)sqlite3_column_text(statement, 5);
    if (clientVersionVal != nil) {
        self.clientVersion = [[NSString alloc] initWithUTF8String:clientVersionVal];
    }
    self.contactState = (int)sqlite3_column_int(statement, 6);
    self.accountPk = (int)sqlite3_column_int(statement, 7);
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)collectAllFromResult:(sqlite3_stmt*)result andOutputTo:(NSMutableArray*)output {
	ContactModel* model = [[ContactModel alloc] init];
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
