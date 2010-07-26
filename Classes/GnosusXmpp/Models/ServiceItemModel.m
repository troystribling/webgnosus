//
//  ServiceItemModel.m
//  webgnosus
//
//  Created by Troy Stribling on 8/5/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "ServiceItemModel.h"
#import "UserModel.h"
#import "WebgnosusDbi.h"
#import "XMPPJID.h"
#import "XMPPDiscoItem.h"
#import "NSObjectWebgnosus.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ServiceItemModel (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ServiceItemModel

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize pk;
@synthesize parentNode;
@synthesize service;
@synthesize node;
@synthesize jid;
@synthesize itemName;

//===================================================================================================================================
#pragma mark ServiceItemModel

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)count {
	return [[WebgnosusDbi instance]  selectIntExpression:@"SELECT COUNT(pk) FROM serviceItems"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)countByService:(NSString*)requestService andParentNode:(NSString*)requestNode {
    NSString* selectStatement;
    if (requestNode) {
        selectStatement = [NSString stringWithFormat:@"SELECT COUNT(pk) FROM serviceItems WHERE parentNode = '%@' AND service LIKE '%@%%'",  requestNode, requestService];
    } else {
        selectStatement = [NSString stringWithFormat:@"SELECT COUNT(pk) FROM serviceItems WHERE parentNode IS NULL AND service LIKE '%@%%'", requestService];
    }
	return [[WebgnosusDbi instance]  selectIntExpression:selectStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)drop {
	[[WebgnosusDbi instance]  updateWithStatement:@"DROP TABLE serviceItems"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)create {
	[[WebgnosusDbi instance]  updateWithStatement:@"CREATE TABLE serviceItems (pk integer primary key, parentNode text, service text, node text, jid text, itemName text)"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAll {
	NSMutableArray* output = [NSMutableArray arrayWithCapacity:10];	
	[[WebgnosusDbi instance] selectAllForModel:[ServiceItemModel class] withStatement:@"SELECT * FROM serviceItems" andOutputTo:output];
	return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAllByParentNode:(NSString*)requestNode {
    NSString* selectStatement = [NSString stringWithFormat:@"SELECT * FROM serviceItems WHERE parentNode = '%@'",  requestNode];
	NSMutableArray* output = [NSMutableArray arrayWithCapacity:10];	
	[[WebgnosusDbi instance] selectAllForModel:[ServiceItemModel class] withStatement:selectStatement andOutputTo:output];
	return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAllByService:(NSString*)requestService andParentNode:(NSString*)requestNode {
    NSString* selectStatement;
    if (requestNode) {
        selectStatement = [NSString stringWithFormat:@"SELECT DISTINCT * FROM serviceItems WHERE parentNode = '%@' AND service LIKE '%@%%'",  requestNode, requestService];
    } else {
        selectStatement = [NSString stringWithFormat:@"SELECT DISTINCT * FROM serviceItems WHERE parentNode IS NULL AND service LIKE '%@%%'", requestService];
    }
	NSMutableArray* output = [NSMutableArray arrayWithCapacity:10];	
	[[WebgnosusDbi instance] selectAllForModel:[ServiceItemModel class] withStatement:selectStatement andOutputTo:output];
	return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAllByService:(NSString*)requestService parentNode:(NSString*)requestParentNode andNode:(NSString*)requestNode {
    NSString* selectStatement = [NSString stringWithFormat:@"SELECT DISTINCT * FROM serviceItems WHERE parentNode = '%@' AND node = '%@' AND service LIKE '%@%%'",  
                                    requestParentNode, requestNode, requestService];
	NSMutableArray* output = [NSMutableArray arrayWithCapacity:10];	
	[[WebgnosusDbi instance] selectAllForModel:[ServiceItemModel class] withStatement:selectStatement andOutputTo:output];
	return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (ServiceItemModel*)findByJID:(NSString*)requestJID {
    NSString* selectStatement = [NSString stringWithFormat:@"SELECT * FROM serviceItems WHERE jid = '%@' LIMIT 1",  requestJID];
	ServiceItemModel* model = [[[ServiceItemModel alloc] init] autorelease];
	[[WebgnosusDbi instance] selectForModel:[ServiceItemModel class] withStatement:selectStatement andOutputTo:model];
    if (model.pk == 0) {
        model = nil;
    }
	return model;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (ServiceItemModel*)findByNode:(NSString*)requestNode {
    NSString* selectStatement = [NSString stringWithFormat:@"SELECT * FROM serviceItems WHERE node ='%@' LIMIT 1",  requestNode];
	ServiceItemModel* model = [[[ServiceItemModel alloc] init] autorelease];
	[[WebgnosusDbi instance] selectForModel:[ServiceItemModel class] withStatement:selectStatement andOutputTo:model];
    if (model.pk == 0) {
        model = nil;
    }
	return model;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (ServiceItemModel*)findByService:(NSString*)requestService andNode:(NSString*)requestNode {
    NSString* selectStatement = [NSString stringWithFormat:@"SELECT * FROM serviceItems WHERE node ='%@' AND service = '%@' LIMIT 1", requestNode,  requestService];
	ServiceItemModel* model = [[[ServiceItemModel alloc] init] autorelease];
	[[WebgnosusDbi instance] selectForModel:[ServiceItemModel class] withStatement:selectStatement andOutputTo:model];
    if (model.pk == 0) {
        model = nil;
    }
	return model;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (ServiceItemModel*)findByService:(NSString*)requestService {
    NSString* selectStatement = [NSString stringWithFormat:@"SELECT * FROM serviceItems WHERE node IS NULL AND service = '%@' LIMIT 1",  requestService];
	ServiceItemModel* model = [[[ServiceItemModel alloc] init] autorelease];
	[[WebgnosusDbi instance] selectForModel:[ServiceItemModel class] withStatement:selectStatement andOutputTo:model];
    if (model.pk == 0) {
        model = nil;
    }
	return model;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (ServiceItemModel*)findByJID:(NSString*)requestJID andNode:(NSString*)requestNode {
    NSString* selectStatement;
    if (requestNode) {
        selectStatement = [NSString stringWithFormat:@"SELECT * FROM serviceItems WHERE jid = '%@' AND node ='%@'",  requestJID, requestNode];
    } else {
        selectStatement = [NSString stringWithFormat:@"SELECT * FROM serviceItems WHERE jid = '%@'",  requestJID];
    }
	ServiceItemModel* model = [[[ServiceItemModel alloc] init] autorelease];
	[[WebgnosusDbi instance] selectForModel:[ServiceItemModel class] withStatement:selectStatement andOutputTo:model];
    if (model.pk == 0) {
        model = nil;
    }
	return model;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)destroyAll {
	[[WebgnosusDbi instance]  updateWithStatement:@"DELETE FROM serviceItems"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)insert:(XMPPDiscoItem*)item forService:(XMPPJID*)serviceJID andParentNode:(NSString*)parent {
    NSString* itemNode = [item node];
    if (!itemNode) {
        itemNode = [item iname];
    } 
    ServiceItemModel* model = [ServiceItemModel findByJID:[[item JID] full] andNode:itemNode];
    if (!model) {
        ServiceItemModel* serviceItem = [[ServiceItemModel alloc] init];
        if (parent) {
            if (![parent isEqualToString:@""]) {
                serviceItem.parentNode = parent;
            }
        }
        if ([item iname]) {
            serviceItem.itemName = [item iname];
        } else {
            serviceItem.itemName = itemNode;
        }
        if ([item JID]) {
            serviceItem.jid = [[item JID] full];
        }
        serviceItem.node = itemNode;
        serviceItem.service = [serviceJID full];
        [serviceItem insert];
        [serviceItem release];
    } else {
        [model update];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)destroyAllByService:(NSString*)requestService {
	NSString* deleteStatement = [NSString stringWithFormat:@"DELETE FROM serviceItems WHERE service LIKE '%%%@'", requestService];
	[[WebgnosusDbi instance]  updateWithStatement:deleteStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)destroyAllByService:(NSString*)requestService andParentNode:(NSString*)requestNode {
	NSString* deleteStatement = [NSString stringWithFormat:@"DELETE FROM serviceItems WHERE service LIKE '%%%@' AND parentNode = '%@'", requestService, requestNode];
	[[WebgnosusDbi instance]  updateWithStatement:deleteStatement];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insert {
    NSString* insertStatement;
    if (self.parentNode &&  self.node && self.itemName) {
        insertStatement = [NSString stringWithFormat:@"INSERT INTO serviceItems (parentNode, service, node, jid, itemName) values ('%@', '%@', '%@', '%@', '%@')", 
                            self.parentNode, self.service, self.node, self.jid, self.itemName];	
    } else if (self.node && self.itemName) {
        insertStatement = [NSString stringWithFormat:@"INSERT INTO serviceItems (service, node, jid, itemName) values ('%@', '%@', '%@', '%@')", 
                           self.service, self.node, self.jid, self.itemName];	
    } else {
        insertStatement = [[NSString alloc] initWithFormat:@"INSERT INTO serviceItems (service, jid) values ('%@', '%@')", self.service, self.jid];	
    }
    [[WebgnosusDbi instance]  updateWithStatement:insertStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)destroy {	
	NSString* destroyStatement = [NSString stringWithFormat:@"DELETE FROM serviceItems WHERE pk = %d", self.pk];	
	[[WebgnosusDbi instance]  updateWithStatement:destroyStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)load {
	NSString* selectStatement = [NSString stringWithFormat:@"SELECT * FROM serviceItems WHERE parentNode = '%@' AND service = '%@' AND node = '%@' AND jid = '%@'", 
                                  self.parentNode, self.service, self.node, self.jid];
	[[WebgnosusDbi instance] selectForModel:[ServiceItemModel class] withStatement:selectStatement andOutputTo:self];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)update {
    NSString* updateStatement;
    if (self.parentNode &&  self.node && self.itemName) {
        updateStatement = [NSString stringWithFormat:@"UPDATE serviceItems SET parentNode = '%@', service = '%@', node = '%@', jid = '%@', itemName = '%@' WHERE pk = %d", 
                           self.parentNode, self.service, self.node, self.jid, self.itemName, self.pk];	
    } else if (self.node && self.itemName) {
        updateStatement = [NSString stringWithFormat:@"UPDATE serviceItems SET service = '%@', node = '%@', jid = '%@', itemName = '%@' WHERE pk = %d",  
                          self.service, self.node, self.jid, self.itemName, self.pk];	
    } else {
        updateStatement = [NSString stringWithFormat:@"UPDATE serviceItems SET service = '%@', jid = '%@' WHERE pk = %d", 
                           self.service, self.jid, self.pk];
    }
	[[WebgnosusDbi instance]  updateWithStatement:updateStatement];
}

//===================================================================================================================================
#pragma mark ServiceItemModel PrivateAPI

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
	char* nodeVal = (char*)sqlite3_column_text(statement, 3);
	if (nodeVal != nil) {		
		self.node = [[NSString alloc] initWithUTF8String:nodeVal];
	}
	char* jidVal = (char*)sqlite3_column_text(statement, 4);
	if (jidVal != nil) {		
		self.jid = [[NSString alloc] initWithUTF8String:jidVal];
	}
	char* inameVal = (char*)sqlite3_column_text(statement, 5);
	if (inameVal != nil) {		
		self.itemName = [[NSString alloc] initWithUTF8String:inameVal];
	}
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

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
