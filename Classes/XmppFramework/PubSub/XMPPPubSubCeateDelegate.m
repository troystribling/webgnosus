//
//  XMPPPubSubCeateDelegate.m
//  webgnosus
//
//  Created by Troy Stribling on 9/19/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPPubSubCeateDelegate.h"
#import "XMPPMessageDelegate.h"
#import "XMPPDiscoItemsQuery.h"
#import "XMPPResponse.h"
#import "XMPPJID.h"
#import "XMPPClient.h"
#import "XMPPStanza.h"
#import "XMPPIQ.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPPubSubCeateDelegate (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPPubSubCeateDelegate

//===================================================================================================================================
#pragma mark XMPPPubSubCeateDelegate

//===================================================================================================================================
#pragma mark XMPPPubSubCeateDelegate PrivateAPI

//===================================================================================================================================
#pragma mark XMPPResponse Delegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleError:(XMPPClient*)client forStanza:(XMPPStanza*)stanza {
    [XMPPMessageDelegate updateAccountConnectionState:AccountDiscoError forClient:client];
    [[client multicastDelegate] xmppClient:client didReceivePubSubSubscriptionsError:(XMPPIQ*)stanza];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleResult:(XMPPClient*)client forStanza:(XMPPStanza*)stanza {
    [XMPPDiscoItemsQuery get:client JID:[stanza fromJID] node:[[client myJID] pubSubRoot] forTarget:[client myJID]];
    [[client multicastDelegate] xmppClient:client didReceivePubSubSubscriptionsResult:(XMPPIQ*)stanza];
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
