//
//  DiscoDelegate.m
//  webgnosus
//
//  Created by Troy Stribling on 9/14/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "DiscoDelegate.h"
#import "XMPPError.h"
#import "XMPPDiscoItemsQuery.h"
#import "XMPPDiscoItem.h"
#import "XMPPDiscoInfoQuery.h"
#import "XMPPDiscoIdentity.h"
#import "XMPPDiscoFeature.h"
#import "XMPPPubSubSubscriptions.h"
#import "XMPPIQ.h"
#import "XMPPJID.h"
#import "XMPPClientManager.h"
#import "XMPPClient.h"

#import "ServiceModel.h"
#import "ServiceFeatureModel.h"
#import "ServiceItemModel.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface DiscoDelegate (PrivateAPI)

- (void)writeToLog:(XMPPClient*)client message:(NSString*)message;
- (void)save:(XMPPClient*)client serviceItem:(XMPPDiscoItem*)item forService:(XMPPJID*)serviceJID andParentNode:(NSString*)parent;
- (void)save:(XMPPClient*)client serviceFeature:(XMPPDiscoFeature*)feature forService:(XMPPJID*)serviceJID andParentNode:(NSString*)parent;
- (void)save:(XMPPClient*)client service:(XMPPDiscoIdentity*)ident forService:(XMPPJID*)serviceJID;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation DiscoDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize targetJID;
@synthesize accountClient;
@synthesize pendingMsgID;

//===================================================================================================================================
#pragma mark DiscoDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)init:(XMPPClient*)initClient withTarget:(XMPPJID*)initJID {
	if(self = [super init])  {
        self.targetJID = initJID;
        self.accountClient = initClient;
        [initClient addDelegate:self];
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)targetJIDPubSubRoot {
    return [[[NSString alloc] initWithFormat:@"/home/%@/%@", [self.targetJID domain], [self.targetJID user]] autorelease];	
}

