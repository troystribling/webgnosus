//
//  XMPPPubSubSubscriptions.m
//  webgnosus
//
//  Created by Troy Stribling on 8/8/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPPubSubSubscriptions.h"
#import "XMPPPubSubSubscription.h"
#import "XMPPPubSub.h"
#import "XMPPIQ.h"
#import "XMPPClient.h"
#import "XMPPJID.h"
#import "XMPPMessageDelegate.h"
#import "XMPPPubSubUnsubscribeDelegate.h"
#import "XMPPPubSubSubscribeDelegate.h"
#import "XMPPPubSubSubscriptionsDelegate.h"
#import "XMPPPubSubSubscriptions.h"
#import "NSXMLElementAdditions.h"
#import "AccountModel.h"

//-----------------------------------------------------------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPPubSubSubscriptions

//-----------------------------------------------------------------------------------------------------------------------------------

//===================================================================================================================================
#pragma mark XMPPPubSubSubscriptions

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPPubSubSubscriptions*)createFromElement:(NSXMLElement*)element {
	XMPPPubSubSubscriptions* result = (XMPPPubSubSubscriptions*)element;
	result->isa = [XMPPPubSubSubscriptions class];
	return result;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSArray*)subscriptions {
    return [self elementsForName:@"subscription"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addSubscription:(XMPPPubSubSubscription*)val {
    [self addChild:val];
}

//===================================================================================================================================
#pragma mark XMPPPubSubSubscriptions Messages

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)get:(XMPPClient*)client JID:(XMPPJID*)jid {
    XMPPIQ* iq = [[XMPPIQ alloc] initWithType:@"get" toJID:[jid full]];
    XMPPPubSub* pubsub = [[XMPPPubSub alloc] init];
    [pubsub addChild:[NSXMLElement elementWithName:@"subscriptions"]];	
    [iq addPubSub:pubsub];    
    [client send:iq andDelegateResponse:[[XMPPPubSubSubscriptionsDelegate alloc] init]];
    [iq release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)subscribe:(XMPPClient*)client JID:(XMPPJID*)jid node:(NSString*)node {
    AccountModel* account = [XMPPMessageDelegate accountForXMPPClient:client];
    XMPPIQ* iq = [[XMPPIQ alloc] initWithType:@"set" toJID:[jid full]];
    XMPPPubSub* pubsub = [[XMPPPubSub alloc] init];
    NSXMLElement* subElement = [NSXMLElement elementWithName:@"subscribe"];
    [subElement addAttributeWithName:@"node" stringValue:node];
    [subElement addAttributeWithName:@"jid" stringValue:[account bareJID]];
    [pubsub addChild:subElement];	
    [iq addPubSub:pubsub];    
    [client send:iq andDelegateResponse:[[XMPPPubSubSubscribeDelegate alloc] init:node]];
    [iq release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)unsubscribe:(XMPPClient*)client JID:(XMPPJID*)jid node:(NSString*)node andSubId:(NSString*)subId {
    AccountModel* account = [XMPPMessageDelegate accountForXMPPClient:client];
    XMPPIQ* iq = [[XMPPIQ alloc] initWithType:@"set" toJID:[jid full]];
    XMPPPubSub* pubsub = [[XMPPPubSub alloc] init];
    NSXMLElement* unsubElement = [NSXMLElement elementWithName:@"unsubscribe"];
    [unsubElement addAttributeWithName:@"node" stringValue:node];
    [unsubElement addAttributeWithName:@"jid" stringValue:[account bareJID]];
    [unsubElement addAttributeWithName:@"subid" stringValue:subId];
    [pubsub addChild:unsubElement];	
    [iq addPubSub:pubsub];    
    [client send:iq andDelegateResponse:[[XMPPPubSubUnsubscribeDelegate alloc] initWithNode:node andSubId:subId]];
    [iq release];
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
