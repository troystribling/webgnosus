//
//  ServiceFeatureModel.m
//  webgnosus
//
//  Created by Troy Stribling on 8/5/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "ServiceFeatureModel.h"
#import "UserModel.h"
#import "WebgnosusDbi.h"
#import "XMPPJID.h"
#import "XMPPDiscoFeature.h"
#import "NSObjectWebgnosus.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ServiceFeatureModel (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ServiceFeatureModel

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize pk;
@synthesize node;
@synthesize service;
@synthesize var;

//===================================================================================================================================
#pragma mark ServiceFeatureModel

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)count {
	return [[WebgnosusDbi instance]  selectIntExpression:@"SELECT COUNT(pk) FROM serviceFeatures"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)countByService:(NSString*)requestService andNode:(NSString*)requestNode {
    NSString* selectStatement;
    if (requestNode) {
        selectStatement = [NSString stringWithFormat:@"SELECT COUNT(pk) FROM serviceFeatures WHERE node = '%@' AND service LIKE '%@%%'",  requestNode, requestService];
    } else {
        selectStatement = [NSString stringWithFormat:@"SELECT COUNT(pk) FROM serviceFeatures WHERE node IS NULL AND service LIKE '%@%%'", requestService];
    }
	return [[WebgnosusDbi instance]  selectIntExpression:selectStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)drop {
	[[WebgnosusDbi instance]  updateWithStatement:@"DROP TABLE serviceFeatures"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)create {
	[[WebgnosusDbi instance]  updateWithStatement:@"CREATE TABLE serviceFeatures (pk integer primary key, node text, service text, var text)"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAll {
	NSMutableArray* output = [NSMutableArray arrayWithCapacity:10];	
	[[WebgnosusDbi instance] selectAllForModel:[ServiceFeatureModel class] withStatement:@"SELECT * FROM serviceFeatures" andOutputTo:output];
	return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (ServiceFeatureModel*)findByService:(NSString*)requestService andVar:(NSString*)requestVar {
	NSString* selectStatement = [NSString stringWithFormat:@"SELECT * FROM serviceFeatures WHERE service = '%@' AND var ='%@'",  requestService, requestVar];
	ServiceFeatureModel* model = [[[ServiceFeatureModel alloc] init] autorelease];
	[[WebgnosusDbi instance] selectForModel:[ServiceFeatureModel class] withStatement:selectStatement andOutputTo:model];
    if (model.pk == 0) {
        model = nil;
    }
	return model;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (ServiceFeatureModel*)findByService:(NSString*)requestService node:(NSString*)requestNode andVar:(NSString*)requestVar {
	NSString* selectStatement;
    if (requestNode) {
        selectStatement = [NSString stringWithFormat:@"SELECT * FROM serviceFeatures WHERE service = '%@' AND var ='%@' AND node ='%@'",  requestService, requestVar, requestNode];
    } else {
        selectStatement = [NSString stringWithFormat:@"SELECT * FROM serviceFeatures WHERE service = '%@' AND var ='%@'",  requestService, requestVar];
    }
	ServiceFeatureModel* model = [[[ServiceFeatureModel alloc] init] autorelease];
	[[WebgnosusDbi instance] selectForModel:[ServiceFeatureModel class] withStatement:selectStatement andOutputTo:model];
    if (model.pk == 0) {
        model = nil;
    }
	return model;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAllByService:(NSString*)requestService andNode:(NSString*)requestNode {
    NSString* selectStatement;
    if (requestNode) {
        selectStatement = [NSString stringWithFormat:@"SELECT DISTINCT * FROM serviceFeatures WHERE node = '%@' AND service LIKE '%@%%'",  requestNode, requestService];
    } else {
        selectStatement = [NSString stringWithFormat:@"SELECT DISTINCT * FROM serviceFeatures WHERE node IS NULL AND service LIKE '%@%%'", requestService];
    }
	NSMutableArray* output = [NSMutableArray arrayWithCapacity:10];	
	[[WebgnosusDbi instance] selectAllForModel:[ServiceFeatureModel class] withStatement:selectStatement andOutputTo:output];
	return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)insert:(XMPPDiscoFeature*)feature forService:(XMPPJID*)serviceJID andNode:(NSString*)requestNode {
    ServiceFeatureModel* model = [ServiceFeatureModel findByService:[serviceJID full] node:requestNode andVar:[feature var]];
    if (!model) {
        ServiceFeatureModel* serviceFeature = [[ServiceFeatureModel alloc] init];
        if (requestNode) {
            serviceFeature.node = requestNode;
        }
        serviceFeature.var = [feature var];
        serviceFeature.service = [serviceJID full];
        [serviceFeature insert];
        [serviceFeature release];
    } else {
        [model update];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)destroyAll {
	[[WebgnosusDbi instance]  updateWithStatement:@"DELETE FROM serviceFeatures"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)destroyByService:(NSString*)requestService andNode:(NSString*)requestNode {
	NSString* deleteStatement;
    if (requestNode) {
        deleteStatement = [NSString stringWithFormat:@"DELETE FROM serviceFeatures WHERE service = '%@' AND node ='%@'",  requestService, requestNode];
    } else {
        deleteStatement = [NSString stringWithFormat:@"DELETE FROM serviceFeatures WHERE service = '%@'",  requestService];
    }
	[[WebgnosusDbi instance]  updateWithStatement:deleteStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)destroyAllByService:(NSString*)requestService {
	NSString* deleteStatement = [NSString stringWithFormat:@"DELETE FROM serviceFeatures WHERE service = '%@'", requestService];
	[[WebgnosusDbi instance]  updateWithStatement:deleteStatement];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insert {
    NSString* insertStatement;
    if (self.node) {
        insertStatement = [NSString stringWithFormat:@"INSERT INTO serviceFeatures (node, service, var) values ('%@', '%@', '%@')", self.node, self.service, self.var];	
    } else {
        insertStatement = [NSString stringWithFormat:@"INSERT INTO serviceFeatures (service, var) values ('%@', '%@')", self.service, self.var];	
    }
    [[WebgnosusDbi instance]  updateWithStatement:insertStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)destroy {	
	NSString* destroyStatement = [NSString stringWithFormat:@"DELETE FROM serviceFeatures WHERE pk = %d", self.pk];	
	[[WebgnosusDbi instance]  updateWithStatement:destroyStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)load {
	NSString* selectStatement = [NSString stringWithFormat:@"SELECT * FROM serviceFeatures WHERE node = '%@' AND service = '%@' AND var = '%@'", self.node, self.service, self.var];
	[[WebgnosusDbi instance] selectForModel:[ServiceFeatureModel class] withStatement:selectStatement andOutputTo:self];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)update {
    NSString* updateStatement;
    if (self.node) {
        updateStatement = [NSString stringWithFormat:@"UPDATE serviceFeatures SET node = '%@', service = '%@', var = '%@' WHERE pk = %d", 
                            self.node, self.service, self.var, self.pk];	
    } else {
        updateStatement = [NSString stringWithFormat:@"UPDATE serviceFeatures SET service = '%@', var = '%@' WHERE pk = %d", 
                            self.service, self.var, self.pk];	
    }
	[[WebgnosusDbi instance]  updateWithStatement:updateStatement];
}

//===================================================================================================================================
#pragma mark ServiceFeatureModel PrivateAPI

//===================================================================================================================================
#pragma mark WebgnosusDbiDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setAttributesWithStatement:(sqlite3_stmt*)statement {
	self.pk = (int)sqlite3_column_int(statement, 0);
	char* nodeVal = (char*)sqlite3_column_text(statement, 1);
	if (nodeVal != nil) {		
		self.node = [[NSString alloc] initWithUTF8String:nodeVal];
	}
	char* serviceVal = (char*)sqlite3_column_text(statement, 2);
	if (serviceVal != nil) {		
		self.service = [[NSString alloc] initWithUTF8String:serviceVal];
	}
	char* varVal = (char*)sqlite3_column_text(statement, 3);
	if (varVal != nil) {		
		self.var = [[NSString alloc] initWithUTF8String:varVal];
	}
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
