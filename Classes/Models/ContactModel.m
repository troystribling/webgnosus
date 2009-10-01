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
+ (NSInteger)countByAccount:(AccountModel*)account {
	NSString* countStatement = [NSString stringWithFormat:@"SELECT COUNT(pk) FROM contacts WHERE accountPk = %d", account.pk];
	return [[WebgnosusDbi instance]  selectIntExpression:countStatement];
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
	NSMutableArray* output = [NSMutableArray arrayWithCapacity:10];	
    [[WebgnosusDbi instance] selectAllForModel:[ContactModel class] withStatement:@"SELECT * FROM contacts" andOutputTo:output];
	return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAllByAccount:(AccountModel*)requestAccount {
	NSMutableArray* output = [NSMutableArray arrayWithCapacity:10];	
	NSString *selectStatement = [NSString stringWithFormat:@"SELECT * FROM contacts WHERE accountPk = %d", requestAccount.pk];
	[[WebgnosusDbi instance] selectAllForModel:[ContactModel class] withStatement:selectStatement andOutputTo:output];
	return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (ContactModel*)findByPk:(NSInteger)requestPk {
	NSString* selectStatement = [NSString stringWithFormat:@"SELECT * FROM contacts WHERE pk = %d", requestPk];
	ContactModel* model = [[[ContactModel alloc] init] autorelease];
	[[WebgnosusDbi instance] selectForModel:[ContactModel class] withStatement:selectStatement andOutputTo:model];
    if (model.pk == 0) {
        model = nil;
    }
	return model;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (ContactModel*)findByJid:(NSString*)requestJid andAccount:(AccountModel*)requestAccount {
	NSString* selectStatement = [NSString stringWithFormat:@"SELECT * FROM contacts WHERE jid = '%@' AND accountPk = %d", requestJid, requestAccount.pk];
	ContactModel* model = [[[ContactModel alloc] init] autorelease];
	[[WebgnosusDbi instance] selectForModel:[ContactModel class] withStatement:selectStatement andOutputTo:model];
    if (model.pk == 0) {
        model = nil;
    }
	return model;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)destroyAllByAccount:(AccountModel*)requestAccount {
	NSString* deleteStatement = [NSString stringWithFormat:@"DELETE FROM contacts WHERE accountPk = %d", requestAccount.pk];
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
	NSString* insertStatement = [NSString stringWithFormat:@"INSERT INTO contacts (jid, host, nickname, clientName, clientVersion, contactState, accountPk) values ('%@', '%@', '%@', '%@', '%@', %d, %d)", 
                                     self.jid, self.host, self.nickname, self.clientName, self.clientVersion, self.contactState, self.accountPk];	
	[[WebgnosusDbi instance]  updateWithStatement:insertStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)update {
    NSString* updateStatement = [NSString stringWithFormat:@"UPDATE contacts SET jid = '%@', host = '%@', nickname = '%@', clientName = '%@', clientVersion = '%@', contactState = %d, accountPk = %d WHERE pk = %d", 
         self.jid, self.host, self.nickname, self.clientName, self.clientVersion, self.contactState, self.accountPk, self.pk];	
	[[WebgnosusDbi instance]  updateWithStatement:updateStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)destroy {	
	NSString *insertStatement = [NSString stringWithFormat:@"DELETE FROM contacts WHERE pk = %d", self.pk];	
	[[WebgnosusDbi instance]  updateWithStatement:insertStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)load {
	NSString* selectStatement = [NSString stringWithFormat:@"SELECT * FROM contacts WHERE jid = '%@' AND accountPk = %d", self.jid, self.accountPk];
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
