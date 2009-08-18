//
//  XMPPClient.m
//  webgnosus
//
//  Created by Troy Stribling on 3/29/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "DDXML.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@class XMPPStream;
@class XMPPJID;
@class XMPPIQ;
@class XMPPMessage;
@class XMPPPresence;
@class XMPPRosterItem;
@class XMPPClientVersionQuery;
@class MulticastDelegate;
@class SCNotificationManager;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPClient : NSObject {
	MulticastDelegate* multicastDelegate;	
	NSString* domain;
	XMPPJID* myJID;
	NSString *password;
	XMPPStream* xmppStream;
	SCNotificationManager *scNotificationManager;
    
	UInt16 port;	
	int priority;
    
   	NSError* streamError;	 
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) MulticastDelegate* multicastDelegate;
@property (nonatomic, retain) NSString* domain;
@property (nonatomic, retain) XMPPJID* myJID;
@property (nonatomic, retain) NSString* password;
@property (nonatomic, retain) XMPPStream* xmppStream;
@property (nonatomic, retain) SCNotificationManager* scNotificationManager;
@property (nonatomic, assign) UInt16 port;
@property (nonatomic, assign) int priority;

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)init;

// delegation
- (void)addDelegate:(id)delegate;
- (void)removeDelegate:(id)delegate;
- (void)removeAllDelgates;

// security
- (BOOL)allowsSelfSignedCertificates;
- (void)setAllowsSelfSignedCertificates:(BOOL)flag;
- (BOOL)supportsInBandRegistration;
- (BOOL)supportsPlainAuthentication;
- (BOOL)supportsDigestMD5Authentication;
- (void)authenticateUser;
- (void)registerUser;
- (BOOL)isSecure;
- (BOOL)isAuthenticated;

// connection
- (BOOL)isDisconnected;
- (BOOL)isConnected;
- (void)connect;
- (void)disconnect;
- (NSError*)streamError;

// status
- (void)goOnline;
- (void)goOffline;

// roster
- (void)fetchRoster;
- (void)addBuddy:(XMPPJID *)jid;
- (void)removeBuddy:(XMPPJID *)jid;
- (void)acceptBuddyRequest:(XMPPJID *)jid;
- (void)rejectBuddyRequest:(XMPPJID *)jid;

// send elements
- (void)sendElement:(NSXMLElement *)element;
- (void)sendElement:(NSXMLElement *)element andNotifyMe:(long)tag;
- (void)sendMessage:(NSString*)body toJID:(XMPPJID *)jid;

// commands
- (void)sendCommand:(NSString*)method toJID:(XMPPJID*)jid;
- (void)sendCommand:(NSString*)method withParameter:(NSMutableDictionary*)parameters toJID:(XMPPJID*)jid;

@end

//-----------------------------------------------------------------------------------------------------------------------------------
#pragma mark -
//-----------------------------------------------------------------------------------------------------------------------------------

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface NSObject (XMPPClientDelegate)

// connection
- (void)xmppClientConnecting:(XMPPClient*)sender;
- (void)xmppClientDidConnect:(XMPPClient*)sender;
- (void)xmppClientDidNotConnect:(XMPPClient*)sender;
- (void)xmppClientDidDisconnect:(XMPPClient*)sender;

// registration
- (void)xmppClientDidRegister:(XMPPClient*)sender;
- (void)xmppClient:(XMPPClient*)sender didNotRegister:(NSXMLElement*)error;

// authentication
- (void)xmppClientDidAuthenticate:(XMPPClient*)sender;
- (void)xmppClient:(XMPPClient*)sender didNotAuthenticate:(NSXMLElement*)error;

// roster
- (void)xmppClient:(XMPPClient*)client didReceiveRosterItems:(XMPPIQ*)iq;
- (void)xmppClient:(XMPPClient*)sender didAddToRoster:(XMPPRosterItem*)item;
- (void)xmppClient:(XMPPClient*)sender didRemoveFromRoster:(XMPPRosterItem*)item;
- (void)xmppClient:(XMPPClient*)sender didFinishReceivingRosterItems:(XMPPIQ *)iq;

// presence
- (void)xmppClient:(XMPPClient*)sender didReceivePresence:(XMPPPresence*)sender;
- (void)xmppClient:(XMPPClient*)sender didReceiveErrorPresence:(XMPPPresence*)sender;
- (void)xmppClient:(XMPPClient*)sender didReceiveBuddyRequest:(XMPPJID*)buddyJid;
- (void)xmppClient:(XMPPClient*)sender didAcceptBuddyRequest:(XMPPJID*)buddyJid;
- (void)xmppClient:(XMPPClient*)sender didRejectBuddyRequest:(XMPPJID*)buddyJid;

// version discovery
- (void)xmppClient:(XMPPClient*)sender didReceiveClientVersionResult:(XMPPIQ*)iq;
- (void)xmppClient:(XMPPClient*)sender didReceiveClientVersionRequest:(XMPPIQ*)iq;

// applications
- (void)xmppClient:(XMPPClient*)sender didReceiveIQ:(XMPPIQ*)iq;
- (void)xmppClient:(XMPPClient*)sender didReceiveMessage:(XMPPMessage*)message;
- (void)xmppClient:(XMPPClient*)sender didReceiveCommandResult:(XMPPIQ*)iq;

@end
