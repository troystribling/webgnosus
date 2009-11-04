//
//  XMPPRegisterQueryDelegate.m
//  webgnosus
//
//  Created by Troy Stribling on 11/3/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPRegisterQueryDelegate.h"
#import "XMPPResponse.h"
#import "XMPPClient.h"
#import "XMPPStanza.h"
#import "XMPPIQ.h"
#import "XMPPRegisterQuery.h"
#import "AccountModel.h"
#import "XMPPMessageDelegate.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPRegisterQueryDelegate (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPRegisterQueryDelegate

//===================================================================================================================================
#pragma mark XMPPRegisterQueryDelegate

//===================================================================================================================================
#pragma mark XMPPRegisterQueryDelegate PrivateAPI

//===================================================================================================================================
#pragma mark XMPPResponse Delegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleError:(XMPPClient*)client forStanza:(XMPPStanza*)stanza {
    [[client multicastDelegate] xmppClient:client didReceiveRegisterError:(XMPPIQ*)stanza];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleResult:(XMPPClient*)client forStanza:(XMPPStanza*)stanza {
    XMPPIQ* iq = (XMPPIQ*)stanza;
    XMPPRegisterQuery* query = (XMPPRegisterQuery*)[iq query];
    AccountModel* account = [XMPPMessageDelegate accountForXMPPClient:client];
    if (account) {
        account.password = [query password];
        [account update];
    }
    [[client multicastDelegate] xmppClient:client didReceiveRegisterResult:(XMPPIQ*)stanza];
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
