//
//  ServiceModel.m
//  webgnosus
//
//  Created by Troy Stribling on 8/23/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "ServiceModel.h"
#import "WebgnosusDbi.h"
#import "XMPPDiscoIdentity.h"
#import "XMPPJID.h"
#import "NSObjectiPhoneAdditions.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ServiceModel (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ServiceModel

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize pk;
@synthesize jid;
@synthesize name;
@synthesize category;
@synthesize type;
@synthesize synched;

//===================================================================================================================================
#pragma mark ServiceModel

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)count {
	return [[WebgnosusDbi instance]  selectIntExpression:@"SELECT COUNT(pk) FROM services"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)drop {
	[[WebgnosusDbi instance]  updateWithStatement:@"DROP TABLE services"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)create {
	[[WebgnosusDbi instance]  updateWithStatement:@"CREATE TABLE services (pk integer primary key, jid text, name text, category text, type text, synched integer)"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAll {
	NSMutableArray* output = [NSMutableArray arrayWithCapacity:10];	
	[[WebgnosusDbi instance] selectAllForModel:[ServiceModel class] withStatement:@"SELECT * FROM services" andOutputTo:output];
	return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAllByServiceType:(NSString*)requestType {
	NSMutableArray* output = [NSMutableArray arrayWithCapacity:10];	
	NSString* selectStatement = [NSString stringWithFormat:@"SELECT * FROM services WHERE serviceType = '%@'",  requestType];
	[[WebgnosusDbi instance] selectAllForModel:[ServiceModel class] withStatement:selectStatement andOutputTo:output];
    return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (ServiceModel*)findByJID:(NSString*)requestJID type:(NSString*)requestType andCategory:(NSString*)requestCategory {
	NSString* selectStatement = [NSString stringWithFormat:@"SELECT * FROM services WHERE jid = '%@' AND type ='%@' AND category = '%@'", requestJID, requestType, requestCategory];
	ServiceModel* model = [[[ServiceModel alloc] init] autorelease];
	[[WebgnosusDbi instance] selectForModel:[ServiceModel class] withStatement:selectStatement andOutputTo:model];
    if (model.pk == 0) {
        model = nil;
    }
	return model;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (ServiceModel*)findByService:(NSString*)serverJID type:(NSString*)requestType andCategory:(NSString*)requestCategory {
	NSString* selectStatement = [NSString stringWithFormat:@"SELECT s.* FROM services s, serviceItems i WHERE i.jid=s.jid AND i.service='%@' AND s.category='%@' AND s.type='%@'", 
                                 serverJID, requestCategory, requestType];
	ServiceModel* model = [[[ServiceModel alloc] init] autorelease];
	[[WebgnosusDbi instance] selectForModel:[ServiceModel class] withStatement:selectStatement andOutputTo:model];
    if (model.pk == 0) {
        model = nil;
    }
	return model;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)destroyAll {
	[[WebgnosusDbi instance]  updateWithStatement:@"DELETE FROM services"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)insert:(XMPPDiscoIdentity*)ident forService:(XMPPJID*)serviceJID {
    ServiceModel* model = [ServiceModel findByJID:[serviceJID full] type:[ident type] andCategory:[ident category]];
    if (!model) {
        ServiceModel* service = [[ServiceModel alloc] init];
        if ([ident iname]) {
            service.name = [ident iname];
        }
        service.jid = [serviceJID full];
        service.category = [ident category];
        service.type = [ident type];
        service.synched = YES;
        [service insert];
        [service release];
    } else {
        [model sync];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)resetSyncFlag {
	[[WebgnosusDbi instance]  updateWithStatement:@"UPDATE services SET synched = 0"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)destroyAllUnsyched {
	[[WebgnosusDbi instance]  updateWithStatement:@"DELETE FROM services WHERE synched = 0"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)destroyAllUnsychedByDomain:(NSString*)requestService {
	NSString* deleteStatement = [NSString stringWithFormat:@"DELETE FROM services WHERE service LIKE '%%%@'", requestService];
	[[WebgnosusDbi instance]  updateWithStatement:deleteStatement];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insert {
    NSString* insertStatement;
    if (self.name) {
        insertStatement = [NSString stringWithFormat:@"INSERT INTO services (jid, name, category, type, synched) values ('%@', '%@', '%@', '%@', %d)", self.jid, self.name, self.category, self.type, self.synchedAsInteger];	
    } else {
        insertStatement = [NSString stringWithFormat:@"INSERT INTO services (jid, category, type, synched) values ('%@', '%@', '%@', %d)", self.jid, self.category, self.type, self.synchedAsInteger];	
    }
    [[WebgnosusDbi instance]  updateWithStatement:insertStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)destroy {	
	NSString* destroyStatement = [NSString stringWithFormat:@"DELETE FROM services WHERE pk = %d", self.pk];	
	[[WebgnosusDbi instance]  updateWithStatement:destroyStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)load {
	NSString* selectStatement = [NSString stringWithFormat:@"SELECT * FROM services WHERE jid = '%@'", self.jid];
	[[WebgnosusDbi instance] selectForModel:[ServiceModel class] withStatement:selectStatement andOutputTo:self];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)update {
    NSString* updateStatement;
    if (self.name) {
        updateStatement = [NSString stringWithFormat:@"UPDATE services SET jid = '%@', name = '%@', category = '%@', type = '%@', synched = %d WHERE pk = %d", 
                            self.jid, self.name, self.category, self.type, self.synchedAsInteger, self.pk];
    } else {
        updateStatement = [NSString stringWithFormat:@"UPDATE services SET jid = '%@', category = '%@', type = '%@', synched = %d WHERE pk = %d", 
                           self.jid, self.category, self.type, self.synchedAsInteger, self.pk];
    }
	[[WebgnosusDbi instance]  updateWithStatement:updateStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)synchedAsInteger {
	return self.synched == YES ? 1 : 0;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setSynchedAsInteger:(NSInteger)value {
	if (value == 1) {
		self.synched = YES; 
	} else {
		self.synched = NO;
	};
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)sync {
    self.synched = YES;
    [self update];
}

//===================================================================================================================================
#pragma mark ServiceModel PrivateAPI

//===================================================================================================================================
#pragma mark WebgnosusDbiDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setAttributesWithStatement:(sqlite3_stmt*)statement {
	self.pk = (int)sqlite3_column_int(statement, 0);
	char* jidVal = (char*)sqlite3_column_text(statement, 1);
	if (jidVal != nil) {		
		self.jid = [[NSString alloc] initWithUTF8String:jidVal];
	}
	char* nameVal = (char*)sqlite3_column_text(statement, 2);
	if (nameVal != nil) {		
		self.name = [[NSString alloc] initWithUTF8String:nameVal];
	}
	char* categoryVal = (char*)sqlite3_column_text(statement, 3);
	if (categoryVal != nil) {		
		self.category = [[NSString alloc] initWithUTF8String:categoryVal];
	}
	char* typeVal = (char*)sqlite3_column_text(statement, 4);
	if (typeVal != nil) {		
		self.type = [[NSString alloc] initWithUTF8String:typeVal];
	}
	[self setSynchedAsInteger:(int)sqlite3_column_int(statement, 5)];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)collectAllFromResult:(sqlite3_stmt*)result andOutputTo:(NSMutableArray*)output {
	ServiceModel* model = [[ServiceModel alloc] init];
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
