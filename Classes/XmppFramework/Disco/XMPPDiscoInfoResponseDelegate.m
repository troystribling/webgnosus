//
//  XMPPDiscoInfoResponseDelegate.m
//  webgnosus
//
//  Created by Troy Stribling on 9/18/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPDiscoInfoResponseDelegate.h"
#import "XMPPMessageDelegate.h"
#import "XMPPResponse.h"
#import "XMPPJID.h"
#import "XMPPIQ.h"
#import "XMPPClient.h"
#import "XMPPStanza.h"
#import "XMPPDiscoInfoQuery.h"
#import "XMPPDiscoItemsQuery.h"
#import "XMPPDiscoIdentity.h"
#import "XMPPDiscoFeature.h"
#import "AccountModel.h"
#import "ServiceModel.h"
#import "ServiceFeatureModel.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPDiscoInfoResponseDelegate (PrivateAPI)

- (void)didDiscoverPubSubService:(XMPPClient*)client forIQ:(XMPPIQ*)iq;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPDiscoInfoResponseDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize targetJID;

//===================================================================================================================================
#pragma mark XMPPDiscoInfoResponseDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)init:(XMPPJID*)initJID {
	if(self = [super init])  {
        self.targetJID = initJID;
	}
	return self;
}

//===================================================================================================================================
#pragma mark XMPPDiscoInfoResponseDelegate PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)didDiscoverPubSubService:(XMPPClient*)client forIQ:(XMPPIQ*)iq {
    [XMPPDiscoItemsQuery get:client JID:[iq fromJID] node:[self.targetJID pubSubDomain] forTarget:self.targetJID];
}

//===================================================================================================================================
#pragma mark XMPPResponse Delegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleError:(XMPPClient*)client forStanza:(XMPPStanza*)stanza {
    if ([client isAccountJID:[self.targetJID full]]) {
        [XMPPMessageDelegate updateAccountConnectionState:AccountDiscoError forClient:client];
    }
    [[client multicastDelegate] xmppClient:client didReceiveDiscoInfoResult:(XMPPIQ*)stanza];        
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleResult:(XMPPClient*)client forStanza:(XMPPStanza*)stanza {
    XMPPIQ* iq = (XMPPIQ*)stanza;
    XMPPDiscoInfoQuery* query = (XMPPDiscoInfoQuery*)[iq query];
    NSArray* identities = [query identities];	
	NSString* node = [query node];
	XMPPJID* serviceJID = [iq fromJID];
    for(int i = 0; i < [identities count]; i++) {
        XMPPDiscoIdentity* identity = [XMPPDiscoIdentity createFromElement:(NSXMLElement *)[identities objectAtIndex:i]];
        [ServiceModel insert:identity forService:serviceJID andNode:node];
        if ([[identity category] isEqualToString:@"pubsub"] && [[identity type] isEqualToString:@"service"]) {
            [self didDiscoverPubSubService:client forIQ:iq];
            [[client multicastDelegate] xmppClient:client didDiscoverPubSubService:iq];        
        }
    }
    NSArray* features = [query features];		
    for(int i = 0; i < [features count]; i++) {
        XMPPDiscoFeature* feature = [XMPPDiscoFeature createFromElement:(NSXMLElement *)[features objectAtIndex:i]];
        [ServiceFeatureModel insert:feature forService:serviceJID andNode:node];
    }
    [[client multicastDelegate] xmppClient:client didReceiveDiscoInfoResult:iq];        
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
