//
//  XMPPPubSubSubscribeDelegate.m
//  webgnosus
//
//  Created by Troy Stribling on 9/24/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPPubSubSubscribeDelegate.h"
#import "XMPPPubSubSubscription.h"
#import "XMPPResponse.h"
#import "XMPPClient.h"
#import "XMPPStanza.h"
#import "XMPPIQ.h"
#import "XMPPPubSub.h"
#import "XMPPPubSubSubscription.h"
#import "XMPPMessageDelegate.h"
#import "SubscriptionModel.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPPubSubSubscribeDelegate (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPPubSubSubscribeDelegate

//===================================================================================================================================
#pragma mark XMPPPubSubSubscribeDelegate

//===================================================================================================================================
#pragma mark XMPPPubSubSubscribeDelegate PrivateAPI

//===================================================================================================================================
#pragma mark XMPPResponse Delegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleError:(XMPPClient*)client forStanza:(XMPPStanza*)stanza {
    [[client multicastDelegate] xmppClient:client didReceivePubSubSubscribeError:(XMPPIQ*)stanza];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleResult:(XMPPClient*)client forStanza:(XMPPStanza*)stanza {
    XMPPIQ* iq = (XMPPIQ*)stanza;
    XMPPPubSub* pubsub = [iq pubsub];
    XMPPPubSubSubscription* subscription = [pubsub subscription];	
    [SubscriptionModel insert:subscription forAccount:[XMPPMessageDelegate accountForXMPPClient:client]];
    [[client multicastDelegate] xmppClient:client didReceivePubSubSubscribeResult:(XMPPIQ*)stanza];
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
