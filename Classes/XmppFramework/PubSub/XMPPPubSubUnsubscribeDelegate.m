//
//  XMPPPubSubUnsubscribeDelegate.m
//  webgnosus
//
//  Created by Troy Stribling on 9/23/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPPubSubUnsubscribeDelegate.h"
#import "XMPPPubSub.h"
#import "XMPPResponse.h"
#import "XMPPClient.h"
#import "XMPPStanza.h"
#import "XMPPIQ.h"
#import "XMPPError.h"
#import "AccountModel.h"
#import "SubscriptionModel.h"
#import "XMPPMessageDelegate.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPPubSubUnsubscribeDelegate (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPPubSubUnsubscribeDelegate

//===================================================================================================================================
#pragma mark XMPPPubSubUnsubscribeDelegate

//===================================================================================================================================
#pragma mark XMPPPubSubUnsubscribeDelegate PrivateAPI

//===================================================================================================================================
#pragma mark XMPPResponse Delegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleError:(XMPPClient*)client forStanza:(XMPPStanza*)stanza {
    XMPPIQ* iq = (XMPPIQ*)stanza;
    XMPPError* error = [iq error];	
    if (error) {
        if ([[error condition] isEqualToString:@"item-not-found"]) {
            XMPPPubSub* pubSub = [iq pubsub];
            NSXMLElement* unsub = [pubSub elementForName:@"unsubscribe"];
            if (unsub) {
                AccountModel* account = [XMPPMessageDelegate accountForXMPPClient:client];
                NSString* node = [[unsub attributeForName:@"node"] stringValue];
                SubscriptionModel* sub = [SubscriptionModel findByAccount:account andNode:node];
                [sub destroy];
            }
        }
    }    
    [[client multicastDelegate] xmppClient:client didReceivePubSubUnsubscribeError:(XMPPIQ*)stanza];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleResult:(XMPPClient*)client forStanza:(XMPPStanza*)stanza {
    [[client multicastDelegate] xmppClient:client didReceivePubSubUnsubscribeResult:(XMPPIQ*)stanza];
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
