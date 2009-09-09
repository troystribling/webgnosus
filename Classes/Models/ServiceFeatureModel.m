//
//  ServiceFeatureModel.m
//  webgnosus
//
//  Created by Troy Stribling on 8/5/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "ServiceFeatureModel.h"
#import "AccountModel.h"
#import "WebgnosusDbi.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ServiceFeatureModel (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ServiceFeatureModel

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize pk;
@synthesize accountPk;
@synthesize parentNode;
@synthesize service;
@synthesize var;

//===================================================================================================================================
#pragma mark ServiceFeatureModel

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)count {
	return [[WebgnosusDbi instance]  selectIntExpression:@"SELECT COUNT(pk) FROM serviceFeatures"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)drop {
	[[WebgnosusDbi instance]  updateWithStatement:@"DROP TABLE serviceFeatures"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)create {
	[[WebgnosusDbi instance]  updateWithStatement:@"CREATE TABLE serviceFeatures (pk integer primary key, parentNode text, service text, var text, accountPk integer, FOREIGN KEY (accountPk) REFERENCES accounts(pk))"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAll {
	NSMutableArray* output = [[NSMutableArray alloc] initWithCapacity:10];	
	[[WebgnosusDbi instance] selectAllForModel:[ServiceFeatureModel class] withStatement:@"SELECT * FROM serviceFeatures" andOutputTo:output];
	return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)destroyAllByAccount:(AccountModel*)account {
	NSString* deleteStatement = 
    [[NSString alloc] initWithFormat:@"DELETE FROM serviceFeatures WHERE accountPk = %d", account.pk];
	[[WebgnosusDbi instance]  updateWithStatement:deleteStatement];
    [deleteStatement release];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insert {
    NSString* insertStatement;
    if (self.parentNode) {
        insertStatement = [[NSString alloc] initWithFormat:@"INSERT INTO serviceFeatures (parentNode, service, var, accountPk) values ('%@', '%@', '%@', %d)", 
                           self.parentNode, self.service, self.var, self.accountPk];	
    } else {
        insertStatement = [[NSString alloc] initWithFormat:@"INSERT INTO serviceFeatures (service, var, accountPk) values ('%@', '%@', %d)", 
                           self.service, self.var, self.accountPk];	
    }
    [[WebgnosusDbi instance]  updateWithStatement:insertStatement];
    [insertStatement release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)destroy {	
	NSString* destroyStatement = [[NSString alloc] initWithFormat:@"DELETE FROM serviceFeatures WHERE pk = %d", self.pk];	
	[[WebgnosusDbi instance]  updateWithStatement:destroyStatement];
    [destroyStatement release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)load {
	NSString* selectStatement = [[NSString alloc] initWithFormat:@"SELECT * FROM serviceFeatures WHERE parentNode = '%@' AND service = '%@' AND var = '%@' AND accountPk = %d", 
                                 self.parentNode, self.service, self.var, self.accountPk];
	[[WebgnosusDbi instance] selectForModel:[ServiceFeatureModel class] withStatement:selectStatement andOutputTo:self];
    [selectStatement release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)update {
	NSString* updateStatement = 
        [[NSString alloc] initWithFormat:@"UPDATE serviceFeatures SET parentNode = '%@', service = '%@', var = '%@', accountPk = %d WHERE pk = %d", 
         self.parentNode, self.service, self.var, self.accountPk, self.pk];	
	[[WebgnosusDbi instance]  updateWithStatement:updateStatement];
    [updateStatement release];
}

//===================================================================================================================================
#pragma mark ServiceFeatureModel PrivateAPI

//===================================================================================================================================
#pragma mark WebgnosusDbiDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setAttributesWithStatement:(sqlite3_stmt*)statement {
	self.pk = (int)sqlite3_column_int(statement, 0);
	char* parentNodeVal = (char*)sqlite3_column_text(statement, 1);
	if (parentNodeVal != nil) {		
		self.parentNode = [[NSString alloc] initWithUTF8String:parentNodeVal];
	}
	char* serviceVal = (char*)sqlite3_column_text(statement, 2);
	if (serviceVal != nil) {		
		self.service = [[NSString alloc] initWithUTF8String:serviceVal];
	}
	char* varVal = (char*)sqlite3_column_text(statement, 3);
	if (varVal != nil) {		
		self.var = [[NSString alloc] initWithUTF8String:varVal];
	}
	self.accountPk = (int)sqlite3_column_int(statement, 4);
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)collectAllFromResult:(sqlite3_stmt*)result andOutputTo:(NSMutableArray*)output {
	ServiceFeatureModel* model = [[ServiceFeatureModel alloc] init];
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
