//
//  XMPPDiscoInfoQuery.m
//  webgnosus
//
//  Created by Troy Stribling on 8/4/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPDiscoInfoQuery.h"
#import "XMPPDiscoIdentity.h"
#import "XMPPDiscoFeature.h"
#import "NSXMLElementAdditions.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPDiscoInfoQuery

//===================================================================================================================================
#pragma mark XMPPDiscoInfoQuery

//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPDiscoInfoQuery*)createFromElement:(NSXMLElement*)element {
	XMPPDiscoInfoQuery* result = (XMPPDiscoInfoQuery*)element;
	result->isa = [XMPPDiscoInfoQuery class];
	return result;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPDiscoInfoQuery*)init {
	if(self = (XMPPDiscoInfoQuery*)[super initWithXMLNS:@"http://jabber.org/protocol/disco#info"]) {
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPDiscoInfoQuery*)initWithNode:(NSString*)itemsNode {
	if(self = [self init]) {
        [self addNode:itemsNode];
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
- (NSArray*)identities {
    return [self elementsForName:@"identity"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addIdentity:(XMPPDiscoIdentity*)val {
    [self addChild:val];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSArray*)features {
    return [self elementsForName:@"feature"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addFeature:(XMPPDiscoFeature*)val {
    [self addChild:val];
}

@end
