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
#import "NSObjectiPhoneAdditions.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ServiceFeatureModel (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ServiceFeatureModel

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize pk;
@synthesize parentNode;
@synthesize service;
@synthesize var;
@synthesize synched;

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
	[[WebgnosusDbi instance]  updateWithStatement:@"CREATE TABLE serviceFeatures (pk integer primary key, parentNode text, service text, var text, synched integer)"];
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
+ (void)destroyAll {
	[[WebgnosusDbi instance]  updateWithStatement:@"DELETE FROM serviceFeatures"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)insert:(XMPPDiscoFeature*)feature forService:(XMPPJID*)serviceJID andParentNode:(NSString*)parent {
    if (![ServiceFeatureModel findByService:[serviceJID full] andVar:[feature var]]) {
        ServiceFeatureModel* serviceFeature = [[ServiceFeatureModel alloc] init];
        serviceFeature.parentNode = parent;
        serviceFeature.var = [feature var];
        serviceFeature.service = [serviceJID full];
        [serviceFeature insert];
        [serviceFeature release];
    }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insert {
    NSString* insertStatement;
    if (self.parentNode) {
        insertStatement = [NSString stringWithFormat:@"INSERT INTO serviceFeatures (parentNode, service, var, synched) values ('%@', '%@', '%@', %d)", self.parentNode, self.service, self.var, self.synched];	
    } else {
        insertStatement = [NSString stringWithFormat:@"INSERT INTO serviceFeatures (service, var, synched) values ('%@', '%@', %d)", self.service, self.var, self.synched];	
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
	NSString* selectStatement = [NSString stringWithFormat:@"SELECT * FROM serviceFeatures WHERE parentNode = '%@' AND service = '%@' AND var = '%@'", self.parentNode, self.service, self.var];
	[[WebgnosusDbi instance] selectForModel:[ServiceFeatureModel class] withStatement:selectStatement andOutputTo:self];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)update {
	NSString* updateStatement = 
        [NSString stringWithFormat:@"UPDATE serviceFeatures SET parentNode = '%@', service = '%@', var = '%@', synched = %d WHERE pk = %d", self.parentNode, self.service, self.var, self.synched, self.pk];	
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
	[self setSynchedAsInteger:(int)sqlite3_column_int(statement, 4)];
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
