//
//  XMPPMessageDelegate.h
//  webgnosus
//
//  Created by Troy Stribling on 8/11/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "NSXMLElementAdditions.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@class XMPPClient;
@class XMPPJID;
@class XMPPIQ;
@class XMPPMessage;
@class XMPPPresence;
@class XMPPClientVersionQuery;
@class XMPPRosterItem;
@class ActivityView;
@class AccountModel;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPMessageDelegate : NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
+ (AccountModel*)accountForXMPPClient:(XMPPClient*)client;

//-----------------------------------------------------------------------------------------------------------------------------------
// connection
+ (void)xmppClientConnecting:(XMPPClient*)sender;
+ (void)xmppClientDidConnect:(XMPPClient*)sender;
+ (void)xmppClientDidNotConnect:(XMPPClient*)sender;
+ (void)xmppClientDidDisconnect:(XMPPClient*)sender;

// registration
+ (void)xmppClientDidRegister:(XMPPClient*)sender;
+ (void)xmppClient:(XMPPClient*)sender didNotRegister:(NSXMLElement*)error;

// authentication
+ (void)xmppClientDidAuthenticate:(XMPPClient*)sender;
+ (void)xmppClient:(XMPPClient*)sender didNotAuthenticate:(NSXMLElement*)error;

// messaging
+ (void)xmppClient:(XMPPClient*)sender didReceiveIQ:(XMPPIQ*)iq;
+ (void)xmppClient:(XMPPClient*)sender didReceiveMessage:(XMPPMessage*)message;

// roster
+ (void)xmppClient:(XMPPClient*)sender didAddToRoster:(XMPPRosterItem*)item;
+ (void)xmppClient:(XMPPClient*)sender didRemoveFromRoster:(XMPPRosterItem*)item;
+ (void)xmppClient:(XMPPClient*)sender didFinishReceivingRosterItems:(XMPPIQ *)iq;
+ (void)xmppClient:(XMPPClient*)sender didReceivePresence:(XMPPPresence*)presence;
+ (void)xmppClient:(XMPPClient*)sender didReceiveErrorPresence:(XMPPPresence*)sender;
+ (void)xmppClient:(XMPPClient*)sender didReceiveBuddyRequest:(XMPPJID*)buddyJid;
+ (void)xmppClient:(XMPPClient*)sender didAcceptBuddyRequest:(XMPPJID*)buddyJid;
+ (void)xmppClient:(XMPPClient*)sender didRejectBuddyRequest:(XMPPJID*)buddyJid;
+ (void)xmppClient:(XMPPClient*)sender acceptBuddyRequest:(XMPPJID*)buddyJid;
+ (void)xmppClient:(XMPPClient*)sender rejectBuddyRequest:(XMPPJID*)buddyJid;

// service discovery
+ (void)xmppClient:(XMPPClient*)sender didReceiveClientVersionResult:(XMPPIQ*)iq;
+ (void)xmppClient:(XMPPClient*)sender didReceiveClientVersionRequest:(XMPPIQ*)iq;

// Commands
+ (void)xmppClient:(XMPPClient*)sender didReceiveCommandResult:(XMPPIQ*)iq;

@end
