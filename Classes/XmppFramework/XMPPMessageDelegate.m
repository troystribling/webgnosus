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
#import "XMPPRosterItem.h"
#import "XMPPCommand.h"
#import "XMPPxData.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPMessageDelegate (PrivateAPI)

+ (void)writeToLog:(XMPPClient*)sender message:(NSString*)message;
+ (void)removeContact:(XMPPClient*)sender withJid:(XMPPJID*)contactJid;
+ (void)addContact:(XMPPClient*)sender withJid:(XMPPJID*)contactJid;

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
+ (void)xmppClientConnecting:(XMPPClient *)sender {
	[self writeToLog:sender message:@"xmppClientConnecting"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)xmppClientDidConnect:(XMPPClient *)sender {
//    AccountModel* account = [self accountForXMPPClient:sender];
//    if (account) {
//    }
    [self writeToLog:sender message:@"xmppClientDidConnect"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)xmppClientDidNotConnect:(XMPPClient *)sender {
	[self writeToLog:sender message:@"xmppClientDidNotConnect"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)xmppClientDidDisconnect:(XMPPClient *)sender {
	[self writeToLog:sender message:@"xmppClientDidDisconnect"];
}

//===================================================================================================================================
#pragma mark registration

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)xmppClientDidRegister:(XMPPClient *)sender {
	[self writeToLog:sender message:@"xmppClientDidRegister at: %@"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)xmppClient:(XMPPClient*)sender didNotRegister:(NSXMLElement*)error {
	[self writeToLog:sender message:@"xmppClient:didNotRegister at: %@"];
}

//===================================================================================================================================
#pragma mark Authentication

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)xmppClientDidAuthenticate:(XMPPClient *)sender {
	[self writeToLog:sender message:@"xmppClientDidAuthenticate at: %@"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)xmppClient:(XMPPClient*)sender didNotAuthenticate:(NSXMLElement*)error {
	[self writeToLog:sender message:@"xmppClient:didNotAuthenticate at: %@"];
}

//===================================================================================================================================
#pragma mark Message

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)xmppClient:(XMPPClient*)sender didReceiveMessage:(XMPPMessage*)message {
//    if ([message hasBody]) {
//        AccountModel* account = [self accountForXMPPClient:sender];
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
	[self writeToLog:sender message:@"xmppClient:didReceiveMessage"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)xmppClient:(XMPPClient *)sender didReceiveIQ:(XMPPIQ *)iq {
	[self writeToLog:sender message:@"xmppClient:didReceiveIQ"];
}

//===================================================================================================================================
#pragma mark Roster

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)xmppClient:(XMPPClient*)sender didRemoveFromRoster:(XMPPRosterItem*)item {
//    [self removeContact:sender withJid:[item jid]];
	[self writeToLog:sender message:@"xmppClient:didRemoveFromRoster"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)xmppClient:(XMPPClient*)sender didAddToRoster:(XMPPRosterItem*)item {
//    [self addContact:sender withJid:[item jid]];
	[self writeToLog:sender message:@"xmppClientDidUpdateRoster"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)xmppClient:(XMPPClient*)sender didFinishReceivingRosterItems:(XMPPIQ *)iq {
	[self writeToLog:sender message:@"didFinishReceivingRosterItems"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)xmppClient:(XMPPClient*)sender didReceivePresence:(XMPPPresence*)presence {
//    AccountModel* account = [self accountForXMPPClient:sender];
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
//            [sender getClientVersionForJid:[presence fromJID]];
//        } 
//        ContactModel* contact = [ContactModel findByJid:[fromJid bare] andAccount:account];
//        RosterItemModel* maxPriorityRosteritem =[RosterItemModel findWithMaxPriorityByJid:[fromJid bare] andAccount:account];
//        contact.clientName = maxPriorityRosteritem.clientName;
//        contact.clientVersion = maxPriorityRosteritem.clientVersion;
//        [contact update];
//        [contact release];
//        [rosterItem release];
//    }
    [self writeToLog:sender message:@"xmppClient:didReceivePresence"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)xmppClient:(XMPPClient*)sender didReceiveErrorPresence:(XMPPPresence*)presence  {
//    AccountModel* account = [self accountForXMPPClient:sender];
//    ContactModel* contact = [ContactModel findByJid:[[presence fromJID] bare] andAccount:account];
//    contact.contactState = ContactHasError;
//    [contact update];
	[self writeToLog:sender message:@"xmppClient:didReceiveErrorPresence"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)xmppClient:(XMPPClient*)sender didReceiveBuddyRequest:(XMPPJID *)buddyJid {
	[self writeToLog:sender message:@"xmppClient:didReceiveBuddyRequest"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)xmppClient:(XMPPClient*)sender didAcceptBuddyRequest:(XMPPJID*)buddyJid {
//    [self addContact:sender withJid:buddyJid];
	[self writeToLog:sender message:@"xmppClient:didAcceptBuddyRequest"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)xmppClient:(XMPPClient*)sender didRejectBuddyRequest:(XMPPJID*)buddyJid {
    [self writeToLog:sender message:@"xmppClient:didRejectBuddyRequest"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)xmppClient:(XMPPClient*)sender acceptBuddyRequest:(XMPPJID*)buddyJid {
//    [self addContact:sender withJid:buddyJid];
//    AccountModel* account = [self accountForXMPPClient:sender];
//    if (account) {
//        [sender acceptBuddyRequest:buddyJid];
//    }
	[self writeToLog:sender message:@"xmppClient:acceptBuddyRequest"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)xmppClient:(XMPPClient*)sender rejectBuddyRequest:(XMPPJID*)buddyJid {
//    [sender rejectBuddyRequest:buddyJid];
	[self writeToLog:sender message:@"xmppClient:rejectBuddyRequest"];
}

//===================================================================================================================================
#pragma mark Service Discovery

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)xmppClient:(XMPPClient*)sender didReceiveClientVersionResult:(XMPPIQ*)iq {
//    XMPPClientVersionQuery* version = (XMPPClientVersionQuery*)[iq query];
//    AccountModel* account = [self accountForXMPPClient:sender];
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
//            [self writeToLog:sender message:@"xmppClient:didReceiveClientVersionResult"];
//        }
//    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)xmppClient:(XMPPClient*)sender didReceiveClientVersionRequest:(XMPPIQ*)iq {
//    if (![[sender.myJID full] isEqualToString:[[iq fromJID] full]]) {
//        [sender sendClientVersion:[[XMPPClientVersionQuery alloc] initWithName:@"web.gnos.us" andVersion:@"0.0"] forIQ:iq];
//    }
	[self writeToLog:sender message:@"xmppClient:didReceiveClientVersion"];
}

//===================================================================================================================================
#pragma mark Commands
//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)xmppClient:(XMPPClient*)sender didReceiveCommandResult:(XMPPIQ*)iq {
//    XMPPCommand* command = [iq command];
//    if (command) {
//        XMPPxData* cmdData = [command data];
//        if (cmdData) {
//            AccountModel* account = [self accountForXMPPClient:sender];
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
	[self writeToLog:sender message:@"xmppClient:didReceiveCommandResult"];
}

//===================================================================================================================================
#pragma mark XMPPMessageDelegate PrivateApi

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)writeToLog:(XMPPClient*)sender message:(NSString*)message {
	NSString* msg = [[NSString alloc] initWithFormat:@"XMPPMessageDelegate %@; JID %@", message, [sender.myJID full]];
	NSLog(msg);
    [msg release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)removeContact:(XMPPClient*)sender withJid:(XMPPJID*)contactJid {
    AccountModel* account = [self accountForXMPPClient:sender];
    if (account) {
        ContactModel* contact = [ContactModel findByJid:[contactJid bare] andAccount:account];	
        if (contact) {
            [contact destroy];
        }
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)addContact:(XMPPClient*)sender withJid:(XMPPJID*)contactJid {
    AccountModel* account = [self accountForXMPPClient:sender];
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

@end
