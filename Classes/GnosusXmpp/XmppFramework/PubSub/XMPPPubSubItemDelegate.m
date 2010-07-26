//
//  XMPPPubSubItemDelegate.m
//  webgnosus
//
//  Created by Troy Stribling on 10/22/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPPubSubItemDelegate.h"
#import "XMPPMessageDelegate.h"
#import "XMPPDiscoItemsQuery.h"
#import "XMPPResponse.h"
#import "XMPPJID.h"
#import "XMPPClient.h"
#import "XMPPStanza.h"
#import "XMPPIQ.h"
#import "MessageModel.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPPubSubItemDelegate (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPPubSubItemDelegate

//===================================================================================================================================
#pragma mark XMPPPubSubItemDelegate

//===================================================================================================================================
#pragma mark XMPPPubSubItemDelegate PrivateAPI

//===================================================================================================================================
#pragma mark XMPPResponse Delegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleError:(XMPPClient*)client forStanza:(XMPPStanza*)stanza {
    [[client multicastDelegate] xmppClient:client didReceivePubSubItemError:(XMPPIQ*)stanza];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleResult:(XMPPClient*)client forStanza:(XMPPStanza*)stanza {
    XMPPIQ* iq = (XMPPIQ*)stanza;
    [MessageModel insertPubSubItems:client forIq:iq];
    [[client multicastDelegate] xmppClient:client didReceivePubSubItemResult:iq];
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
