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

@end
