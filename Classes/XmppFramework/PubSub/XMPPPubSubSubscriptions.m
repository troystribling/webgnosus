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
#import "NSXMLElementAdditions.h"

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
    [client sendElement:iq];
}

@end
