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
#import "KeychainItemWrapper.h"

//-----------------------------------------------------------------------------------------------------------------------------------
#define kPASSWORD_KEY  "XT6RN64UZM.com.imaginaryProducts"

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
	[[WebgnosusDbi instance]  updateWithStatement:@"CREATE TABLE accounts (pk integer primary key, resource text, nickname text, host text, activated integer, displayed integer, connectionState integer, port integer)"];
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
+ (AccountModel*)findByJID:(NSString*)_jid {
    NSInteger _pk = [self getPkForJid:_jid];
	NSString* selectStatement = [NSString stringWithFormat:@"SELECT * FROM accounts WHERE pk = %d", _pk];
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

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)getPkForJid:(NSString*)_jid {
    KeychainItemWrapper* keychain = [self getKeychainItem];
    NSMutableDictionary* accounts = [keychain objectForKey:(id)kSecValueData];
    NSInteger _pk;
    for (NSNumber* key in [accounts allKeys]) {
        NSString* accountJid = [[accounts objectForKey:key] objectForKey:@"jid"];
        if ([accountJid isEqualToString:_jid]) {
            _pk = [key intValue];
            break;
        }
    }
    return _pk;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (KeychainItemWrapper*)getKeychainItem {
    return [[KeychainItemWrapper alloc] initWithIdentifier:@"accounts" accessGroup:[NSString stringWithUTF8String:kRESOURCE_NAME]];
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insert {
	NSString* insertStatement;
    [self putAccountInKeychain];
	if (self.resource) {
		insertStatement = 
			[NSString stringWithFormat:@"INSERT INTO accounts (resource, nickname, host, activated, displayed, connectionState, port) values (%@', '%@', '%@', %d, %d, %d, %d)",
                self.resource, self.nickname, self.host, [self activatedAsInteger], [self displayedAsInteger], self.connectionState, self.port];	
	} else {
		insertStatement = 
			[NSString stringWithFormat:@"INSERT INTO accounts (resource, nickname, host, activated, displayed, connectionState, port) values (null, '%@', '%@', %d, %d, %d, %d)", 
                self.nickname, self.host, [self activatedAsInteger], [self displayedAsInteger], self.connectionState, self.port];	
	}
	[[WebgnosusDbi instance]  updateWithStatement:insertStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)update {
	NSString* updateStatement;
    [self putAccountInKeychain];
	if (self.resource) {
		updateStatement = 
			[NSString stringWithFormat:@"UPDATE accounts SET resource = '%@', nickname = '%@', host = '%@', activated = %d, displayed = %d, connectionState = %d, port = %d WHERE pk = %d", 
                 self.resource, self.nickname, self.host, [self activatedAsInteger], [self displayedAsInteger], self.connectionState, self.port, self.pk];	
	} else {
		updateStatement = 
			[NSString stringWithFormat:@"UPDATE accounts SET nickname = '%@', host = '%@', activated = %d, displayed = %d, connectionState = %d, port = %d WHERE pk = %d", 
                 self.nickname, self.host, [self activatedAsInteger], [self displayedAsInteger], self.connectionState, self.port, self.pk];	
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
    [self removeAccountFromKeychain];
    [ContactModel destroyAllByAccount:self];
    [RosterItemModel destroyAllByAccount:self];
    [MessageModel destroyAllByAccount:self];
    [SubscriptionModel destroyAllByAccount:self];
	NSString *insertStatement = [NSString stringWithFormat:@"DELETE FROM accounts WHERE pk = %d", self.pk];	
	[[WebgnosusDbi instance]  updateWithStatement:insertStatement];
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

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)geoLocPubSubNode {
    return [NSString stringWithFormat:@"%@/geoloc", [self pubSubRoot]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)getAccountFromKeychain {
    KeychainItemWrapper* keychain = [self.class getKeychainItem];
    NSMutableDictionary* accounts = [keychain objectForKey:(id)kSecValueData];
    if ([accounts respondsToSelector:@selector(objectForKey:)]) {
        NSMutableDictionary* acc = [accounts objectForKey:[NSNumber numberWithInt:self.pk]];
        self.password = [acc objectForKey:@"password"];
        self.jid = [acc objectForKey:@"jid"];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)putAccountInKeychain {
    KeychainItemWrapper* keychain = [self.class getKeychainItem];
    NSMutableDictionary* accounts = [keychain objectForKey:(id)kSecValueData];
    if (![accounts respondsToSelector:@selector(objectForKey:)]) {
        accounts = [NSMutableDictionary dictionary];
    }
    NSMutableDictionary* acc = [NSMutableDictionary dictionary];
    [acc setObject:self.password forKey:@"password"];
    [acc setObject:self.jid forKey:@"jid"];
    [accounts setObject:acc forKey:[NSNumber numberWithInt:self.pk]];
    [keychain setObject:accounts forKey:(id)kSecValueData];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)removeAccountFromKeychain {
    KeychainItemWrapper* keychain = [self.class getKeychainItem];
    NSMutableDictionary* accounts = [keychain objectForKey:(id)kSecValueData];
    [accounts removeObjectForKey:[NSNumber numberWithInt:self.pk]];
    [keychain setObject:accounts forKey:(id)kSecValueData];
}

//===================================================================================================================================
#pragma mark AccountModel PrivateAPI

//===================================================================================================================================
#pragma mark WebgnosusDbiDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setAttributesWithStatement:(sqlite3_stmt*)statement {
	self.pk = (int)sqlite3_column_int(statement, 0);
    [self getAccountFromKeychain];
	char* resourceVal = (char*)sqlite3_column_text(statement, 1);
	if (resourceVal != nil) {
		self.resource = [[NSString alloc] initWithUTF8String:resourceVal];
	}
	char* nicknameVal = (char*)sqlite3_column_text(statement, 2);
	if (nicknameVal != nil) {
		self.nickname = [[NSString alloc] initWithUTF8String:nicknameVal];
	}
	char* hostVal = (char*)sqlite3_column_text(statement, 3);
	if (hostVal != nil) {
		self.host = [[NSString alloc] initWithUTF8String:hostVal];
	}
	[self setActivatedAsInteger:(int)sqlite3_column_int(statement, 4)];
	[self setDisplayedAsInteger:(int)sqlite3_column_int(statement, 5)];
	self.connectionState = (int)sqlite3_column_int(statement, 6);
	self.port = (int)sqlite3_column_int(statement, 7);
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
