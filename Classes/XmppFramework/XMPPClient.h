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
- (BOOL)isSecure;
- (BOOL)isAuthenticated;

// connection
- (BOOL)isDisconnected;
- (BOOL)isConnected;
- (void)connect;
- (void)disconnect;
- (NSError*)streamError;

// send elements
- (void)sendElement:(NSXMLElement *)element;
- (void)sendElement:(NSXMLElement *)element andNotifyMe:(long)tag;

@end

//-----------------------------------------------------------------------------------------------------------------------------------
#pragma mark -
//-----------------------------------------------------------------------------------------------------------------------------------

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface NSObject (XMPPClientDelegate)

// connection
- (void)xmppClientConnecting:(XMPPClient*)client;
- (void)xmppClientDidConnect:(XMPPClient*)client;
- (void)xmppClientDidNotConnect:(XMPPClient*)client;
- (void)xmppClientDidDisconnect:(XMPPClient*)client;

// registration
- (void)xmppClientDidRegister:(XMPPClient*)client;
- (void)xmppClient:(XMPPClient*)client didNotRegister:(NSXMLElement*)error;

// authentication
- (void)xmppClientDidAuthenticate:(XMPPClient*)client;
- (void)xmppClient:(XMPPClient*)client didNotAuthenticate:(NSXMLElement*)error;

// roster
- (void)xmppClient:(XMPPClient*)client didReceiveRosterItems:(XMPPIQ*)iq;
- (void)xmppClient:(XMPPClient*)client didAddToRoster:(XMPPRosterItem*)item;
- (void)xmppClient:(XMPPClient*)client didRemoveFromRoster:(XMPPRosterItem*)item;
- (void)xmppClient:(XMPPClient*)client didFinishReceivingRosterItems:(XMPPIQ *)iq;

// presence
- (void)xmppClient:(XMPPClient*)client didReceivePresence:(XMPPPresence*)sender;
- (void)xmppClient:(XMPPClient*)client didReceiveErrorPresence:(XMPPPresence*)sender;
- (void)xmppClient:(XMPPClient*)client didReceiveBuddyRequest:(XMPPJID*)buddyJid;
- (void)xmppClient:(XMPPClient*)client didAcceptBuddyRequest:(XMPPJID*)buddyJid;
- (void)xmppClient:(XMPPClient*)client didRejectBuddyRequest:(XMPPJID*)buddyJid;

// version discovery
- (void)xmppClient:(XMPPClient*)client didReceiveClientVersionResult:(XMPPIQ*)iq;
- (void)xmppClient:(XMPPClient*)client didReceiveClientVersionRequest:(XMPPIQ*)iq;

// applications
- (void)xmppClient:(XMPPClient*)client didReceiveIQ:(XMPPIQ*)iq;
- (void)xmppClient:(XMPPClient*)client didReceiveMessage:(XMPPMessage*)message;
- (void)xmppClient:(XMPPClient*)client didReceiveCommandResult:(XMPPIQ*)iq;

// disco
- (void)xmppClient:(XMPPClient*)client didReceiveDiscoItemsResult:(XMPPIQ*)iq;
- (void)xmppClient:(XMPPClient*)client didReceiveDiscoInfoResult:(XMPPIQ*)iq;
- (void)xmppClient:(XMPPClient*)client didDiscoverPubSubService:(XMPPIQ*)iq;
- (void)xmppClient:(XMPPClient*)client didDiscoverUserPubSubRoot:(XMPPIQ*)iq;
- (void)xmppClient:(XMPPClient*)client didDiscoverCommandNodes:(XMPPIQ*)iq;

@end
