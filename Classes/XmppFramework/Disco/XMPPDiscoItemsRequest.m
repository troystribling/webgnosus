//
//  XMPPDiscoItemRequest.m
//  webgnosus
//
//  Created by Troy Stribling on 9/18/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPDiscoItemRequest.h"
#import "XMPPIQRequest.h"
#import "XMPPJID.h"
#import "XMPPClient.h"
#import "ServiceItemModel.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPDiscoItemsRequest (PrivateAPI)

- (void)didDiscoverUserPubSubNode:(XMPPDiscoItem*)item forService:(XMPPJID*)serviceJID andParentNode:(NSString*)node;
- (void)didFailToDiscoverUserPubSubNode:(XMPPIQ*)iq;
- (NSString*)targetJIDPubSubRoot;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPDiscoItemsRequest

//===================================================================================================================================
#pragma mark XMPPDiscoItemsRequest

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)init:(XMPPJID*)initJID {
	if(self = [super init])  {
        self.targetJID = initJID;
	}
	return self;
}

//===================================================================================================================================
#pragma mark XMPPDiscoItemsRequest PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)targetJIDPubSubRoot {
    return [[[NSString alloc] initWithFormat:@"/home/%@/%@", [self.targetJID domain], [self.targetJID user]] autorelease];	
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)didDiscoverUserPubSubNode:(XMPPDiscoItem*)item forService:(XMPPJID*)serviceJID andParentNode:(NSString*)node {
    [ServiceItemModel insert:item forService:serviceJID andParentNode:node];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)didFailToDiscoverUserPubSubNode:(XMPPIQ*)iq {
    [XMPPPubSub create:self.delegateClient JID:[iq fromJID] node:[self targetJIDPubSubRoot]];
}

//===================================================================================================================================
#pragma mark XMPPIQRequest

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleError:(XMPPClient*)client forIQ:(XMPPIQ*)iq {
    XMPPDiscoItemsQuery* query = (XMPPDiscoItemsQuery*)[iq query];
	NSString* node = [query node];
    XMPPError* error = [iq error];	
    if (error) {
        if ([node isEqualToString:[self targetJIDPubSubRoot]] && [[error condition] isEqualToString:@"item-not-found"]) {
            [self didFailToDiscoverUserPubSubNode:iq];        
        } 
    }    
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleResult:(XMPPClient*)client forIQ:(XMPPIQ*)iq {
    XMPPDiscoItemsQuery* query = (XMPPDiscoItemsQuery*)[iq query];
	NSString* node = [query node];
    NSArray* items = [query items];	
	XMPPJID* serviceJID = [iq fromJID];
    if ([node isEqualToString:[self targetJIDPubSubRoot]]) {
        for(int i = 0; i < [items count]; i++) {
            XMPPDiscoItem* item = [XMPPDiscoItem createFromElement:(NSXMLElement *)[items objectAtIndex:i]];
            [self didDiscoverUserPubSubNode:item forService:serviceJID andParentNode:node];
        }
    } else if ([node isEqualToString:@"http://jabber.org/protocol/commands"] && [[[iq fromJID] full] isEqualToString:[self.targetJID full]]) {
        for(int i = 0; i < [items count]; i++) {
            XMPPDiscoItem* item = [XMPPDiscoItem createFromElement:(NSXMLElement *)[items objectAtIndex:i]];
            [ServiceItemModel insert:item forService:serviceJID andParentNode:node];
        }
    } else {
        for(int i = 0; i < [items count]; i++) {
            XMPPDiscoItem* item = [XMPPDiscoItem createFromElement:(NSXMLElement *)[items objectAtIndex:i]];
            if ([item node] == nil) { 
                [XMPPDiscoInfoQuery get:client JID:[item JID] andNode:[item node]];
                [ServiceItemModel insert:item forService:serviceJID andParentNode:nil];
            }
        }
    }
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
