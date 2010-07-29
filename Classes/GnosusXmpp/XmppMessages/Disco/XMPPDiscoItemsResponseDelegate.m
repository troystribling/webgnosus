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
        [[client multicastDelegate] xmppClient:client didFailToDiscoverUserPubSubNode:iq];        
    }
}

//===================================================================================================================================
#pragma mark XMPPResponse Delegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleError:(XMPPClient*)client forStanza:(XMPPStanza*)stanza {
    XMPPIQ* iq = (XMPPIQ*)stanza;
    XMPPError* error = [iq error];	
    if (error) {
        if ([client isAccountJID:[self.targetJID full]]) {
            [XMPPMessageDelegate updateAccountConnectionState:AccountDiscoError forClient:client];
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
    } else if ([parentNode isEqualToString:[self.targetJID pubSubDomain]]) {
        NSInteger itemCount = [items count];
        BOOL didNotDiscoverPubSubRoot = YES;
        if (itemCount > 0) {
            for(int i = 0; i < itemCount; i++) {
                XMPPDiscoItem* item = [XMPPDiscoItem createFromElement:(NSXMLElement *)[items objectAtIndex:i]];
                if ([[item node] isEqualToString:[self.targetJID pubSubRoot]]) {
                    didNotDiscoverPubSubRoot = NO;
                    [ServiceItemModel insert:item forService:serviceJID andParentNode:parentNode];
                    [XMPPDiscoItemsQuery get:client JID:[iq fromJID] node:[self.targetJID pubSubRoot] forTarget:self.targetJID];
                }
            }
        } 
        if (didNotDiscoverPubSubRoot) {
            [self didFailToDiscoverUserPubSubNode:client forIQ:iq];
        }
    } else if (parentNode == nil) {
        for(int i = 0; i < [items count]; i++) {
            XMPPDiscoItem* item = [XMPPDiscoItem createFromElement:(NSXMLElement *)[items objectAtIndex:i]];
            [ServiceItemModel insert:item forService:serviceJID andParentNode:nil];
            [XMPPDiscoInfoQuery get:client JID:[item JID] node:[item node] forTarget:self.targetJID];
        }
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
