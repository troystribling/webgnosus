//
//  XMPPPubSub.m
//  webgnosus
//
//  Created by Troy Stribling on 8/8/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPPubSub.h"
#import "XMPPPubSubItems.h"
#import "XMPPPubSubItem.h"
#import "XMPPPubSubCeateDelegate.h"
#import "XMPPPubSubEntryDelegate.h"
#import "XMPPPubSubItemDelegate.h"
#import "XMPPIQ.h"
#import "XMPPJID.h"
#import "XMPPClient.h"
#import "XMPPEntry.h"
#import "XMPPPubSubSubscription.h"
#import "XMPPPubSubSubscriptions.h"
#import "XMPPPubSubItems.h"
#import "XMPPPubSubEvent.h"
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

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPPubSubItems*)items {
    XMPPPubSubItems* pubItems = nil;
    NSXMLElement* pubItemsElement = [self elementForName:@"items"];
    if (pubItemsElement) {
        pubItems = [XMPPPubSubItems createFromElement:pubItemsElement];
    }
    return pubItems;
}
    
//===================================================================================================================================
#pragma mark XMPPPubSub Messages

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)create:(XMPPClient*)client JID:(XMPPJID*)jid node:(NSString*)node {
    XMPPIQ* iq = [[XMPPIQ alloc] initWithType:@"set" toJID:[jid full]];
    XMPPPubSub* pubsub = [[XMPPPubSub alloc] init];
    NSXMLElement* createElement = [NSXMLElement elementWithName:@"create"];
    [createElement addAttributeWithName:@"node" stringValue:node];
    NSXMLElement* configElement = [NSXMLElement elementWithName:@"configure"];
    [pubsub addChild:createElement];	
    [pubsub addChild:configElement];	
    [iq addPubSub:pubsub];    
    [client send:iq andDelegateResponse:[[XMPPPubSubCeateDelegate alloc] init]];
    [iq release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)entry:(XMPPClient*)client JID:(XMPPJID*)jid node:(NSString*)node withTitle:(NSString*)title {
    XMPPIQ* iq = [[XMPPIQ alloc] initWithType:@"set" toJID:[jid full]];
    XMPPPubSub* pubsub = [[XMPPPubSub alloc] init];
    XMPPEntry* entry = [[XMPPEntry alloc] initWithTitle:title];
    NSXMLElement* publishElement = [NSXMLElement elementWithName:@"publish"];
    [publishElement addAttributeWithName:@"node" stringValue:node];
    NSXMLElement* itemsElement = [NSXMLElement elementWithName:@"item"];
    [itemsElement addChild:entry];
    [publishElement addChild:itemsElement];	
    [pubsub addChild:publishElement];	
    [iq addPubSub:pubsub];    
    [client send:iq andDelegateResponse:[[XMPPPubSubEntryDelegate alloc] init]];
    [iq release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)get:(XMPPClient*)client JID:(XMPPJID*)jid node:(NSString*)node withId:(NSString*)itemId {
    XMPPIQ* iq = [[XMPPIQ alloc] initWithType:@"get" toJID:[jid full]];
    XMPPPubSub* pubsub = [[XMPPPubSub alloc] init];
    XMPPPubSubItems* items = [[XMPPPubSubItems alloc] initWithNode:node];
    [items addItem:[[XMPPPubSubItem alloc] initWithId:itemId]];
    [pubsub addChild:items];	
    [iq addPubSub:pubsub];    
    [client send:iq andDelegateResponse:[[XMPPPubSubItemDelegate alloc] init]];
    [iq release];
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
