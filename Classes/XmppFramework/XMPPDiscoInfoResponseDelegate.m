//
//  XMPPDiscoInfoResponseDelegate.m
//  webgnosus
//
//  Created by Troy Stribling on 9/18/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPDiscoInfoResponseDelegate.h"
#import "XMPPResponse.h"
#import "XMPPJID.h"
#import "XMPPIQ.h"
#import "XMPPClient.h"
#import "XMPPStanza.h"
#import "XMPPPubSubSubscriptions.h"
#import "XMPPDiscoInfoQuery.h"
#import "XMPPDiscoItemsQuery.h"
#import "XMPPDiscoIdentity.h"
#import "XMPPDiscoFeature.h"
#import "ServiceModel.h"
#import "ServiceFeatureModel.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPDiscoInfoResponseDelegate (PrivateAPI)

- (void)didDiscoverPubSubService:(XMPPClient*)client forIQ:(XMPPIQ*)iq;
- (NSString*)targetJIDPubSubRoot;

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
    [XMPPPubSubSubscriptions get:client JID:[iq fromJID]];
    [XMPPDiscoItemsQuery get:client JID:[iq fromJID] node:[self targetJIDPubSubRoot] forTarget:self.targetJID];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)targetJIDPubSubRoot {
    return [[[NSString alloc] initWithFormat:@"/home/%@/%@", [self.targetJID domain], [self.targetJID user]] autorelease];	
}

//===================================================================================================================================
#pragma mark XMPPResponse Delegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleError:(XMPPClient*)client forStanza:(XMPPStanza*)stanza {
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
        if (node == nil) {
            [ServiceModel insert:identity forService:[iq fromJID]];
        }
        if ([[identity category] isEqualToString:@"pubsub"] && [[identity type] isEqualToString:@"service"]) {
            [self didDiscoverPubSubService:client forIQ:iq];
        }
    }
    NSArray* features = [query features];		
    for(int i = 0; i < [features count]; i++) {
        XMPPDiscoFeature* feature = [XMPPDiscoFeature createFromElement:(NSXMLElement *)[features objectAtIndex:i]];
        [ServiceFeatureModel insert:feature forService:serviceJID andParentNode:node];
    }
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
