//
//  XMPPPubSub.m
//  webgnosus
//
//  Created by Troy Stribling on 8/8/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPPubSub.h"
#import "XMPPPubSubCeateDelegate.h"
#import "XMPPIQ.h"
#import "XMPPJID.h"
#import "XMPPClient.h"
#import "XMPPEntry.h"
#import "XMPPPubSubSubscription.h"
#import "XMPPPubSubSubscriptions.h"
#import "NSXMLElementAdditions.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPPubSub

//===================================================================================================================================
#pragma mark XMPPPubSub

//-----------------------------------------------------------------------------------------------------------------------------------

//===================================================================================================================================
#pragma mark XMPPPubSub

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPPubSub*)createFromElement:(NSXMLElement*)element {
    XMPPPubSub* result = (XMPPPubSub*)element;
    result->isa = [XMPPPubSub class];
    return result;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPPubSub*)init {
	if(self = [super initWithName:@"pubsub"]) {
        [self addNamespace:[NSXMLNode namespaceWithName:@"" stringValue:@"http://jabber.org/protocol/pubsub"]];
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSArray*)subscriptions {
    NSArray* subsArray = nil;
    NSXMLElement* subsElement = [self elementForName:@"subscriptions"];
    if (subsElement) {
        subsArray = [[XMPPPubSubSubscriptions createFromElement:subsElement] subscriptions];
    }
    [self elementsForName:@"subscription"];
    return subsArray;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPPubSubSubscription*)subscription {
    XMPPPubSubSubscription* sub = nil;
    NSXMLElement* subElement = [self elementForName:@"subscription"];
    if (subElement) {
        sub = [XMPPPubSubSubscription createFromElement:subElement];
    }
    return sub;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addSubscription:(XMPPPubSubSubscriptions*)val {
    [self addChild:val];
}

//===================================================================================================================================
#pragma mark XMPPPubSub Messages

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)create:(XMPPClient*)client JID:(XMPPJID*)jid node:(NSString*)node {
    XMPPIQ* iq = [[[XMPPIQ alloc] initWithType:@"set" toJID:[jid full]] autorelease];
    XMPPPubSub* pubsub = [[[XMPPPubSub alloc] init] autorelease];
    NSXMLElement* createElement = [NSXMLElement elementWithName:@"create"];
    [createElement addAttributeWithName:@"node" stringValue:node];
    NSXMLElement* configElement = [NSXMLElement elementWithName:@"configure"];
    [pubsub addChild:createElement];	
    [pubsub addChild:configElement];	
    [iq addPubSub:pubsub];    
    [client send:iq andDelegateResponse:[[XMPPPubSubCeateDelegate alloc] init]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)entry:(XMPPClient*)client JID:(XMPPJID*)jid node:(NSString*)node withSummary:(NSString*)summary {
    XMPPIQ* iq = [[[XMPPIQ alloc] initWithType:@"set" toJID:[jid full]] autorelease];
    XMPPPubSub* pubsub = [[[XMPPPubSub alloc] init] autorelease];
    XMPPEntry* entry = [[[XMPPEntry alloc] initWithSummary:summary] autorelease];
    NSXMLElement* publishElement = [NSXMLElement elementWithName:@"publish"];
    [publishElement addAttributeWithName:@"node" stringValue:node];
    NSXMLElement* itemsElement = [NSXMLElement elementWithName:@"item"];
    [itemsElement addChild:entry];
    [publishElement addChild:itemsElement];	
    [pubsub addChild:publishElement];	
    [iq addPubSub:pubsub];    
    [client send:iq andDelegateResponse:[[XMPPPubSubCeateDelegate alloc] init]];
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
