//
//  XMPPDiscoItemsQuery.m
//  webgnosus
//
//  Created by Troy Stribling on 8/4/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPDiscoItemsQuery.h"
#import "XMPPDiscoItemsResponseDelegate.h"
#import "XMPPDiscoItem.h"
#import "XMPPError.h"
#import "XMPPClient.h"
#import "XMPPIQ.h"
#import "XMPPQuery.h"
#import "XMPPJID.h"
#import "XMPPResponse.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPDiscoItem (PrivateAPI)

+ (void)error:(XMPPClient*)client condition:(NSString*)condition forRequest:(XMPPIQ*)iq;

@end

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
#pragma mark XMPPDiscoItemsQuery PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)error:(XMPPClient*)client condition:(NSString*)condition forRequest:(XMPPIQ*)iq {
    XMPPIQ* respIq = [[XMPPIQ alloc] initWithType:@"result" toJID:[[iq fromJID] full] andId:[iq stanzaID]];
    XMPPDiscoItemsQuery* itemsQuery;
    NSString* node = [[iq query] node];
    if (node) {
        itemsQuery = [[self alloc] initWithNode:node];
    } else {
        itemsQuery = [[self alloc] init];
    }
    XMPPError* error = [[XMPPError alloc] initWithType:@"cancel"];
    NSXMLElement* errorCondition = [NSXMLElement elementWithName:condition];
    [errorCondition addNamespace:[NSXMLNode namespaceWithName:@"" stringValue:@"urn:ietf:params:xml:ns:xmpp-stanzas"]];
    [error addChild:errorCondition];
    [respIq addChild:error];
    [respIq addQuery:itemsQuery];
    [client sendElement:respIq];
    [respIq release];
}

//===================================================================================================================================
#pragma mark XMPPDiscoItemsQuery Messages

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)get:(XMPPClient*)client JID:(XMPPJID*)jid forTarget:(XMPPJID*)targetJID {
    XMPPIQ* iq = [[XMPPIQ alloc] initWithType:@"get" toJID:[jid full]];
    [iq addQuery:[[self alloc] init]];
    [client send:iq andDelegateResponse:[[XMPPDiscoItemsResponseDelegate alloc] init:targetJID]];
    [iq release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)get:(XMPPClient*)client JID:(XMPPJID*)jid andNode:(NSString*)node {
    [self get:client JID:jid node:node forTarget:jid];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)get:(XMPPClient*)client JID:(XMPPJID*)jid node:(NSString*)node forTarget:(XMPPJID*)targetJID {
    [self get:client JID:jid node:node andDelegateResponse:[[XMPPDiscoItemsResponseDelegate alloc] init:targetJID]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)get:(XMPPClient*)client JID:(XMPPJID*)jid node:(NSString*)node andDelegateResponse:(id)responseDelegate {
    XMPPIQ* iq = [[XMPPIQ alloc] initWithType:@"get" toJID:[jid full]];
    [iq addQuery:[[self alloc] initWithNode:node]];
    [client send:iq andDelegateResponse:responseDelegate];
    [iq release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)commands:(XMPPClient*)client forRequest:(XMPPIQ*)iq {
    NSArray* commandNodes = [NSArray arrayWithObjects:nil];
    NSArray* commandNames = [NSArray arrayWithObjects:nil];
    NSString* thisJID = [[client myJID] full];
    XMPPIQ* respIq = [[XMPPIQ alloc] initWithType:@"result" toJID:[[iq fromJID] full] andId:[iq stanzaID]];
    XMPPDiscoItemsQuery* itemQuery = [[self alloc] initWithNode:@"http://jabber.org/protocol/commands"];
    for (int i=0; i < [commandNodes count]; i++) {
        NSString* commandNode = [commandNodes objectAtIndex:i];
        NSString* commandName = [commandNames objectAtIndex:i];
        XMPPDiscoItem* item = [[XMPPDiscoItem alloc] initWithJID:thisJID iname:commandName andNode:commandNode];
        [itemQuery addChild:item];
    }
    [respIq addQuery:itemQuery];
    [client sendElement:respIq];
    [respIq release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)itemNotFound:(XMPPClient*)client forRequest:(XMPPIQ*)iq {
    [self error:client condition:@"item-not-found" forRequest:iq];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)serviceUnavailable:(XMPPClient*)client forRequest:(XMPPIQ*)iq {
    [self error:client condition:@"service-unavailable" forRequest:iq];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)notAllowed:(XMPPClient*)client forRequest:(XMPPIQ*)iq {
    [self error:client condition:@"not-allowed" forRequest:iq];
}


//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
