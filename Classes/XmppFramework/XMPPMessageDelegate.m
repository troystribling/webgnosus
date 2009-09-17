//
//  XMPPMessageDelegate.m
//  webgnosus
//
//  Created by Troy Stribling on 8/11/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPMessageDelegate.h"
#import "RosterItemModel.h"
#import "ContactModel.h"
#import "MessageModel.h"
#import "AccountModel.h"
#import "ServiceItemModel.h"
#import "ServiceFeatureModel.h"
#import "ServiceModel.h"
#import "SubscriptionModel.h"

#import "XMPPClient.h"
#import "XMPPJID.h"
#import "XMPPPresence.h"
#import "XMPPIQ.h"
#import "XMPPMessage.h"
#import "XMPPClientVersionQuery.h"
#import "XMPPRosterQuery.h"
#import "XMPPDiscoItemsQuery.h"
#import "XMPPDiscoItem.h"
#import "XMPPDiscoInfoQuery.h"
#import "XMPPDiscoIdentity.h"
#import "XMPPDiscoFeature.h"
#import "XMPPRosterItem.h"
#import "XMPPCommand.h"
#import "XMPPError.h"
#import "XMPPPubSubSubscription.h"
#import "XMPPPubSubSubscriptions.h"
#import "XMPPxData.h"

#import "NSObjectiPhoneAdditions.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPMessageDelegate (PrivateAPI)

- (void)writeToLog:(XMPPClient*)client message:(NSString*)message;
//- (void)save:(XMPPClient*)client serviceItem:(XMPPDiscoItem*)item forService:(XMPPJID*)serviceJID andParentNode:(NSString*)parent;
//- (void)save:(XMPPClient*)client serviceFeature:(XMPPDiscoFeature*)feature forService:(XMPPJID*)serviceJID andParentNode:(NSString*)parent;
//- (void)save:(XMPPClient*)client service:(XMPPDiscoIdentity*)ident forService:(XMPPJID*)serviceJID;
- (void)save:(XMPPClient*)client subscription:(XMPPPubSubSubscription*)sub;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPMessageDelegate

//-----------------------------------------------------------------------------------------------------------------------------------

