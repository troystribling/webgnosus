//
//  XMPPPubSubEntryDelegate.m
//  webgnosus
//
//  Created by Troy Stribling on 10/5/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPPubSubEntryDelegate.h"
#import "XMPPJID.h"
#import "XMPPClient.h"
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
+ (XMPPPubSubEntryDelegate*)delegate {
    return [[[XMPPPubSubEntryDelegate alloc] init] autorelease];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleError:(XMPPClient*)client forStanza:(XMPPIQ*)stanza {
    [[client multicastDelegate] xmppClient:client didReceivePubSubEntryError:stanza];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleResult:(XMPPClient*)client forStanza:(XMPPIQ*)stanza {
    [[client multicastDelegate] xmppClient:client didReceivePubSubEntryResult:stanza];
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