//===================================================================================================================================
#pragma mark XMPPClientDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceiveDiscoItemsResult:(XMPPIQ*)iq {
	[self writeToLog:client message:@"xmppClient:didReceiveDiscoItemsResult"];
    XMPPDiscoItemsQuery* query = (XMPPDiscoItemsQuery*)[iq query];
	NSString* node = [query node];
    NSArray* items = [query items];	
	XMPPJID* serviceJID = [iq fromJID];
    if ([node isEqualToString:[self targetJIDPubSubRoot]]) {
        for(int i = 0; i < [items count]; i++) {
            XMPPDiscoItem* item = [XMPPDiscoItem createFromElement:(NSXMLElement *)[items objectAtIndex:i]];
            [[client multicastDelegate] xmppClient:client didDiscoverUserPubSubNode:item forService:serviceJID andParentNode:node];
        }
        [self.accountClient removeDelegate:self];
        [self release];
    } else if ([node isEqualToString:@"http://jabber.org/protocol/commands"]) {
        for(int i = 0; i < [items count]; i++) {
            XMPPDiscoItem* item = [XMPPDiscoItem createFromElement:(NSXMLElement *)[items objectAtIndex:i]];
            [self save:client serviceItem:item forService:serviceJID andParentNode:node];
        }
    } else {
        for(int i = 0; i < [items count]; i++) {
        XMPPDiscoItem* item = [XMPPDiscoItem createFromElement:(NSXMLElement *)[items objectAtIndex:i]];
            if ([item node] == nil) { 
                [XMPPDiscoInfoQuery get:client JID:[item JID] andNode:[item node]];
                [self save:client serviceItem:item forService:serviceJID andParentNode:nil];
            }
        }
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceiveDiscoItemsError:(XMPPIQ*)iq {
	[self writeToLog:client message:@"xmppClient:didReceiveDiscoItemsError"];
    XMPPDiscoItemsQuery* query = (XMPPDiscoItemsQuery*)[iq query];
	NSString* node = [query node];
    XMPPError* error = [iq error];	
    if (error) {
        if ([node isEqualToString:[self targetJIDPubSubRoot]] && [[error condition] isEqualToString:@"item-not-found"]) {
            [[client multicastDelegate] xmppClient:client didFailToDiscoverUserPubSubNode:iq];        
        }
    }    
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceiveDiscoInfoResult:(XMPPIQ*)iq {
	[self writeToLog:client message:@"xmppClient:didReceiveDiscoInfoResult"];
    XMPPDiscoInfoQuery* query = (XMPPDiscoInfoQuery*)[iq query];
    NSArray* identities = [query identities];	
	NSString* node = [query node];
	XMPPJID* serviceJID = [iq fromJID];
    for(int i = 0; i < [identities count]; i++) {
        XMPPDiscoIdentity* identity = [XMPPDiscoIdentity createFromElement:(NSXMLElement *)[identities objectAtIndex:i]];
        if (node == nil) {
            [self save:client service:identity forService:[iq fromJID]];
        }
        if ([[identity category] isEqualToString:@"pubsub"] && [[identity type] isEqualToString:@"service"]) {
            [[client multicastDelegate] xmppClient:client didDiscoverPubSubService:iq];
        }
    }
    NSArray* features = [query features];		
    for(int i = 0; i < [features count]; i++) {
        XMPPDiscoFeature* feature = [XMPPDiscoFeature createFromElement:(NSXMLElement *)[features objectAtIndex:i]];
        [self save:client serviceFeature:feature forService:serviceJID andParentNode:node];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceiveDiscoInfoError:(XMPPIQ*)iq {
	[self writeToLog:client message:@"xmppClient:didReceiveDiscoInfoError"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didDiscoverPubSubService:(XMPPIQ*)iq {
	[self writeToLog:client message:@"xmppClient:didDiscoverPubSubService"];
    NSString* jid = [[iq fromJID] full];
    ServiceItemModel* item = [ServiceItemModel findByJID:[[iq fromJID] full]];
    [XMPPDiscoItemsQuery get:client JID:[iq fromJID] andNode:[self targetJIDPubSubRoot]];
    [XMPPPubSubSubscriptions get:client JID:[iq fromJID]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didDiscoverUserPubSubRoot:(XMPPIQ*)iq {
	[self writeToLog:client message:@"xmppClient:didDiscoverUserPubSubRoot"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didDiscoverUserPubSubNode:(XMPPDiscoItem*)item forService:(XMPPJID*)serviceJID andParentNode:(NSString*)node {
	[self writeToLog:client message:@"xmppClient:didDiscoverUserPubSubNode"];
    [self save:client serviceItem:item forService:serviceJID andParentNode:node];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didFailToDiscoverUserPubSubNode:(XMPPIQ*)iq {
	[self writeToLog:client message:@"xmppClient:didFailToDiscoverUserPubSubNode"];
}

//===================================================================================================================================
#pragma mark DiscoDelegate PrivateApi

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)writeToLog:(XMPPClient*)client message:(NSString*)message {
    if(DEBUG) {
        NSString* msg = [[NSString alloc] initWithFormat:@"DiscoDelegate %@: JID %@", message, [client.myJID full]];
        NSLog(msg);
        [msg release];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)save:(XMPPClient*)client service:(XMPPDiscoIdentity*)ident forService:(XMPPJID*)serviceJID {
    if (![ServiceModel findByJID:[serviceJID full] type:[ident type] andCategory:[ident category]]) {
        ServiceModel* service = [[ServiceModel alloc] init];
        service.jid = [serviceJID full];
        service.name = [ident iname];
        service.category = [ident category];
        service.type = [ident type];
        [service insert];
        [service release];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)save:(XMPPClient*)client serviceItem:(XMPPDiscoItem*)item forService:(XMPPJID*)serviceJID andParentNode:(NSString*)parent {
    if (![ServiceItemModel findByJID:[[item JID] full] andNode:[item node]]) {
        ServiceItemModel* serviceItem = [[ServiceItemModel alloc] init];
        serviceItem.parentNode = parent;
        serviceItem.itemName = [item iname];
        serviceItem.jid = [[item JID] full];
        serviceItem.service = [serviceJID full];
        serviceItem.node = [item node];
        [serviceItem insert];
        [serviceItem release];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)save:(XMPPClient*)client serviceFeature:(XMPPDiscoFeature*)feature forService:(XMPPJID*)serviceJID andParentNode:(NSString*)parent {
    if (![ServiceFeatureModel findByService:[serviceJID full] andVar:[feature var]]) {
        ServiceFeatureModel* serviceFeature = [[ServiceFeatureModel alloc] init];
        serviceFeature.parentNode = parent;
        serviceFeature.var = [feature var];
        serviceFeature.service = [serviceJID full];
        [serviceFeature insert];
        [serviceFeature release];
    }
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