//===================================================================================================================================
#pragma mark XMPPMessageDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSString*)userPubSubRoot:(XMPPClient*)client {
    return [[[NSString alloc] initWithFormat:@"/home/%@/%@", [[client myJID] domain], [[client myJID] user]] autorelease];	
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (AccountModel*)accountForXMPPClient:(XMPPClient*)client {
    return [AccountModel findByJID:[client.myJID bare]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)removeContact:(XMPPClient*)client JID:(XMPPJID*)contactJid {
    AccountModel* account = [XMPPMessageDelegate accountForXMPPClient:client];
    if (account) {
        ContactModel* contact = [ContactModel findByJid:[contactJid bare] andAccount:account];	
        if (contact) {
            [contact destroy];
        }
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)addContact:(XMPPClient*)client JID:(XMPPJID*)contactJid {
    AccountModel* account = [XMPPMessageDelegate accountForXMPPClient:client];
    if (account) {
        ContactModel* contact = [ContactModel findByJid:[contactJid bare] andAccount:account];	
        if (contact == nil) {
            contact = [[ContactModel alloc] init];
            contact.accountPk = account.pk;	
            contact.jid = [contactJid bare];
            contact.host = [contactJid domain];
            contact.clientName = @"Unknown";
            contact.clientVersion = @"Unknown";
            contact.contactState = ContactIsOk;
            contact.nickname = contact.jid;
            [contact insert];
        }
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)updateAccountConnectionState:(AccountConnectionState)state forClient:(XMPPClient*)client { 
    AccountModel* account = [XMPPMessageDelegate accountForXMPPClient:client];
    account.connectionState = state;
    [account update];
}

//===================================================================================================================================
#pragma mark Messages

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)addBuddy:(XMPPClient*)client JID:(XMPPJID*)buddyJid {
    if (buddyJid) {
        [XMPPRosterQuery update:client JID:buddyJid];
        [XMPPPresence subscribe:client JID:buddyJid];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)acceptBuddyRequest:(XMPPClient*)client JID:(XMPPJID*)buddyJid {
    if (buddyJid) {
        [XMPPMessageDelegate addContact:client JID:buddyJid];
        [XMPPPresence accept:client JID:buddyJid];
        [XMPPPresence subscribe:client JID:buddyJid];
        [XMPPRosterQuery update:client JID:buddyJid];
    }
}

//===================================================================================================================================
#pragma mark Connection

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClientConnecting:(XMPPClient *)client {
	[self writeToLog:client message:@"xmppClientConnecting"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClientDidConnect:(XMPPClient *)client {
    [self writeToLog:client message:@"xmppClientDidConnect"];
    AccountModel* account = [XMPPMessageDelegate accountForXMPPClient:client];
    if (account) {
    }
    [XMPPMessageDelegate updateAccountConnectionState:AccountConnected forClient:client];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClientDidNotConnect:(XMPPClient *)client {
	[self writeToLog:client message:@"xmppClientDidNotConnect"];
    [XMPPMessageDelegate updateAccountConnectionState:AccountConnectionError forClient:client];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClientDidDisconnect:(XMPPClient *)client {
	[self writeToLog:client message:@"xmppClientDidDisconnect"];
    [XMPPMessageDelegate updateAccountConnectionState:AccountNotConnected forClient:client];
}

//===================================================================================================================================
#pragma mark registration

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClientDidRegister:(XMPPClient *)client {
	[self writeToLog:client message:@"xmppClientDidRegister"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didNotRegister:(NSXMLElement*)error {
	[self writeToLog:client message:@"xmppClient:didNotRegister"];
}

//===================================================================================================================================
#pragma mark Authentication

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClientDidAuthenticate:(XMPPClient *)client {
	[self writeToLog:client message:@"xmppClientDidAuthenticate"];
    [XMPPMessageDelegate updateAccountConnectionState:AccountAuthenticated forClient:client];
    [XMPPRosterQuery get:client];
    [XMPPPresence goOnline:client withPriority:(NSInteger)1];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didNotAuthenticate:(NSXMLElement*)error {
	[self writeToLog:client message:@"xmppClient:didNotAuthenticate"];
    [XMPPMessageDelegate updateAccountConnectionState:AccountAuthenticationError forClient:client];
}

//===================================================================================================================================
#pragma mark IQ

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceiveIQResult:(XMPPIQ*)iq {
	[self writeToLog:client message:@"xmppClient:didReceiveIQResult"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceiveIQError:(XMPPIQ*)iq {
	[self writeToLog:client message:@"xmppClient:didReceiveIQError"];
}

//===================================================================================================================================
#pragma mark Roster

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceiveRosterItems:(XMPPIQ*)iq {
	[self writeToLog:client message:@"xmppClient:didReceiveRosterItems"];
    XMPPRosterQuery* query = (XMPPRosterQuery*)[iq query];
    NSArray* items = [query items];		
    for(int i = 0; i < [items count]; i++) {
        XMPPRosterItem* item = [XMPPRosterItem createFromElement:(NSXMLElement *)[items objectAtIndex:i]];            
        if([item.subscription isEqualToString:@"remove"]) {
            [[client multicastDelegate]  xmppClient:client didRemoveFromRoster:item];;
        }
        else {
            [[client multicastDelegate]  xmppClient:client didAddToRoster:item];;
        }
    }
    [[client multicastDelegate]  xmppClient:client didFinishReceivingRosterItems:iq];;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didAddToRoster:(XMPPRosterItem*)item {
	[self writeToLog:client message:@"xmppClient:didAddToRoster"];
    [XMPPMessageDelegate addContact:client JID:[item jid]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didRemoveFromRoster:(XMPPRosterItem*)item {
	[self writeToLog:client message:@"xmppClient:didRemoveFromRoster"];
    [XMPPMessageDelegate removeContact:client JID:[item jid]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didFinishReceivingRosterItems:(XMPPIQ *)iq {
	[self writeToLog:client message:@"didFinishReceivingRosterItems"];
    [XMPPMessageDelegate updateAccountConnectionState:AccountRosterUpdated forClient:client];
}

//===================================================================================================================================
#pragma mark Presence

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceivePresence:(XMPPPresence*)presence {
    [self writeToLog:client message:@"xmppClient:didReceivePresence"];
    AccountModel* account = [XMPPMessageDelegate accountForXMPPClient:client];
    if (account) {
        XMPPJID* fromJid = [presence fromJID];
        NSString* fromResource = [fromJid resource];
        RosterItemModel* rosterItem = [RosterItemModel findByFullJid:[fromJid full] andAccount:account];    
        if (!rosterItem) {
            rosterItem = [[RosterItemModel alloc] init]; 
            rosterItem.jid = [fromJid bare];
            rosterItem.resource = fromResource;
            rosterItem.host = [fromJid domain];
            rosterItem.accountPk = account.pk;
            rosterItem.clientName = @"";
            rosterItem.clientVersion = @"";
            [rosterItem insert];
            [rosterItem load];
        }
        NSString* showVal = [presence show];
        if (showVal) {
            rosterItem.show = showVal;
        } else {
            rosterItem.show = @"";
        }
        NSString* statusVal = [presence status];
        if (statusVal) {
            rosterItem.status = statusVal;
        } else {
            rosterItem.status = @"";
        }
        rosterItem.priority = [presence priority];
        rosterItem.presenceType = [presence type];
        [rosterItem update];
        if ([rosterItem.presenceType isEqualToString:@"available"]) {
            [XMPPClientVersionQuery get:client JID:[presence fromJID]];
            [XMPPDiscoItemsQuery get:client JID:[presence fromJID] andNode:@"http://jabber.org/protocol/commands"];
        } 
        ContactModel* contact = [ContactModel findByJid:[fromJid bare] andAccount:account];
        RosterItemModel* maxPriorityRosteritem =[RosterItemModel findWithMaxPriorityByJid:[fromJid bare] andAccount:account];
        contact.clientName = maxPriorityRosteritem.clientName;
        contact.clientVersion = maxPriorityRosteritem.clientVersion;
        [contact update];
        [contact release];
        [rosterItem release];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceiveErrorPresence:(XMPPPresence*)presence  {
    AccountModel* account = [XMPPMessageDelegate accountForXMPPClient:client];
    ContactModel* contact = [ContactModel findByJid:[[presence fromJID] bare] andAccount:account];
    contact.contactState = ContactHasError;
    [contact update];
	[self writeToLog:client message:@"xmppClient:didReceiveErrorPresence"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceiveBuddyRequest:(XMPPJID*)buddyJid {
	[self writeToLog:client message:@"xmppClient:didReceiveBuddyRequest"];
    AccountModel* account = [XMPPMessageDelegate accountForXMPPClient:client];
    if (account) {
        ContactModel* contact = [ContactModel findByJid:[buddyJid bare] andAccount:account];	
        if (contact) {
            [XMPPMessageDelegate acceptBuddyRequest:client JID:buddyJid];
        }
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didAcceptBuddyRequest:(XMPPJID*)buddyJid {
    [XMPPMessageDelegate addContact:client JID:buddyJid];
	[self writeToLog:client message:@"xmppClient:didAcceptBuddyRequest"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didRejectBuddyRequest:(XMPPJID*)buddyJid {
    [self writeToLog:client message:@"xmppClient:didRejectBuddyRequest"];
}

//===================================================================================================================================
#pragma mark Version Discovery

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceiveClientVersionResult:(XMPPIQ*)iq {
//    [self writeToLog:client message:@"xmppClient:didReceiveClientVersionResult"];
//    XMPPClientVersionQuery* version = (XMPPClientVersionQuery*)[iq query];
//    AccountModel* account = [XMPPMessageDelegate accountForXMPPClient:client];
//    if (account) {
//        XMPPJID* fromJid = [iq fromJID];
//        RosterItemModel* rosterItem = [RosterItemModel findByFullJid:[fromJid full] andAccount:account];    
//        if (rosterItem) {
//            rosterItem.clientName = version.clientName; 
//            rosterItem.clientVersion = version.clientVersion;
//            [rosterItem update];
//            NSInteger maxPriority = [RosterItemModel maxPriorityForJid:[fromJid bare] andAccount:account];
//            ContactModel* contact = [ContactModel findByJid:[fromJid bare] andAccount:account]; 
//            if ((maxPriority <= rosterItem.priority && [version.clientName isEqualToString:@"AgentXMPP"]) || [contact.clientName isEqualToString:@"Unknown"]) {
//                contact.clientName = version.clientName; 
//                contact.clientVersion = version.clientVersion;
//                [contact update];
//            }
//        }
//    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceiveClientVersionRequest:(XMPPIQ*)iq {
    [self writeToLog:client message:@"xmppClient:didReceiveClientVersionRequest"];
    NSString* fromJID = [[iq fromJID] full];
    if (![[client.myJID full] isEqualToString:fromJID]) {
        AccountModel* account = [XMPPMessageDelegate accountForXMPPClient:client];
        RosterItemModel* rosterItem = [RosterItemModel findByFullJid:fromJID andAccount:account];  
        if (rosterItem) {
            [XMPPClientVersionQuery result:client forIQ:iq];
        }
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceiveClientVersionError:(XMPPIQ*)iq {
    [self writeToLog:client message:@"xmppClient:didReceiveClientVersionError"];
}

//===================================================================================================================================
#pragma mark Applications

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient *)client didReceiveIQ:(XMPPIQ *)iq {
	[self writeToLog:client message:@"xmppClient:didReceiveIQ"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceiveMessage:(XMPPMessage*)message {
	[self writeToLog:client message:@"xmppClient:didReceiveMessage"];
    if ([message hasBody]) {
        AccountModel* account = [XMPPMessageDelegate accountForXMPPClient:client];
        if (account) {
            XMPPJID* fromJid = [XMPPJID jidWithString:[[message fromJID] full]];
            MessageModel* messageModel = [[MessageModel alloc] init];
            messageModel.fromJid = [fromJid full];
            messageModel.accountPk = account.pk;
            messageModel.messageText = [message body];
            messageModel.toJid = [account fullJID];
            messageModel.createdAt = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
            messageModel.textType = MessageTextTypeBody;
            messageModel.node = @"nonode";
            [messageModel insert];
            [messageModel release];
        }
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceiveCommandResult:(XMPPIQ*)iq {
	[self writeToLog:client message:@"xmppClient:didReceiveCommandResult"];
    XMPPCommand* command = [iq command];
    if (command) {
        XMPPxData* cmdData = [command data];
        if (cmdData) {
            AccountModel* account = [XMPPMessageDelegate accountForXMPPClient:client];
            if (account) {
                XMPPJID* fromJid = [XMPPJID jidWithString:[[iq fromJID] full]];
                MessageModel* messageModel = [[MessageModel alloc] init];
                messageModel.fromJid = [fromJid full];
                messageModel.accountPk = account.pk;
                messageModel.messageText = [cmdData XMLString];
                messageModel.toJid = [account fullJID];
                messageModel.createdAt = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
                messageModel.textType = MessageTextTypeCommandResponse;
                messageModel.node = [command node];
                [messageModel insert];
                [messageModel release];
            }
        }
    }
}

//===================================================================================================================================
#pragma mark Disco

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceiveDiscoItemsResult:(XMPPIQ*)iq {
	[self writeToLog:client message:@"xmppClient:didReceiveDiscoItemsResult"];
//    XMPPDiscoItemsQuery* query = (XMPPDiscoItemsQuery*)[iq query];
//	NSString* node = [query node];
//    NSArray* items = [query items];	
//	XMPPJID* serviceJID = [iq fromJID];
//    for(int i = 0; i < [items count]; i++) {
//        XMPPDiscoItem* item = [XMPPDiscoItem createFromElement:(NSXMLElement *)[items objectAtIndex:i]];
//        if ([item node] == nil) { 
//            [XMPPDiscoInfoQuery get:client JID:[item JID] andNode:[item node]];
//            [self save:client serviceItem:item forService:serviceJID andParentNode:nil];
//        } else if ([node isEqualToString:[XMPPMessageDelegate userPubSubRoot:client]]) {
//            [[client multicastDelegate] xmppClient:client didDiscoverUserPubSubNode:item forService:serviceJID andParentNode:node];
//        } else if ([node isEqualToString:@"http://jabber.org/protocol/commands"]) {
//            [self save:client serviceItem:item forService:serviceJID andParentNode:node];
//        }
//    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceiveDiscoItemsError:(XMPPIQ*)iq {
	[self writeToLog:client message:@"xmppClient:didReceiveDiscoItemsError"];
//    XMPPDiscoItemsQuery* query = (XMPPDiscoItemsQuery*)[iq query];
//	NSString* node = [query node];
//    XMPPError* error = [iq error];	
//    if (error) {
//        if ([node isEqualToString:[XMPPMessageDelegate userPubSubRoot:client]] && [[error condition] isEqualToString:@"item-not-found"]) {
//            [[client multicastDelegate] xmppClient:client didFailToDiscoverUserPubSubNode:iq];        
//        }
//    }    
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceiveDiscoInfoResult:(XMPPIQ*)iq {
	[self writeToLog:client message:@"xmppClient:didReceiveDiscoInfoResult"];
//    XMPPDiscoInfoQuery* query = (XMPPDiscoInfoQuery*)[iq query];
//    NSArray* identities = [query identities];	
//	NSString* node = [query node];
//	XMPPJID* serviceJID = [iq fromJID];
//    for(int i = 0; i < [identities count]; i++) {
//        XMPPDiscoIdentity* identity = [XMPPDiscoIdentity createFromElement:(NSXMLElement *)[identities objectAtIndex:i]];
//        if (node == nil) {
//            [self save:client service:identity forService:[iq fromJID]];
//        }
//        if ([[identity category] isEqualToString:@"pubsub"] && [[identity type] isEqualToString:@"service"]) {
//            [[client multicastDelegate] xmppClient:client didDiscoverPubSubService:iq];
//        }
//    }
//    NSArray* features = [query features];		
//    for(int i = 0; i < [features count]; i++) {
//        XMPPDiscoFeature* feature = [XMPPDiscoFeature createFromElement:(NSXMLElement *)[features objectAtIndex:i]];
//        [self save:client serviceFeature:feature forService:serviceJID andParentNode:node];
//    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceiveDiscoInfoError:(XMPPIQ*)iq {
	[self writeToLog:client message:@"xmppClient:didReceiveDiscoInfoError"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
//- (void)xmppClient:(XMPPClient*)client didDiscoverPubSubService:(XMPPIQ*)iq {
//	[self writeToLog:client message:@"xmppClient:didDiscoverPubSubService"];
//    [XMPPPubSubSubscriptions get:client JID:[iq fromJID]];
//    NSString* jid = [[iq fromJID] full];
//    ServiceItemModel* item = [ServiceItemModel findByJID:[[iq fromJID] full]];
//    [XMPPDiscoItemsQuery get:client JID:[iq fromJID] andNode:[XMPPMessageDelegate userPubSubRoot:client]];
//}

//-----------------------------------------------------------------------------------------------------------------------------------
//- (void)xmppClient:(XMPPClient*)client didDiscoverUserPubSubRoot:(XMPPIQ*)iq {
//	[self writeToLog:client message:@"xmppClient:didDiscoverUserPubSubRoot"];
//}
//
//-----------------------------------------------------------------------------------------------------------------------------------
//- (void)xmppClient:(XMPPClient*)client didDiscoverUserPubSubNode:(XMPPDiscoItem*)item forService:(XMPPJID*)serviceJID andParentNode:(NSString*)node {
//	[self writeToLog:client message:@"xmppClient:didDiscoverUserPubSubNode"];
//    [self save:client serviceItem:item forService:serviceJID andParentNode:node];
//}

//-----------------------------------------------------------------------------------------------------------------------------------
//- (void)xmppClient:(XMPPClient*)client didFailToDiscoverUserPubSubNode:(XMPPIQ*)iq {
//	[self writeToLog:client message:@"xmppClient:didFailToDiscoverUserPubSubNode"];
//}

//===================================================================================================================================
#pragma mark PubSub

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceiveSubscriptionsResult:(XMPPIQ*)iq {
	[self writeToLog:client message:@"xmppClient:didReceiveSubscriptionsResult"];
    XMPPPubSub* pubsub = [iq pubsub];
    NSArray* subscriptions = [pubsub subscriptions];	
    for(int i = 0; i < [subscriptions count]; i++) {
        XMPPPubSubSubscription* subscription = [XMPPPubSubSubscription createFromElement:(NSXMLElement *)[subscriptions objectAtIndex:i]];
        [self save:client subscription:subscription];
    }
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
#pragma mark XMPPMessageDelegate PrivateApi

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)writeToLog:(XMPPClient*)client message:(NSString*)message {
    if(DEBUG) {
        NSString* msg = [[NSString alloc] initWithFormat:@"XMPPMessageDelegate %@: JID %@", message, [client.myJID full]];
        NSLog(msg);
        [msg release];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
//- (void)save:(XMPPClient*)client service:(XMPPDiscoIdentity*)ident forService:(XMPPJID*)serviceJID {
//    if (![ServiceModel findByJID:[serviceJID full] type:[ident type] andCategory:[ident category]]) {
//        ServiceModel* service = [[ServiceModel alloc] init];
//        service.jid = [serviceJID full];
//        service.name = [ident iname];
//        service.category = [ident category];
//        service.type = [ident type];
//        [service insert];
//        [service release];
//    }
//}
//
//-----------------------------------------------------------------------------------------------------------------------------------
//- (void)save:(XMPPClient*)client serviceItem:(XMPPDiscoItem*)item forService:(XMPPJID*)serviceJID andParentNode:(NSString*)parent {
//    if (![ServiceItemModel findByJID:[[item JID] full] andNode:[item node]]) {
//        ServiceItemModel* serviceItem = [[ServiceItemModel alloc] init];
//        serviceItem.parentNode = parent;
//        serviceItem.itemName = [item iname];
//        serviceItem.jid = [[item JID] full];
//        serviceItem.service = [serviceJID full];
//        serviceItem.node = [item node];
//        [serviceItem insert];
//        [serviceItem release];
//    }
//}
//
//-----------------------------------------------------------------------------------------------------------------------------------
//- (void)save:(XMPPClient*)client serviceFeature:(XMPPDiscoFeature*)feature forService:(XMPPJID*)serviceJID andParentNode:(NSString*)parent {
//    if (![ServiceFeatureModel findByService:[serviceJID full] andVar:[feature var]]) {
//        ServiceFeatureModel* serviceFeature = [[ServiceFeatureModel alloc] init];
//        serviceFeature.parentNode = parent;
//        serviceFeature.var = [feature var];
//        serviceFeature.service = [serviceJID full];
//        [serviceFeature insert];
//        [serviceFeature release];
//    }
//}
//
//-----------------------------------------------------------------------------------------------------------------------------------
- (void)save:(XMPPClient*)client subscription:(XMPPPubSubSubscription*)sub {
    AccountModel* account = [XMPPMessageDelegate accountForXMPPClient:client];
    if (account) {
        SubscriptionModel* subModel = [[SubscriptionModel alloc] init];
        subModel.accountPk = account.pk;
        subModel.node = [sub node];
        subModel.subId = [sub subId];
        subModel.jid = [[sub JID] full];
        subModel.subscription = [sub subscription];
        [subModel insert];
        [subModel release];
    }
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
