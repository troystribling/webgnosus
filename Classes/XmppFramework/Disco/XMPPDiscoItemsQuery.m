//
//  XMPPDiscoItemsQuery.m
//  webgnosus
//
//  Created by Troy Stribling on 8/4/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPDiscoItemsQuery.h"
#import "XMPPDiscoItem.h"
#import "XMPPClient.h"
#import "XMPPIQ.h"
#import "XMPPJID.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPDiscoItemsQuery

//-----------------------------------------------------------------------------------------------------------------------------------

//===================================================================================================================================
#pragma mark XMPPDiscoItemsQuery

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPDiscoItemsQuery*)createFromElement:(NSXMLElement*)element {
	XMPPDiscoItemsQuery* result = (XMPPDiscoItemsQuery*)element;
	result->isa = [XMPPDiscoItemsQuery class];
	return result;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPDiscoItemsQuery*)init {
	if(self = (XMPPDiscoItemsQuery*)[super initWithXMLNS:@"http://jabber.org/protocol/disco#items"]) {
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPDiscoItemsQuery*)initWithNode:(NSString*)itemsNode {
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
- (NSArray*)items {
    return [self elementsForName:@"item"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addItem:(XMPPDiscoItem*)val {
    [self addChild:val];
}

//===================================================================================================================================
#pragma mark XMPPDiscoItemsQuery Messages

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)get:(XMPPClient*)client  JID:(XMPPJID*)jid {
    XMPPIQ* iq = [[XMPPIQ alloc] initWithType:@"get" toJID:[jid full]];
    [iq addQuery:[[self alloc] init]];
    [client sendElement:iq];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)get:(XMPPClient*)client  JID:(XMPPJID*)jid andNode:(NSString*)node {
    XMPPIQ* iq = [[XMPPIQ alloc] initWithType:@"get" toJID:[jid full]];
    [iq addQuery:[[self alloc] initWithNode:node]];
    [client sendElement:iq];
}

@end
