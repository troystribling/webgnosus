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
#import "XMPPError.h"
#import "XMPPDiscoInfoResponseDelegate.h"
#import "XMPPClient.h"
#import "XMPPIQ.h"
#import "XMPPJID.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPDiscoInfoQuery (PrivateAPI)

+ (void)error:(XMPPClient*)client condition:(NSString*)condition toJID:(XMPPJID*)jid andNode:(NSString*)itemNode;
+ (void)error:(XMPPClient*)client condition:(NSString*)condition toJID:(XMPPJID*)jid;

@end

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
#pragma mark XMPPDiscoInfoQuery PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)error:(XMPPClient*)client condition:(NSString*)condition toJID:(XMPPJID*)jid andNode:(NSString*)itemNode {
    XMPPIQ* iq = [[XMPPIQ alloc] initWithType:@"result" toJID:[jid full]];
    XMPPDiscoInfoQuery* infoQuery = [[self alloc] initWithNode:itemNode];
    XMPPError* error = [[XMPPError alloc] initWithType:@"cancel"];
    NSXMLElement* errorCondition = [NSXMLElement elementWithName:condition];
    [errorCondition addNamespace:[NSXMLNode namespaceWithName:@"" stringValue:@"urn:ietf:params:xml:ns:xmpp-stanzas"]];
    [error addChild:errorCondition];
    [iq addChild:error];
    [iq addQuery:infoQuery];
    [client sendElement:iq];
    [iq release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)error:(XMPPClient*)client condition:(NSString*)condition toJID:(XMPPJID*)jid {
    XMPPIQ* iq = [[XMPPIQ alloc] initWithType:@"result" toJID:[jid full]];
    XMPPDiscoInfoQuery* infoQuery = [[self alloc] init];
    XMPPError* error = [[XMPPError alloc] initWithType:@"cancel"];
    NSXMLElement* errorCondition = [NSXMLElement elementWithName:condition];
    [errorCondition addNamespace:[NSXMLNode namespaceWithName:@"" stringValue:@"urn:ietf:params:xml:ns:xmpp-stanzas"]];
    [error addChild:errorCondition];
    [iq addChild:error];
    [iq addQuery:infoQuery];
    [client sendElement:iq];
    [iq release];
}


//===================================================================================================================================
#pragma mark XMPPDiscoInfoQuery Messages

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)get:(XMPPClient*)client JID:(XMPPJID*)jid forTarget:(XMPPJID*)targetJID {
    XMPPIQ* iq = [[XMPPIQ alloc] initWithType:@"get" toJID:[jid full]];
    [iq addQuery:[[self alloc] init]];
    [client send:iq andDelegateResponse:[[XMPPDiscoInfoResponseDelegate alloc] init:targetJID]];
    [iq release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)get:(XMPPClient*)client JID:(XMPPJID*)jid node:(NSString*)node forTarget:(XMPPJID*)targetJID {
    [self get:client JID:jid node:node andDelegateResponse:[[XMPPDiscoInfoResponseDelegate alloc] init:targetJID]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)get:(XMPPClient*)client JID:(XMPPJID*)jid node:(NSString*)node andDelegateResponse:(id)responseDelegate {
    XMPPIQ* iq = [[XMPPIQ alloc] initWithType:@"get" toJID:[jid full]];
    [iq addQuery:[[self alloc] initWithNode:node]];
    [client send:iq andDelegateResponse:responseDelegate];
    [iq release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)features:(XMPPClient*)client toJID:(XMPPJID*)jid {
    NSArray* clientFeatures = [NSArray arrayWithObjects:@"http://jabber.org/protocol/disco#info", 
                                                        @"http://jabber.org/protocol/disco#items", 
                                                        @"jabber:iq:version", 
                                                        @"jabber:x:data", 
                                                        @"http://jabber.org/protocol/commands", 
                                                        @"http://jabber.org/protocol/pubsub", 
                                                        @"http://jabber.org/protocol/pubsub#publish",
                                                        @"http://jabber.org/protocol/pubsub#subscribe",
                                                        @"http://jabber.org/protocol/pubsub#create-nodes",
                                                        @"http://jabber.org/protocol/pubsub#delete-nodes", nil];
    XMPPIQ* iq = [[XMPPIQ alloc] initWithType:@"result" toJID:[jid full]];
    XMPPDiscoInfoQuery* infoQuery = [[self alloc] init];
    XMPPDiscoIdentity* identity = [[XMPPDiscoIdentity alloc] initWithCategory:[NSString stringWithUTF8String:kAPP_CATEGORY] iname:[NSString stringWithUTF8String:kAPP_NAME] andType:[NSString stringWithUTF8String:kAPP_TYPE]];
    [infoQuery addChild:identity];
    for (int i=0; i < [clientFeatures count]; i++) {
        NSString* var = [clientFeatures objectAtIndex:i];
        XMPPDiscoFeature* feature = [[XMPPDiscoFeature alloc] initWithVar:var];
        [infoQuery addChild:feature];
    }
    [iq addQuery:infoQuery];
    [client sendElement:iq];
    [iq release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)itemNotFound:(XMPPClient*)client toJID:(XMPPJID*)jid andNode:(NSString*)itemNode {
    [self error:client condition:@"item-not-found" toJID:jid andNode:itemNode];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)serviceUnavailable:(XMPPClient*)client toJID:(XMPPJID*)jid andNode:(NSString*)itemNode {
    [self error:client condition:@"service-unavailable" toJID:jid andNode:itemNode];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)itemNotFound:(XMPPClient*)client toJID:(XMPPJID*)jid {
    [self error:client condition:@"item-not-found" toJID:jid];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)serviceUnavailable:(XMPPClient*)client toJID:(XMPPJID*)jid {
    [self error:client condition:@"service-unavailable" toJID:jid];
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
