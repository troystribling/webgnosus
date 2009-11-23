//
//  XMPPDiscoIdentity.m
//  webgnosus
//
//  Created by Troy Stribling on 8/4/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPDiscoIdentity.h"

//-----------------------------------------------------------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPDiscoIdentity

//-----------------------------------------------------------------------------------------------------------------------------------

//===================================================================================================================================
#pragma mark XMPPDiscoIdentity

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPDiscoIdentity*)createFromElement:(NSXMLElement*)element {
	XMPPDiscoIdentity* result = (XMPPDiscoIdentity*)element;
	result->isa = [XMPPDiscoIdentity class];
	return result;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPDiscoIdentity*)initWithCategory:(NSString*)identCategory {
	if(self = [super initWithName:@"identity"]) {
        [self addCategory:identCategory];
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPDiscoIdentity*)initWithCategory:(NSString*)identCategory andIname:(NSString*)identIname {
	if([self initWithCategory:identCategory]) {
        [self addIname:identIname];
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPDiscoIdentity*)initWithCategory:(NSString*)identCategory iname:(NSString*)identIname andType:(NSString*)identType {
	if([self initWithCategory:identCategory andIname:identIname]) {
        [self addType:identType];
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPDiscoIdentity*)initWithCategory:(NSString*)identCategory iname:(NSString*)identIname node:(NSString*)identNode andType:(NSString*)identType {
	if([self initWithCategory:identCategory iname:identIname andType:identType]) {
        [self addNode:identNode];
        [self addType:identType];
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)node {
    return [[self attributeForName:@"node"] stringValue];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addNode:(NSString*)val {
    [self addAttributeWithName:@"node" stringValue:val];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)iname {
    return [[self attributeForName:@"name"] stringValue];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addIname:(NSString*)val {
    [self addAttributeWithName:@"name" stringValue:val];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)category {
    return [[self attributeForName:@"category"] stringValue];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addCategory:(NSString*)val {
    [self addAttributeWithName:@"category" stringValue:val];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)type {
    return [[self attributeForName:@"type"] stringValue];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addType:(NSString*)val {
    [self addAttributeWithName:@"type" stringValue:val];
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
