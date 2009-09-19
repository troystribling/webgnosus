//
//  XMPPDiscoInfoRequest.m
//  webgnosus
//
//  Created by Troy Stribling on 9/18/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPDiscoInfoRequest.h"
#import "XMPPIQRequest.h"
#import "XMPPJID.h"
#import "XMPPClient.h"
#import "XMPPPubSubSubscriptions.h"
#import "ServiceModel.h"
#import "ServiceFeatureModel.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPDiscoInfoRequest (PrivateAPI)

- (void)didDiscoverPubSubService:(XMPPClient*)client forIQ:(XMPPIQ*)iq;
- (NSString*)targetJIDPubSubRoot;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPDiscoInfoRequest

//===================================================================================================================================
#pragma mark XMPPDiscoInfoRequest

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)init:(XMPPJID*)initJID {
	if(self = [super init])  {
        self.targetJID = initJID;
	}
	return self;
}

//===================================================================================================================================
#pragma mark XMPPDiscoInfoRequest PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)didDiscoverPubSubService:(XMPPClient*)client forIQ:(XMPPIQ*)iq {
    [XMPPPubSubSubscriptions get:client JID:[iq fromJID]];
    [XMPPDiscoItemsQuery get:client JID:[iq fromJID] andNode:[self targetJIDPubSubRoot]];
    [XMPPPubSubSubscriptions get:client JID:[iq fromJID]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)targetJIDPubSubRoot {
    return [[[NSString alloc] initWithFormat:@"/home/%@/%@", [self.targetJID domain], [self.targetJID user]] autorelease];	
}

//===================================================================================================================================
#pragma mark XMPPIQRequest

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleError:(XMPPClient*)client forIQ:(XMPPIQ*)iq {
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleResult:(XMPPClient*)client forIQ:(XMPPIQ*)iq {
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
