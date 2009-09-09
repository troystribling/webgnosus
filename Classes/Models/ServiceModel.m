//
//  ServiceModel.m
//  webgnosus
//
//  Created by Troy Stribling on 8/23/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "ServiceModel.h"
#import "AccountModel.h"
#import "WebgnosusDbi.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ServiceModel (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ServiceModel

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize pk;
@synthesize accountPk;
@synthesize jid;
@synthesize serviceName;
@synthesize serviceCategory;
@synthesize serviceType;

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
	[[WebgnosusDbi instance]  updateWithStatement:@"CREATE TABLE services (pk integer primary key, jid text, serviceName text, serviceCategory text, serviceType text, accountPk integer, FOREIGN KEY (accountPk) REFERENCES accounts(pk))"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAll {
	NSMutableArray* output = [[NSMutableArray alloc] initWithCapacity:10];	
	[[WebgnosusDbi instance] selectAllForModel:[ServiceModel class] withStatement:@"SELECT * FROM services" andOutputTo:output];
	return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)destroyAllByAccount:(AccountModel*)account {
	NSString* deleteStatement = 
    [[NSString alloc] initWithFormat:@"DELETE FROM services WHERE accountPk = %d", account.pk];
	[[WebgnosusDbi instance]  updateWithStatement:deleteStatement];
    [deleteStatement release];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insert {
    NSString* insertStatement;
    if (self.serviceName) {
        insertStatement = [[NSString alloc] initWithFormat:@"INSERT INTO services (jid, serviceName, serviceCategory, serviceType, accountPk) values ('%@', '%@', '%@', '%@', %d)", 
                           self.jid, self.serviceName, self.serviceCategory, self.serviceType, self.accountPk];	
    } else {
        insertStatement = [[NSString alloc] initWithFormat:@"INSERT INTO services (jid, serviceCategory, serviceType, accountPk) values ('%@', '%@', '%@', %d)", 
                           self.jid, self.serviceCategory, self.serviceType, self.accountPk];	
    }
    [[WebgnosusDbi instance]  updateWithStatement:insertStatement];
    [insertStatement release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)destroy {	
	NSString* destroyStatement = [[NSString alloc] initWithFormat:@"DELETE FROM services WHERE pk = %d", self.pk];	
	[[WebgnosusDbi instance]  updateWithStatement:destroyStatement];
    [destroyStatement release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)load {
	NSString* selectStatement = [[NSString alloc] initWithFormat:@"SELECT * FROM services WHERE jid = '%@' AND accountPk = %d", 
                                 self.jid, self.accountPk];
	[[WebgnosusDbi instance] selectForModel:[ServiceModel class] withStatement:selectStatement andOutputTo:self];
    [selectStatement release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)update {
	NSString* updateStatement = 
    [[NSString alloc] initWithFormat:@"UPDATE services SET jid = '%@', serviceName = '%@', serviceCategory = '%@', serviceType = '%@', accountPk = %d WHERE pk = %d", 
     self.jid, self.serviceName, self.serviceCategory, self.serviceType, self.accountPk, self.pk];	
	[[WebgnosusDbi instance]  updateWithStatement:updateStatement];
    [updateStatement release];
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
	char* inameVal = (char*)sqlite3_column_text(statement, 2);
	if (inameVal != nil) {		
		self.serviceName = [[NSString alloc] initWithUTF8String:inameVal];
	}
	char* categoryVal = (char*)sqlite3_column_text(statement, 3);
	if (categoryVal != nil) {		
		self.serviceCategory = [[NSString alloc] initWithUTF8String:categoryVal];
	}
	char* typeVal = (char*)sqlite3_column_text(statement, 3);
	if (typeVal != nil) {		
		self.serviceType = [[NSString alloc] initWithUTF8String:typeVal];
	}
	self.accountPk = (int)sqlite3_column_int(statement, 5);
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
