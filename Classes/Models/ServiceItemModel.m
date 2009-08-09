//
//  ServiceItemModel.m
//  webgnosus
//
//  Created by Troy Stribling on 8/5/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "ServiceItemModel.h"
#import "WebgnosusDbi.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ServiceItemModel (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ServiceItemModel

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize pk;
@synthesize accountPk;
@synthesize node;
@synthesize jid;
@synthesize iname;
@synthesize category;
@synthesize type;

//===================================================================================================================================
#pragma mark ServiceItemModel

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)count {
	return [[WebgnosusDbi instance]  selectIntExpression:@"SELECT COUNT(pk) FROM serviceItems"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)drop {
	[[WebgnosusDbi instance]  updateWithStatement:@"DROP TABLE serviceItems"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)create {
	[[WebgnosusDbi instance]  updateWithStatement:@"CREATE TABLE serviceItems (pk integer primary key, node text, jid text, iname text, category text, type text, accountPk integer, FOREIGN KEY (accountPk) REFERENCES accounts(pk))"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAll {
	NSMutableArray* output = [[NSMutableArray alloc] initWithCapacity:10];	
	[[WebgnosusDbi instance] selectAllForModel:[ServiceItemModel class] withStatement:@"SELECT * FROM serviceItems" andOutputTo:output];
	return output;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insert {
	NSString* insertStatement = [[NSString alloc] initWithFormat:@"INSERT INTO serviceItems (node, jid, iname, category, type, accountPk) values ('%@', '%@', '%@', '%@', '%@', %d)", 
                                    self.node, self.jid, self.iname, self.category, self.type, self.accountPk];	
    [[WebgnosusDbi instance]  updateWithStatement:insertStatement];
    [insertStatement release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)destroy {	
	NSString* destroyStatement = [[NSString alloc] initWithFormat:@"DELETE FROM serviceItems WHERE pk = %d", self.pk];	
	[[WebgnosusDbi instance]  updateWithStatement:destroyStatement];
    [destroyStatement release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)load {
	NSString* selectStatement = [[NSString alloc] initWithFormat:@"SELECT * FROM serviceItems WHERE node = '%@' AND jid = '%@'", self.node, self.jid];
	[[WebgnosusDbi instance] selectForModel:[ServiceItemModel class] withStatement:selectStatement andOutputTo:self];
    [selectStatement release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)update {
	NSString* updateStatement = 
        [[NSString alloc] initWithFormat:@"UPDATE serviceFeatures SET node = '%@', jid = '%@', iname = '%@', category = '%@', type = '%@', accountPk = %d WHERE pk = %d", 
            self.node, self.jid, self.iname, self.category, self.type, self.accountPk, self.pk];	
	[[WebgnosusDbi instance]  updateWithStatement:updateStatement];
    [updateStatement release];
}

//===================================================================================================================================
#pragma mark ServiceItemModel PrivateAPI

//===================================================================================================================================
#pragma mark WebgnosusDbiDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setAttributesWithStatement:(sqlite3_stmt*)statement {
	self.pk = (int)sqlite3_column_int(statement, 0);
	char* nodeVal = (char*)sqlite3_column_text(statement, 1);
	if (nodeVal != nil) {		
		self.node = [[NSString alloc] initWithUTF8String:nodeVal];
	}
	char* jidVal = (char*)sqlite3_column_text(statement, 2);
	if (jidVal != nil) {		
		self.jid = [[NSString alloc] initWithUTF8String:jidVal];
	}
	char* inameVal = (char*)sqlite3_column_text(statement, 3);
	if (inameVal != nil) {		
		self.iname = [[NSString alloc] initWithUTF8String:inameVal];
	}
	char* categoryVal = (char*)sqlite3_column_text(statement, 4);
	if (categoryVal != nil) {		
		self.category = [[NSString alloc] initWithUTF8String:categoryVal];
	}
	self.accountPk = (int)sqlite3_column_int(statement, 5);
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)collectAllFromResult:(sqlite3_stmt*)result andOutputTo:(NSMutableArray*)output {
	ServiceItemModel* model = [[ServiceItemModel alloc] init];
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
