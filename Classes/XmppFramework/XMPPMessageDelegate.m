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

#import "XMPPClient.h"
#import "XMPPJID.h"
#import "XMPPPresence.h"
#import "XMPPIQ.h"
#import "XMPPMessage.h"
#import "XMPPClientVersionQuery.h"
#import "XMPPRosterQuery.h"
#import "XMPPRosterItem.h"
#import "XMPPCommand.h"
#import "XMPPxData.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPMessageDelegate (PrivateAPI)

- (void)writeToLog:(XMPPClient*)client message:(NSString*)message;
- (void)removeContact:(XMPPClient*)client withJid:(XMPPJID*)contactJid;
- (void)addContact:(XMPPClient*)client withJid:(XMPPJID*)contactJid;
- (void)updateAccountConnectionState:(AccountConnectionState)title forClient:(XMPPClient*)client;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPMessageDelegate

//===================================================================================================================================
#pragma mark XMPPMessageDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
+ (AccountModel*)accountForXMPPClient:(XMPPClient*)client {
    return [AccountModel findByFullJid:[client.myJID full]];
}

//===================================================================================================================================
#pragma mark Connection

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClientConnecting:(XMPPClient *)client {
	[self writeToLog:client message:@"xmppClientConnecting"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClientDidConnect:(XMPPClient *)client {
    AccountModel* account = [XMPPMessageDelegate accountForXMPPClient:client];
    if (account) {
    }
    [self writeToLog:client message:@"xmppClientDidConnect"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClientDidNotConnect:(XMPPClient *)client {
	[self writeToLog:client message:@"xmppClientDidNotConnect"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClientDidDisconnect:(XMPPClient *)client {
	[self writeToLog:client message:@"xmppClientDidDisconnect"];
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
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didNotAuthenticate:(NSXMLElement*)error {
	[self writeToLog:client message:@"xmppClient:didNotAuthenticate"];
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
    [self addContact:client withJid:[item jid]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didRemoveFromRoster:(XMPPRosterItem*)item {
	[self writeToLog:client message:@"xmppClient:didRemoveFromRoster"];
    [self removeContact:client withJid:[item jid]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didFinishReceivingRosterItems:(XMPPIQ *)iq {
	[self writeToLog:client message:@"didFinishReceivingRosterItems"];
    [self updateAccountConnectionState:AccountRosterUpdated forClient:client];
}

//===================================================================================================================================
#pragma mark Presence

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceivePresence:(XMPPPresence*)presence {
//    AccountModel* account = [XMPPMessageDelegate accountForXMPPClient:client];
//    if (account) {
//        XMPPJID* fromJid = [presence fromJID];
//        NSString* fromResource = [fromJid resource];
//        RosterItemModel* rosterItem = [RosterItemModel findByFullJid:[fromJid full] andAccount:account];    
//        if (!rosterItem) {
//            rosterItem = [[RosterItemModel alloc] init]; 
//            rosterItem.jid = [fromJid bare];
//            rosterItem.resource = fromResource;
//            rosterItem.host = [fromJid domain];
//            rosterItem.accountPk = account.pk;
//            rosterItem.clientName = @"";
//            rosterItem.clientVersion = @"";
//            [rosterItem insert];
//            [rosterItem load];
//        }
//        NSString* showVal = [presence show];
//        if (showVal) {
//            rosterItem.show = showVal;
//        } else {
//            rosterItem.show = @"";
//        }
//        NSString* statusVal = [presence status];
//        if (statusVal) {
//            rosterItem.status = statusVal;
//        } else {
//            rosterItem.status = @"";
//        }
//        rosterItem.priority = [presence priority];
//        rosterItem.type = [presence type];
//        [rosterItem update];
//        if ([rosterItem.type isEqualToString:@"available"]) {
//            [client getClientVersionForJid:[presence fromJID]];
//        } 
//        ContactModel* contact = [ContactModel findByJid:[fromJid bare] andAccount:account];
//        RosterItemModel* maxPriorityRosteritem =[RosterItemModel findWithMaxPriorityByJid:[fromJid bare] andAccount:account];
//        contact.clientName = maxPriorityRosteritem.clientName;
//        contact.clientVersion = maxPriorityRosteritem.clientVersion;
//        [contact update];
//        [contact release];
//        [rosterItem release];
//    }
    [self writeToLog:client message:@"xmppClient:didReceivePresence"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceiveErrorPresence:(XMPPPresence*)presence  {
//    AccountModel* account = [XMPPMessageDelegate accountForXMPPClient:client];
//    ContactModel* contact = [ContactModel findByJid:[[presence fromJID] bare] andAccount:account];
//    contact.contactState = ContactHasError;
//    [contact update];
	[self writeToLog:client message:@"xmppClient:didReceiveErrorPresence"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceiveBuddyRequest:(XMPPJID *)buddyJid {
	[self writeToLog:client message:@"xmppClient:didReceiveBuddyRequest"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didAcceptBuddyRequest:(XMPPJID*)buddyJid {
//    [self addContact:client withJid:buddyJid];
	[self writeToLog:client message:@"xmppClient:didAcceptBuddyRequest"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didRejectBuddyRequest:(XMPPJID*)buddyJid {
    [self writeToLog:client message:@"xmppClient:didRejectBuddyRequest"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client acceptBuddyRequest:(XMPPJID*)buddyJid {
//    [self addContact:client withJid:buddyJid];
//    AccountModel* account = [XMPPMessageDelegate accountForXMPPClient:client];
//    if (account) {
//        [client acceptBuddyRequest:buddyJid];
//    }
	[self writeToLog:client message:@"xmppClient:acceptBuddyRequest"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client rejectBuddyRequest:(XMPPJID*)buddyJid {
//    [client rejectBuddyRequest:buddyJid];
	[self writeToLog:client message:@"xmppClient:rejectBuddyRequest"];
}

//===================================================================================================================================
#pragma mark Version Discovery

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceiveClientVersionResult:(XMPPIQ*)iq {
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
            [self writeToLog:client message:@"xmppClient:didReceiveClientVersionResult"];
//        }
//    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceiveClientVersionRequest:(XMPPIQ*)iq {
//    if (![[client.myJID full] isEqualToString:[[iq fromJID] full]]) {
//        [client sendClientVersion:[[XMPPClientVersionQuery alloc] initWithName:@"web.gnos.us" andVersion:@"0.0"] forIQ:iq];
//    }
	[self writeToLog:client message:@"xmppClient:didReceiveClientVersionRequest"];
}

//===================================================================================================================================
#pragma mark Applications

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient *)client didReceiveIQ:(XMPPIQ *)iq {
	[self writeToLog:client message:@"xmppClient:didReceiveIQ"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceiveMessage:(XMPPMessage*)message {
    //    if ([message hasBody]) {
    //        AccountModel* account = [XMPPMessageDelegate accountForXMPPClient:client];
    //        if (account) {
    //            XMPPJID* fromJid = [XMPPJID jidWithString:[[message fromJID] full]];
    //            MessageModel* messageModel = [[MessageModel alloc] init];
    //            messageModel.fromJid = [fromJid full];
    //            messageModel.accountPk = account.pk;
    //            messageModel.messageText = [message body];
    //            messageModel.toJid = [account fullJID];
    //            messageModel.createdAt = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    //            messageModel.textType = MessageTextTypeBody;
    //            messageModel.node = @"nonode";
    //            [messageModel insert];
    //            [messageModel release];
    //        }
    //    }
	[self writeToLog:client message:@"xmppClient:didReceiveMessage"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceiveCommandResult:(XMPPIQ*)iq {
//    XMPPCommand* command = [iq command];
//    if (command) {
//        XMPPxData* cmdData = [command data];
//        if (cmdData) {
//            AccountModel* account = [XMPPMessageDelegate accountForXMPPClient:client];
//            if (account) {
//                XMPPJID* fromJid = [XMPPJID jidWithString:[[iq fromJID] full]];
//                MessageModel* messageModel = [[MessageModel alloc] init];
//                messageModel.fromJid = [fromJid full];
//                messageModel.accountPk = account.pk;
//                messageModel.messageText = [cmdData XMLString];
//                messageModel.toJid = [account fullJID];
//                messageModel.createdAt = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
//                messageModel.textType = MessageTextTypeCommandResponse;
//                messageModel.node = [command node];
//                [messageModel insert];
//                [messageModel release];
//            }
//        }
//    }
	[self writeToLog:client message:@"xmppClient:didReceiveCommandResult"];
}

//===================================================================================================================================
#pragma mark XMPPMessageDelegate PrivateApi

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)writeToLog:(XMPPClient*)client message:(NSString*)message {
	NSString* msg = [[NSString alloc] initWithFormat:@"XMPPMessageDelegate %@: JID %@", message, [client.myJID full]];
	NSLog(msg);
    [msg release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)removeContact:(XMPPClient*)client withJid:(XMPPJID*)contactJid {
    AccountModel* account = [XMPPMessageDelegate accountForXMPPClient:client];
    if (account) {
        ContactModel* contact = [ContactModel findByJid:[contactJid bare] andAccount:account];	
        if (contact) {
            [contact destroy];
        }
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addContact:(XMPPClient*)client withJid:(XMPPJID*)contactJid {
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
- (void)updateAccountConnectionState:(AccountConnectionState)state forClient:(XMPPClient*)client { 
    AccountModel* account = [XMPPMessageDelegate accountForXMPPClient:client];
    account.connectionState = state;
    [account update];
}

@end
