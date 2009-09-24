//
//  XMPPPubSubDeleteDelegate.m
//  webgnosus
//
//  Created by Troy Stribling on 9/23/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPPubSubDeleteDelegate.h"
#import "XMPPResponse.h"
#import "XMPPClient.h"
#import "XMPPStanza.h"
#import "XMPPIQ.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPPubSubDeleteDelegate (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPPubSubDeleteDelegate

//===================================================================================================================================
#pragma mark XMPPPubSubDeleteDelegate

//===================================================================================================================================
#pragma mark XMPPPubSubDeleteDelegate PrivateAPI

//===================================================================================================================================
#pragma mark XMPPResponse Delegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleError:(XMPPClient*)client forStanza:(XMPPStanza*)stanza {
    [[client multicastDelegate] xmppClient:client didReceivePubSubDeleteError:(XMPPIQ*)stanza];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleResult:(XMPPClient*)client forStanza:(XMPPStanza*)stanza {
    [[client multicastDelegate] xmppClient:client didReceivePubSubDeleteResult:(XMPPIQ*)stanza];
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
