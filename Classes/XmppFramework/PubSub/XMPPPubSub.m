//
//  XMPPPubSub.m
//  webgnosus
//
//  Created by Troy Stribling on 8/8/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPPubSub.h"
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
- (void)addSubscription:(XMPPPubSubSubscriptions*)val {
    [self addChild:val];
}

@end
