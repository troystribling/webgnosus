//
//  XMPPPubSubSubscriptionsDelegate.m
//  webgnosus
//
//  Created by Troy Stribling on 9/24/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPPubSubSubscriptionsDelegate.h"
#import "XMPPPubSubSubscription.h"
#import "XMPPResponse.h"
#import "XMPPPubSub.h"
#import "XMPPClient.h"
#import "XMPPStanza.h"
#import "XMPPIQ.h"
#import "XMPPJID.h"
#import "XMPPMessageDelegate.h"
#import "SubscriptionModel.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPPubSubSubscriptionsDelegate (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPPubSubSubscriptionsDelegate

//===================================================================================================================================
#pragma mark XMPPPubSubSubscriptionsDelegate

//===================================================================================================================================
#pragma mark XMPPPubSubSubscriptionsDelegate PrivateAPI

//===================================================================================================================================
#pragma mark XMPPResponse Delegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleError:(XMPPClient*)client forStanza:(XMPPStanza*)stanza {
    [XMPPMessageDelegate updateAccountConnectionState:AccountSubscriptionsUpdateError forClient:client];
    [[client multicastDelegate] xmppClient:client didReceivePubSubSubscriptionsError:(XMPPIQ*)stanza];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleResult:(XMPPClient*)client forStanza:(XMPPStanza*)stanza {
    XMPPIQ* iq = (XMPPIQ*)stanza;
    NSString* fromJID = [[iq fromJID] full];
    XMPPPubSub* pubsub = [iq pubsub];
    NSArray* subscriptions = [pubsub subscriptions];	
    for(int i = 0; i < [subscriptions count]; i++) {
        XMPPPubSubSubscription* subscription = [XMPPPubSubSubscription createFromElement:(NSXMLElement *)[subscriptions objectAtIndex:i]];
        [SubscriptionModel insert:subscription forService:fromJID andAccount:[XMPPMessageDelegate accountForXMPPClient:client]];
    }
    [XMPPMessageDelegate updateAccountConnectionState:AccountSubscriptionsUpdated forClient:client];
    [[client multicastDelegate] xmppClient:client didReceivePubSubSubscriptionsResult:(XMPPIQ*)stanza];
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
