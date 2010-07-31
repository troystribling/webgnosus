//
//  XMPPPubSubEntryDelegate.m
//  webgnosus
//
//  Created by Troy Stribling on 10/5/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPPubSubEntryDelegate.h"
#import "XMPPMessageDelegate.h"
#import "XMPPDiscoItemsQuery.h"
#import "XMPPResponse.h"
#import "XMPPJID.h"
#import "XMPPClient.h"
#import "XMPPStanza.h"
#import "XMPPIQ.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPPubSubEntryDelegate (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPPubSubEntryDelegate

//===================================================================================================================================
#pragma mark XMPPPubSubEntryDelegate

//===================================================================================================================================
#pragma mark XMPPPubSubEntryDelegate PrivateAPI

//===================================================================================================================================
#pragma mark XMPPResponse Delegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleError:(XMPPClient*)client forStanza:(XMPPStanza*)stanza {
    [[client multicastDelegate] xmppClient:client didReceivePubSubEntryError:(XMPPIQ*)stanza];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleResult:(XMPPClient*)client forStanza:(XMPPStanza*)stanza {
    [[client multicastDelegate] xmppClient:client didReceivePubSubEntryResult:(XMPPIQ*)stanza];
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
