//
//  XMPPPubSubGeoLocDelegate.m
//  webgnosus
//
//  Created by Troy Stribling on 10/5/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPPubSubGeoLocDelegate.h"
#import "XMPPJID.h"
#import "XMPPClient.h"
#import "XMPPIQ.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPPubSubGeoLocDelegate (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPPubSubGeoLocDelegate

//===================================================================================================================================
#pragma mark XMPPPubSubGeoLocDelegate

//===================================================================================================================================
#pragma mark XMPPPubSubGeoLocDelegate PrivateAPI

//===================================================================================================================================
#pragma mark XMPPResponse Delegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleError:(XMPPClient*)client forStanza:(XMPPIQ*)stanza {
    [[client multicastDelegate] xmppClient:client didReceivePubSubGeoLocError:stanza];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleResult:(XMPPClient*)client forStanza:(XMPPIQ*)stanza {
    [[client multicastDelegate] xmppClient:client didReceivePubSubGeoLocResult:stanza];
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
