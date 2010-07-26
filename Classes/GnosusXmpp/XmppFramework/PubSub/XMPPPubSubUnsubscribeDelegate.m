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

- (void)destroySubscription:(XMPPClient*)account;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPPubSubUnsubscribeDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize node;
@synthesize subId;

//===================================================================================================================================
#pragma mark XMPPPubSubUnsubscribeDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithNode:(NSString*)initNode andSubId:(NSString*)initSubId {
	if(self = [super init])  {
        self.node = initNode;
        self.subId = initSubId;
	}
	return self;
}

//===================================================================================================================================
#pragma mark XMPPPubSubUnsubscribeDelegate PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)destroySubscription:(XMPPClient*)client {
    AccountModel* account = [XMPPMessageDelegate accountForXMPPClient:client];
    SubscriptionModel* subscription = [SubscriptionModel findByAccount:account node:self.node andSubId:self.subId];
    [subscription destroy];
}

//===================================================================================================================================
#pragma mark XMPPResponse Delegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleError:(XMPPClient*)client forStanza:(XMPPStanza*)stanza {
    XMPPIQ* iq = (XMPPIQ*)stanza;
    XMPPError* error = [iq error];	
    if (error) {
        if ([[error condition] isEqualToString:@"item-not-found"] || 
            [[error condition] isEqualToString:@"unexpected-request"] || 
            [[error condition] isEqualToString:@"not-subscribed"]) {
            XMPPPubSub* pubSub = [iq pubsub];
            NSXMLElement* unsub = [pubSub elementForName:@"unsubscribe"];
            if (unsub) {
                [self destroySubscription:client];
            }
        }
    }    
    [[client multicastDelegate] xmppClient:client didReceivePubSubUnsubscribeError:(XMPPIQ*)stanza];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleResult:(XMPPClient*)client forStanza:(XMPPStanza*)stanza {
    [self destroySubscription:client];
    [[client multicastDelegate] xmppClient:client didReceivePubSubUnsubscribeResult:(XMPPIQ*)stanza];
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
