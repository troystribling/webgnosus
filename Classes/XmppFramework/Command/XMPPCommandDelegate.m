//
//  XMPPCommandDelegate.m
//  webgnosus
//
//  Created by Troy Stribling on 11/5/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPCommandDelegate.h"
#import "XMPPMessageDelegate.h"
#import "XMPPClientManager.h"
#import "XMPPResponse.h"
#import "XMPPJID.h"
#import "XMPPIQ.h"
#import "XMPPClient.h"
#import "XMPPStanza.h"
#import "AccountModel.h"
#import "MessageModel.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPCommandDelegate (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPCommandDelegate

//-----------------------------------------------------------------------------------------------------------------------------------

//===================================================================================================================================
#pragma mark XMPPDiscoInfoResponseDelegate

//===================================================================================================================================
#pragma mark XMPPDiscoInfoResponseDelegate PrivateAPI

//===================================================================================================================================
#pragma mark XMPPResponse Delegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleError:(XMPPClient*)client forStanza:(XMPPStanza*)stanza {
    [[client multicastDelegate] xmppClient:client didReceiveCommandError:(XMPPIQ*)stanza];        
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleResult:(XMPPClient*)client forStanza:(XMPPStanza*)stanza {
    XMPPIQ* iq = (XMPPIQ*)stanza;
    [MessageModel insert:client commandResult:iq];
    [[[XMPPClientManager instance] messageCountUpdateDelegate] messageCountDidChange];
    [[client multicastDelegate] xmppClient:client didReceiveCommandResult:iq];        
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
