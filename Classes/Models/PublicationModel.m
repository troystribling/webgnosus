//
//  PublicationModel.m
//  webgnosus
//
//  Created by Troy Stribling on 8/9/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "PublicationModel.h"
#import "WebgnosusDbi.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface PublicationModel (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation PublicationModel

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize pk;
@synthesize accountPk;
@synthesize node;
@synthesize jid;

//===================================================================================================================================
#pragma mark PublicationModel

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)count {
	return [[WebgnosusDbi instance]  selectIntExpression:@"SELECT COUNT(pk) FROM publications"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)drop {
	[[WebgnosusDbi instance]  updateWithStatement:@"DROP TABLE publications"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)create {
	[[WebgnosusDbi instance]  updateWithStatement:@"CREATE TABLE publications (pk integer primary key, node text, jid text, accountPk integer, FOREIGN KEY (accountPk) REFERENCES accounts(pk))"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAll {
	NSMutableArray* output = [[NSMutableArray alloc] initWithCapacity:10];	
	[[WebgnosusDbi instance] selectAllForModel:[PublicationModel class] withStatement:@"SELECT * FROM publications" andOutputTo:output];
	return output;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insert {
	NSString* insertStatement = [[NSString alloc] initWithFormat:@"INSERT INTO publications (node, jid, accountPk) values ('%@', '%@', %d)", 
                                 self.node, self.jid, self.accountPk];	
    [[WebgnosusDbi instance]  updateWithStatement:insertStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)destroy {	
	NSString *insertStatement = [[NSString alloc] initWithFormat:@"DELETE FROM publications WHERE pk = %d", self.pk];	
	[[WebgnosusDbi instance]  updateWithStatement:insertStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)load {
	NSString* selectStatement = [[NSString alloc] initWithFormat:@"SELECT * FROM publications WHERE node = '%@'", self.node];
	[[WebgnosusDbi instance] selectForModel:[PublicationModel class] withStatement:selectStatement andOutputTo:self];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)update {
	NSString* updateStatement = 
    [[NSString alloc] initWithFormat:@"UPDATE subscriptions SET node = '%@', jid = '%@', accountPk = %d WHERE pk = %d", 
     self.node, self.jid, self.accountPk, self.pk];	
	[[WebgnosusDbi instance]  updateWithStatement:updateStatement];
}

//===================================================================================================================================
#pragma mark PublicationModel PrivateAPI

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
	self.accountPk = (int)sqlite3_column_int(statement, 3);
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)collectAllFromResult:(sqlite3_stmt*)result andOutputTo:(NSMutableArray*)output {
	PublicationModel* model = [[PublicationModel alloc] init];
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
