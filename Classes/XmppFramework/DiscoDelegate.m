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
#import "XMPPMessageDelegate.h"
#import "XMPPClientVersionQuery.h"
#import "XMPPClient.h"

#import "ServiceModel.h"
#import "ServiceFeatureModel.h"
#import "ServiceItemModel.h"
#import "AccountModel.h"
#import "ContactModel.h"
#import "RosterItemModel.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface DiscoDelegate (PrivateAPI)

- (void)didDiscoverPubSubService:(XMPPIQ*)iq;
- (void)didDiscoverUserPubSubRoot:(XMPPIQ*)iq;
- (void)didDiscoverUserPubSubNode:(XMPPDiscoItem*)item forService:(XMPPJID*)serviceJID andParentNode:(NSString*)node;
- (void)didFailToDiscoverUserPubSubNode:(XMPPIQ*)iq;
- (void)didReceiveDiscoCommandResult:(XMPPIQ*)iq;
- (void)deleteIfDone;
- (void)writeToLogMessage:(NSString*)message;
- (void)saveServiceItem:(XMPPDiscoItem*)item forService:(XMPPJID*)serviceJID andParentNode:(NSString*)parent;
- (void)saveServiceFeature:(XMPPDiscoFeature*)feature forService:(XMPPJID*)serviceJID andParentNode:(NSString*)parent;
- (void)saveService:(XMPPDiscoIdentity*)ident forService:(XMPPJID*)serviceJID;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation DiscoDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize targetJID;
@synthesize delegateClient;
@synthesize commandDiscoDone;
@synthesize versionDiscoDone;
@synthesize pubSubDiscoDone;

