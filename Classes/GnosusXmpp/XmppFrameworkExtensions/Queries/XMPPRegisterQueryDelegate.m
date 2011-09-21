//
//  XMPPRegisterQueryDelegate.m
//  webgnosus
//
//  Created by Troy Stribling on 11/3/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPRegisterQueryDelegate.h"
#import "XMPPClient.h"
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
+ (XMPPRegisterQueryDelegate*)delegate {
    return [[[XMPPRegisterQueryDelegate alloc] init] autorelease];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleError:(XMPPClient*)client forStanza:(XMPPIQ*)iq {
    [[client multicastDelegate] xmppClient:client didReceiveRegisterError:iq];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleResult:(XMPPClient*)client forStanza:(XMPPIQ*)iq {
    XMPPRegisterQuery* query = (XMPPRegisterQuery*)[iq query];
    AccountModel* account = [XMPPMessageDelegate accountForXMPPClient:client];
    if (account) {
        account.password = [query password];
        [account update];
    }
    [[client multicastDelegate] xmppClient:client didReceiveRegisterResult:iq];
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
