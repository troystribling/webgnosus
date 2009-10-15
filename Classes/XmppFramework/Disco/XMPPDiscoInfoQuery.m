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
#import "XMPPResponse.h"
#import "XMPPDiscoInfoResponseDelegate.h"
#import "XMPPClient.h"
#import "XMPPIQ.h"
#import "XMPPJID.h"

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
        if (itemsNode) {
            [self addNode:itemsNode];
        }
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

//===================================================================================================================================
#pragma mark XMPPDiscoInfoQuery Messages

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)get:(XMPPClient*)client JID:(XMPPJID*)jid forTarget:(XMPPJID*)targetJID {
    XMPPIQ* iq = [[[XMPPIQ alloc] initWithType:@"get" toJID:[jid full]] autorelease];
    [iq addQuery:[[self alloc] init]];
    [client send:iq andDelegateResponse:[[XMPPDiscoInfoResponseDelegate alloc] init:targetJID]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)get:(XMPPClient*)client JID:(XMPPJID*)jid node:(NSString*)node forTarget:(XMPPJID*)targetJID {
    [self get:client JID:jid node:node andDelegateResponse:[[XMPPDiscoInfoResponseDelegate alloc] init:targetJID]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)get:(XMPPClient*)client JID:(XMPPJID*)jid node:(NSString*)node andDelegateResponse:(id)responseDelegate {
    XMPPIQ* iq = [[[XMPPIQ alloc] initWithType:@"get" toJID:[jid full]] autorelease];
    [iq addQuery:[[self alloc] initWithNode:node]];
    [client send:iq andDelegateResponse:responseDelegate];
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