//===================================================================================================================================
#pragma mark DiscoDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initForContact:(XMPPClient*)initClient withJID:(XMPPJID*)initJID {
	if(self = [self initForAccount:initClient withJID:initJID])  {
        self.versionDiscoDone = NO;
        self.commandDiscoDone = NO;
        [XMPPClientVersionQuery get:self.delegateClient JID:initJID];
        [XMPPDiscoItemsQuery get:self.delegateClient JID:initJID andNode:@"http://jabber.org/protocol/commands"];
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initForAccount:(XMPPClient*)initClient withJID:(XMPPJID*)initJID {
	if(self = [super init])  {
        self.targetJID = initJID;
        self.delegateClient = initClient;
        self.versionDiscoDone = YES;
        self.commandDiscoDone = YES;
        self.pubSubDiscoDone = NO;
        [initClient addDelegate:self];
        [XMPPDiscoItemsQuery get:self.delegateClient JID:[XMPPJID jidWithString:[self.targetJID domain]]];
        [XMPPDiscoInfoQuery get:self.delegateClient JID:[XMPPJID jidWithString:[self.targetJID domain]]];
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
	[self writeToLogMessage:@"xmppClient:didReceiveDiscoItemsResult"];
    XMPPDiscoItemsQuery* query = (XMPPDiscoItemsQuery*)[iq query];
	NSString* node = [query node];
    NSArray* items = [query items];	
	XMPPJID* serviceJID = [iq fromJID];
    if ([node isEqualToString:[self targetJIDPubSubRoot]]) {
        for(int i = 0; i < [items count]; i++) {
            XMPPDiscoItem* item = [XMPPDiscoItem createFromElement:(NSXMLElement *)[items objectAtIndex:i]];
            [self didDiscoverUserPubSubNode:item forService:serviceJID andParentNode:node];
        }
        self.pubSubDiscoDone = YES;
        [self deleteIfDone];
    } else if ([node isEqualToString:@"http://jabber.org/protocol/commands"] && [[[iq fromJID] full] isEqualToString:[self.targetJID full]]) {
        for(int i = 0; i < [items count]; i++) {
            XMPPDiscoItem* item = [XMPPDiscoItem createFromElement:(NSXMLElement *)[items objectAtIndex:i]];
            [self saveServiceItem:item forService:serviceJID andParentNode:node];
        }
        self.commandDiscoDone = YES;
    } else {
        for(int i = 0; i < [items count]; i++) {
        XMPPDiscoItem* item = [XMPPDiscoItem createFromElement:(NSXMLElement *)[items objectAtIndex:i]];
            if ([item node] == nil) { 
                [XMPPDiscoInfoQuery get:client JID:[item JID] andNode:[item node]];
                [self saveServiceItem:item forService:serviceJID andParentNode:nil];
            }
        }
    }
    [self deleteIfDone];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceiveDiscoItemsError:(XMPPIQ*)iq {
	[self writeToLogMessage:@"xmppClient:didReceiveDiscoItemsError"];
    XMPPDiscoItemsQuery* query = (XMPPDiscoItemsQuery*)[iq query];
	NSString* node = [query node];
    XMPPError* error = [iq error];	
    if (error) {
        if ([node isEqualToString:[self targetJIDPubSubRoot]] && [[error condition] isEqualToString:@"item-not-found"]) {
            [self didFailToDiscoverUserPubSubNode:iq];        
        } else if ([node isEqualToString:[self targetJIDPubSubRoot]]) {
            self.pubSubDiscoDone = YES;
        } else if ([node isEqualToString:@"http://jabber.org/protocol/commands"] && [[[iq fromJID] full] isEqualToString:[self.targetJID full]]) {
            self.commandDiscoDone = YES;
        }
    }    
    [self deleteIfDone];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceiveDiscoInfoResult:(XMPPIQ*)iq {
	[self writeToLogMessage:@"xmppClient:didReceiveDiscoInfoResult"];
    XMPPDiscoInfoQuery* query = (XMPPDiscoInfoQuery*)[iq query];
    NSArray* identities = [query identities];	
	NSString* node = [query node];
	XMPPJID* serviceJID = [iq fromJID];
    for(int i = 0; i < [identities count]; i++) {
        XMPPDiscoIdentity* identity = [XMPPDiscoIdentity createFromElement:(NSXMLElement *)[identities objectAtIndex:i]];
        if (node == nil) {
            [self saveService:identity forService:[iq fromJID]];
        }
        if ([[identity category] isEqualToString:@"pubsub"] && [[identity type] isEqualToString:@"service"]) {
            [self didDiscoverPubSubService:iq];
        }
    }
    NSArray* features = [query features];		
    for(int i = 0; i < [features count]; i++) {
        XMPPDiscoFeature* feature = [XMPPDiscoFeature createFromElement:(NSXMLElement *)[features objectAtIndex:i]];
        [self saveServiceFeature:feature forService:serviceJID andParentNode:node];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceiveDiscoInfoError:(XMPPIQ*)iq {
	[self writeToLogMessage:@"xmppClient:didReceiveDiscoInfoError"];
    self.pubSubDiscoDone = YES;
    [self deleteIfDone];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceiveClientVersionResult:(XMPPIQ*)iq {
    [self writeToLogMessage:@"xmppClient:didReceiveClientVersionResult"];
    if ([[[iq fromJID] full] isEqualToString:[self.targetJID full]]) {
        self.versionDiscoDone = YES;
        XMPPClientVersionQuery* version = (XMPPClientVersionQuery*)[iq query];
        AccountModel* account = [XMPPMessageDelegate accountForXMPPClient:client];
        if (account) {
            XMPPJID* fromJid = [iq fromJID];
            RosterItemModel* rosterItem = [RosterItemModel findByFullJid:[fromJid full] andAccount:account];    
            if (rosterItem) {
                rosterItem.clientName = version.clientName; 
                rosterItem.clientVersion = version.clientVersion;
                [rosterItem update];
                NSInteger maxPriority = [RosterItemModel maxPriorityForJid:[fromJid bare] andAccount:account];
                ContactModel* contact = [ContactModel findByJid:[fromJid bare] andAccount:account]; 
                if ((maxPriority <= rosterItem.priority && [version.clientName isEqualToString:@"AgentXMPP"]) || [contact.clientName isEqualToString:@"Unknown"]) {
                    contact.clientName = version.clientName; 
                    contact.clientVersion = version.clientVersion;
                    [contact update];
                }
            }
        }
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceiveClientVersionError:(XMPPIQ*)iq {
    [self writeToLogMessage:@"xmppClient:didReceiveClientVersionError"];
    if ([[[iq fromJID] full] isEqualToString:[self.targetJID full]]) {
        self.versionDiscoDone = YES;
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceiveIQResult:(XMPPIQ*)iq {
	[self writeToLog:client message:@"xmppClient:didReceiveIQResult"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceiveCreateSubscriptionsResult:(XMPPIQ*)iq {
	[self writeToLog:client message:@"xmppClient:didReceiveCreateSubscriptionsResult"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceiveCreateSubscriptionsError:(XMPPIQ*)iq {
	[self writeToLog:client message:@"xmppClient:didReceiveCreateSubscriptionsError"];
}

//===================================================================================================================================
#pragma mark DiscoDelegate PrivateApi

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)didDiscoverPubSubService:(XMPPIQ*)iq {
	[self writeToLogMessage:@"didDiscoverPubSubService"];
    NSString* jid = [[iq fromJID] full];
    ServiceItemModel* item = [ServiceItemModel findByJID:[[iq fromJID] full]];
    [XMPPPubSubSubscriptions get:self.delegateClient JID:[iq fromJID]];
    [XMPPDiscoItemsQuery get:self.delegateClient JID:[iq fromJID] andNode:[self targetJIDPubSubRoot]];
    [XMPPPubSubSubscriptions get:self.delegateClient JID:[iq fromJID]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)didDiscoverUserPubSubRoot:(XMPPIQ*)iq {
	[self writeToLogMessage:@"didDiscoverUserPubSubRoot"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)didDiscoverUserPubSubNode:(XMPPDiscoItem*)item forService:(XMPPJID*)serviceJID andParentNode:(NSString*)node {
	[self writeToLogMessage:@"didDiscoverUserPubSubNode"];
    [self saveServiceItem:item forService:serviceJID andParentNode:node];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)didFailToDiscoverUserPubSubNode:(XMPPIQ*)iq {
	[self writeToLogMessage:@"didFailToDiscoverUserPubSubNode"];
    [XMPPPubSub create:self.delegateClient JID:[iq fromJID] node:[self targetJIDPubSubRoot]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)didReceiveDiscoCommandResult:(XMPPIQ*)iq {
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)deleteIfDone {
    if (self.commandDiscoDone && self.versionDiscoDone && self.pubSubDiscoDone) {
        [self.delegateClient removeDelegate:self];
        [self release];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)saveService:(XMPPDiscoIdentity*)ident forService:(XMPPJID*)serviceJID {
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
- (void)saveServiceItem:(XMPPDiscoItem*)item forService:(XMPPJID*)serviceJID andParentNode:(NSString*)parent {
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
- (void)saveServiceFeature:(XMPPDiscoFeature*)feature forService:(XMPPJID*)serviceJID andParentNode:(NSString*)parent {
    if (![ServiceFeatureModel findByService:[serviceJID full] andVar:[feature var]]) {
        ServiceFeatureModel* serviceFeature = [[ServiceFeatureModel alloc] init];
        serviceFeature.parentNode = parent;
        serviceFeature.var = [feature var];
        serviceFeature.service = [serviceJID full];
        [serviceFeature insert];
        [serviceFeature release];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)writeToLogmessage:(NSString*)message {
    if(DEBUG) {
        NSString* msg = [[NSString alloc] initWithFormat:@"DiscoDelegate %@: JID %@", message, [self.targetJID full]];
        NSLog(msg);
        [msg release];
    }
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
