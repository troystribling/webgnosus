//
//  XMPPDiscoItemsResponseDelegate.m
//  webgnosus
//
//  Created by Troy Stribling on 9/18/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPDiscoItemsResponseDelegate.h"
#import "XMPPDiscoInfoQuery.h"
#import "XMPPDiscoItemsQuery.h"
#import "XMPPDiscoItem.h"
#import "XMPPResponse.h"
#import "XMPPJID.h"
#import "XMPPClient.h"
#import "XMPPPubSub.h"
#import "XMPPIQ.h"
#import "XMPPError.h"
#import "XMPPPubSubSubscriptions.h"
#import "XMPPMessageDelegate.h"
#import "AccountModel.h"
#import "ServiceItemModel.h"
#import "ServiceModel.h"
#import "ServiceFeatureModel.h"
#import "SubscriptionModel.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPDiscoItemsResponseDelegate (PrivateAPI)

- (void)didDiscoverUserPubSubNode:(XMPPDiscoItem*)item forService:(XMPPJID*)serviceJID andParentNode:(NSString*)node;
- (void)didFailToDiscoverUserPubSubNode:(XMPPClient*)client forIQ:(XMPPIQ*)iq;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPDiscoItemsResponseDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize targetJID;

//===================================================================================================================================
#pragma mark XMPPDiscoItemsResponseDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)init:(XMPPJID*)initJID {
	if(self = [super init])  {
        self.targetJID = initJID;
	}
	return self;
}

//===================================================================================================================================
#pragma mark XMPPDiscoItemsResponseDelegate PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)didDiscoverUserPubSubNode:(XMPPDiscoItem*)item forService:(XMPPJID*)serviceJID andParentNode:(NSString*)node {
    [ServiceItemModel insert:item forService:serviceJID andParentNode:node];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)didFailToDiscoverUserPubSubNode:(XMPPClient*)client forIQ:(XMPPIQ*)iq {
    if ([client isAccountJID:[self.targetJID full]]) {
        [XMPPPubSub create:client JID:[iq fromJID] node:[self.targetJID pubSubRoot]];
    }
}

//===================================================================================================================================
#pragma mark XMPPResponse Delegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleError:(XMPPClient*)client forStanza:(XMPPStanza*)stanza {
    XMPPIQ* iq = (XMPPIQ*)stanza;
    XMPPDiscoItemsQuery* query = (XMPPDiscoItemsQuery*)[iq query];
	NSString* node = [query node];
    XMPPError* error = [iq error];	
    if (error) {
        if ([node isEqualToString:[self.targetJID pubSubRoot]] && [[error condition] isEqualToString:@"item-not-found"]) {
            [self didFailToDiscoverUserPubSubNode:client forIQ:iq];        
            [[client multicastDelegate] xmppClient:client didFailToDiscoverUserPubSubNode:iq];        
        }else {
            if ([client isAccountJID:[self.targetJID full]]) {
                [XMPPMessageDelegate updateAccountConnectionState:AccountDiscoError forClient:client];
            }
        }
    }    
    [[client multicastDelegate] xmppClient:client didReceiveDiscoItemsError:iq];        
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleResult:(XMPPClient*)client forStanza:(XMPPStanza*)stanza {
    XMPPIQ* iq = (XMPPIQ*)stanza;
    XMPPDiscoItemsQuery* query = (XMPPDiscoItemsQuery*)[iq query];
	NSString* parentNode = [query node];
    NSArray* items = [query items];	
	XMPPJID* serviceJID = [stanza fromJID];
    if ([parentNode isEqualToString:[self.targetJID pubSubRoot]]) {
        for(int i = 0; i < [items count]; i++) {
            XMPPDiscoItem* item = [XMPPDiscoItem createFromElement:(NSXMLElement *)[items objectAtIndex:i]];
            [self didDiscoverUserPubSubNode:item forService:serviceJID andParentNode:parentNode];
            [[client multicastDelegate] xmppClient:client didDiscoverUserPubSubNode:item forService:serviceJID andParentNode:parentNode];        
        }
        [XMPPPubSubSubscriptions get:client JID:serviceJID];
        [[client multicastDelegate] xmppClient:client didDiscoverAllUserPubSubNodes:self.targetJID];  
        [ServiceItemModel destroyAllUnsychedByService:[serviceJID full] andNode:parentNode];
        ServiceItemModel* pubSubServiceItem = [ServiceItemModel findByJID:[serviceJID full]];
        [ServiceModel destroyAllUnsychedByDomain:pubSubServiceItem.service];
        if ([client isAccountJID:[self.targetJID full]]) {
            [XMPPMessageDelegate updateAccountConnectionState:AccountDiscoCompleted forClient:client];
            AccountModel* account = [XMPPMessageDelegate accountForXMPPClient:client];
            NSArray* subServices = [SubscriptionModel findAllServicesByAccount:account];
            for(int i = 0; i < [subServices count]; i++) {
                NSString* subService = [subServices objectAtIndex:i];
                if (![subService isEqualToString:[serviceJID full]]) {
                    [XMPPPubSubSubscriptions get:client JID:[XMPPJID jidWithString:subService]];
                }
            }
        }
    } else if ([parentNode isEqualToString:@"http://jabber.org/protocol/commands"] && [[[stanza fromJID] full] isEqualToString:[self.targetJID full]]) {
        for(int i = 0; i < [items count]; i++) {
            XMPPDiscoItem* item = [XMPPDiscoItem createFromElement:(NSXMLElement *)[items objectAtIndex:i]];
            [ServiceItemModel insert:item forService:serviceJID andParentNode:parentNode];
        }
        [ServiceItemModel destroyAllUnsychedByService:[serviceJID full] andNode:parentNode];
    } else if ([parentNode isEqualToString:[self.targetJID pubSubDomain]]) {
        for(int i = 0; i < [items count]; i++) {
            XMPPDiscoItem* item = [XMPPDiscoItem createFromElement:(NSXMLElement *)[items objectAtIndex:i]];
            if ([[item node] isEqualToString:[self.targetJID pubSubRoot]]) {
                [ServiceItemModel insert:item forService:serviceJID andParentNode:nil];
                [XMPPDiscoItemsQuery get:client JID:[iq fromJID] node:[self.targetJID pubSubRoot] forTarget:self.targetJID];
            }
        }
        [ServiceItemModel destroyAllUnsychedByService:[serviceJID full]];
    } else if (parentNode == nil) {
        for(int i = 0; i < [items count]; i++) {
            XMPPDiscoItem* item = [XMPPDiscoItem createFromElement:(NSXMLElement *)[items objectAtIndex:i]];
            [ServiceItemModel insert:item forService:serviceJID andParentNode:nil];
            [XMPPDiscoInfoQuery get:client JID:[item JID] forTarget:self.targetJID];
        }
        [ServiceItemModel destroyAllUnsychedByService:[serviceJID full]];
    }
    [[client multicastDelegate] xmppClient:client didReceiveDiscoItemsResult:iq];        
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
