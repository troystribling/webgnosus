//
//  ModelUpdateDelgate.m
//  webgnosus
//
//  Created by Troy Stribling on 1/24/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "ModelUpdateDelgate.h"
#import "RosterItemModel.h"
#import "ContactModel.h"
#import "MessageModel.h"
#import "ActivityView.h"

#import "XMPPClient.h"
#import "XMPPJID.h"
#import "XMPPPresence.h"
#import "XMPPIQ.h"
#import "XMPPMessage.h"
#import "XMPPClientVersionQuery.h"
#import "XMPPRosterItem.h"
#import "XMPPCommand.h"
#import "XMPPxData.h"

//-----------------------------------------------------------------------------------------------------------------------------------
static ActivityView* ConnectingIndicatorView = nil;
static BOOL DismissConnectionIndicatorOnStart = YES;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ModelUpdateDelgate (PrivateAPI)

+ (void)writeToLog:(XMPPClient*)sender message:(NSString*)message;
+ (void)removeContact:(XMPPClient*)sender withJid:(XMPPJID*)contactJid;
+ (void)addContact:(XMPPClient*)sender withJid:(XMPPJID*)contactJid;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ModelUpdateDelgate

//===================================================================================================================================
#pragma mark ModelUpdateDelgate

//-----------------------------------------------------------------------------------------------------------------------------------
+ (AccountModel*)accountForXMPPClient:(XMPPClient*)client {
    return [AccountModel findByFullJid:[client.myJID full]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)dismissConnectionIndicator { 
    if (ConnectingIndicatorView) {
        [ConnectingIndicatorView dismiss]; 
        [ConnectingIndicatorView release];
        ConnectingIndicatorView = nil;
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (ActivityView*)connectingIndicator { 
    return ConnectingIndicatorView;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)showConnectingIndicatorInView:(UIView*)view {
    if (!ConnectingIndicatorView) {
        ConnectingIndicatorView = [[ActivityView alloc] initWithTitle:@"Connecting" inView:view];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)onStartshowConnectingIndicatorInView:(UIView*)view {
    if ([AccountModel activateCount] == 0) {
        DismissConnectionIndicatorOnStart = NO;
    }
    if (DismissConnectionIndicatorOnStart) {
        [self showConnectingIndicatorInView:view];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)onStartDismissConnectionIndicatorAndShowErrors {
    if (DismissConnectionIndicatorOnStart) {
        if ([AccountModel triedToConnectAll]) {
            [ModelUpdateDelgate dismissConnectionIndicator]; 
            [self showAlertsForConnectionState:AccountConnectionError titled:@"Connection Failed"];
            [self showAlertsForConnectionState:AccountAuthenticationError titled:@"Authentication Failed"];
            DismissConnectionIndicatorOnStart = NO;
        }
    } 
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)showAlertsForConnectionState:(AccountConnectionState)state titled:(NSString*)title {
    NSMutableArray* accounts = [AccountModel findAllActivatedByConnectionState:state];
    for (int i = 0; i < [accounts count]; i++) {
        AccountModel* account = [accounts objectAtIndex:i];
        [self showAlert:title withMessage:[[NSString alloc] initWithFormat:@"%@", [account fullJID]]];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)showAlert:(NSString*)title {
    [self showAlert:title withMessage:@""];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)showAlert:(NSString*)title withMessage:(NSString*)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];	
    [alert release];
}

//===================================================================================================================================
#pragma mark Connection
//
////-----------------------------------------------------------------------------------------------------------------------------------
//+ (void)xmppClientConnecting:(XMPPClient *)sender {
//	[ModelUpdateDelgate writeToLog:sender message:@"xmppClientConnecting to: %@"];
//}
//
////-----------------------------------------------------------------------------------------------------------------------------------
//+ (void)xmppClientDidConnect:(XMPPClient *)sender {
//    AccountModel* account = [self accountForXMPPClient:sender];
//    if (account) {
//    }
//    [ModelUpdateDelgate writeToLog:sender message:@"xmppClientDidConnect to: %@"];
//}
//
////-----------------------------------------------------------------------------------------------------------------------------------
//+ (void)xmppClientDidNotConnect:(XMPPClient *)sender {
//	[ModelUpdateDelgate writeToLog:sender message:@"xmppClientDidNotConnect to: %@"];
//}
//
////-----------------------------------------------------------------------------------------------------------------------------------
//+ (void)xmppClientDidDisconnect:(XMPPClient *)sender {
//	[ModelUpdateDelgate writeToLog:sender message:@"xmppClientDidDisconnect from: %@"];
//}
//
//===================================================================================================================================
#pragma mark registration

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)xmppClientDidRegister:(XMPPClient *)sender {
	[ModelUpdateDelgate writeToLog:sender message:@"xmppClientDidRegister at: %@"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)xmppClient:(XMPPClient*)sender didNotRegister:(NSXMLElement*)error {
	[ModelUpdateDelgate writeToLog:sender message:@"xmppClient:didNotRegister at: %@"];
}

//===================================================================================================================================
#pragma mark Authentication

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)xmppClientDidAuthenticate:(XMPPClient *)sender {
	[ModelUpdateDelgate writeToLog:sender message:@"xmppClientDidAuthenticate at: %@"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)xmppClient:(XMPPClient*)sender didNotAuthenticate:(NSXMLElement*)error {
	[ModelUpdateDelgate writeToLog:sender message:@"xmppClient:didNotAuthenticate at: %@"];
}

//===================================================================================================================================
#pragma mark Message

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)xmppClient:(XMPPClient*)sender didReceiveMessage:(XMPPMessage*)message {
    if ([message hasBody]) {
        AccountModel* account = [self accountForXMPPClient:sender];
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
	[ModelUpdateDelgate writeToLog:sender message:@"xmppClient:didReceiveMessage from: %@"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)xmppClient:(XMPPClient *)sender didReceiveIQ:(XMPPIQ *)iq {
	[ModelUpdateDelgate writeToLog:sender message:@"xmppClient:didReceiveIQ from: %@"];
}

//===================================================================================================================================
#pragma mark Roster

//-----------------------------------------------------------------------------------------------------------------------------------
//+ (void)xmppClient:(XMPPClient*)sender didRemoveFromRoster:(XMPPRosterItem*)item {
//    [self removeContact:sender withJid:[item jid]];
//	[ModelUpdateDelgate writeToLog:sender message:@"xmppClient:didRemoveFromRoster from: %@"];
//}
//
//-----------------------------------------------------------------------------------------------------------------------------------
//+ (void)xmppClient:(XMPPClient*)sender didAddToRoster:(XMPPRosterItem*)item {
//    [self addContact:sender withJid:[item jid]];
//	[ModelUpdateDelgate writeToLog:sender message:@"xmppClientDidUpdateRoster from: %@"];
//}
//
//-----------------------------------------------------------------------------------------------------------------------------------
//+ (void)xmppClient:(XMPPClient*)sender didFinishReceivingRosterItems:(XMPPIQ *)iq {
//	[ModelUpdateDelgate writeToLog:sender message:@"didFinishReceivingRosterItems from: %@"];
//}
//
//-----------------------------------------------------------------------------------------------------------------------------------
//+ (void)xmppClient:(XMPPClient*)sender didReceivePresence:(XMPPPresence*)presence {
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
//    [ModelUpdateDelgate writeToLog:sender message:@"xmppClient:didReceivePresence from: %@"];
//}
//
//-----------------------------------------------------------------------------------------------------------------------------------
//+ (void)xmppClient:(XMPPClient*)sender didReceiveErrorPresence:(XMPPPresence*)presence  {
//    AccountModel* account = [self accountForXMPPClient:sender];
//    ContactModel* contact = [ContactModel findByJid:[[presence fromJID] bare] andAccount:account];
//    contact.contactState = ContactHasError;
//    [contact update];
//	[ModelUpdateDelgate writeToLog:sender message:@"xmppClient:didReceiveErrorPresence from: %@"];
//}
//
//-----------------------------------------------------------------------------------------------------------------------------------
//+ (void)xmppClient:(XMPPClient*)sender didReceiveBuddyRequest:(XMPPJID *)buddyJid {
//	[ModelUpdateDelgate writeToLog:sender message:@"xmppClient:didReceiveBuddyRequest from: %@"];
//}
//
//-----------------------------------------------------------------------------------------------------------------------------------
//+ (void)xmppClient:(XMPPClient*)sender didAcceptBuddyRequest:(XMPPJID*)buddyJid {
//    [self addContact:sender withJid:buddyJid];
//	[ModelUpdateDelgate writeToLog:sender message:@"xmppClient:didAcceptBuddyRequest from: %@"];
//}
//
//-----------------------------------------------------------------------------------------------------------------------------------
//+ (void)xmppClient:(XMPPClient*)sender didRejectBuddyRequest:(XMPPJID*)buddyJid {
//    [ModelUpdateDelgate writeToLog:sender message:@"xmppClient:didRejectBuddyRequest from: %@"];
//}
//
////-----------------------------------------------------------------------------------------------------------------------------------
//+ (void)xmppClient:(XMPPClient*)sender acceptBuddyRequest:(XMPPJID*)buddyJid {
//    [self addContact:sender withJid:buddyJid];
//    AccountModel* account = [self accountForXMPPClient:sender];
//    if (account) {
//        [sender acceptBuddyRequest:buddyJid];
//    }
//	[ModelUpdateDelgate writeToLog:sender message:@"xmppClient:acceptBuddyRequest from: %@"];
//}
//
////-----------------------------------------------------------------------------------------------------------------------------------
//+ (void)xmppClient:(XMPPClient*)sender rejectBuddyRequest:(XMPPJID*)buddyJid {
//    [sender rejectBuddyRequest:buddyJid];
//	[ModelUpdateDelgate writeToLog:sender message:@"xmppClient:rejectBuddyRequest from: %@"];
//}
//
//===================================================================================================================================
#pragma mark Service Discovery

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)xmppClient:(XMPPClient*)sender didReceiveClientVersionResult:(XMPPIQ*)iq {
    XMPPClientVersionQuery* version = (XMPPClientVersionQuery*)[iq query];
    AccountModel* account = [self accountForXMPPClient:sender];
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
            [ModelUpdateDelgate writeToLog:sender message:@"xmppClient:didReceiveClientVersionResult from: %@"];
        }
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)xmppClient:(XMPPClient*)sender didReceiveClientVersionRequest:(XMPPIQ*)iq {
    if (![[sender.myJID full] isEqualToString:[[iq fromJID] full]]) {
        [sender sendClientVersion:[[XMPPClientVersionQuery alloc] initWithName:@"web.gnos.us" andVersion:@"0.0"] forIQ:iq];
    }
	[ModelUpdateDelgate writeToLog:sender message:@"xmppClient:didReceiveClientVersion from: %@"];
}

//===================================================================================================================================
#pragma mark Commands
//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)xmppClient:(XMPPClient*)sender didReceiveCommandResult:(XMPPIQ*)iq {
    XMPPCommand* command = [iq command];
    if (command) {
        XMPPxData* cmdData = [command data];
        if (cmdData) {
            AccountModel* account = [self accountForXMPPClient:sender];
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
	[ModelUpdateDelgate writeToLog:sender message:@"xmppClient:didReceiveCommandResult from: %@"];
}

//===================================================================================================================================
#pragma mark ModelUpdateDelgate PrivateApi

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)writeToLog:(XMPPClient*)sender message:(NSString*)message {
	NSString* msg = [[NSString alloc] initWithFormat:message, [sender.myJID full]];
	NSLog(msg);
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
