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
@class XMPPStanza;
@class XMPPIQ;
@class XMPPMessage;
@class XMPPPresence;
@class XMPPRosterItem;
@class XMPPResponse;
@class XMPPDiscoIdentity;
@class XMPPDiscoItem;
@class XMPPClientVersionQuery;
@class XMPPDiscoItemsQuery;
@class MulticastDelegate;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPClient : NSObject {
	MulticastDelegate* multicastDelegate;	
	NSMutableDictionary* xmppResponseList;
	NSString* domain;
	XMPPJID* myJID;
	NSString *password;
	XMPPStream* xmppStream;
	UInt16 port;	
    NSInteger stanzaID;
    NSInteger sessionID;
	int priority;    
   	NSError* streamError;	 
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) MulticastDelegate* multicastDelegate;
@property (nonatomic, retain) NSMutableDictionary* xmppResponseList;
@property (nonatomic, retain) NSString* domain;
@property (nonatomic, retain) XMPPJID* myJID;
@property (nonatomic, retain) NSString* password;
@property (nonatomic, retain) XMPPStream* xmppStream;
@property (nonatomic, assign) UInt16 port;
@property (nonatomic, assign) NSInteger stanzaID;
@property (nonatomic, assign) NSInteger sessionID;
@property (nonatomic, assign) int priority;

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)init;
- (BOOL)isAccountJID:(NSString*)requestJID;

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

// send requests
- (void)send:(XMPPStanza*)stanza andDelegateResponse:(id)reqDelegate;
- (void)sendElement:(NSXMLElement*)element;

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
- (void)xmppClient:(XMPPClient*)client didReceiveRosterResult:(XMPPIQ*)iq;
- (void)xmppClient:(XMPPClient*)client didReceiveRosterError:(XMPPIQ*)iq;
- (void)xmppClient:(XMPPClient*)client didAddToRoster:(XMPPRosterItem*)item;
- (void)xmppClient:(XMPPClient*)client didRemoveFromRoster:(XMPPRosterItem*)item;
- (void)xmppClient:(XMPPClient*)client didReceiveAllRosterItems:(XMPPIQ *)iq;

// presence
- (void)xmppClient:(XMPPClient*)client didReceivePresence:(XMPPPresence*)sender;
- (void)xmppClient:(XMPPClient*)client didReceiveErrorPresence:(XMPPPresence*)sender;
- (void)xmppClient:(XMPPClient*)client didReceiveBuddyRequest:(XMPPJID*)buddyJid;
- (void)xmppClient:(XMPPClient*)client didAcceptBuddyRequest:(XMPPJID*)buddyJid;
- (void)xmppClient:(XMPPClient*)client didRejectBuddyRequest:(XMPPJID*)buddyJid;

// version discovery
- (void)xmppClient:(XMPPClient*)client didReceiveClientVersionResult:(XMPPIQ*)iq;
- (void)xmppClient:(XMPPClient*)client didReceiveClientVersionRequest:(XMPPIQ*)iq;
- (void)xmppClient:(XMPPClient*)client didReceiveClientVersionError:(XMPPIQ*)iq;

// applications
- (void)xmppClient:(XMPPClient*)client didReceiveIQ:(XMPPIQ*)iq;
- (void)xmppClient:(XMPPClient*)client didReceiveMessage:(XMPPMessage*)message;
- (void)xmppClient:(XMPPClient*)client didReceiveEvent:(XMPPMessage*)message;
- (void)xmppClient:(XMPPClient*)client didReceiveCommandError:(XMPPIQ*)iq;
- (void)xmppClient:(XMPPClient*)client didReceiveCommandResult:(XMPPIQ*)iq;
- (void)xmppClient:(XMPPClient*)client didReceiveCommandForm:(XMPPIQ*)iq;

// disco
- (void)xmppClient:(XMPPClient*)client didReceiveDiscoItemsResult:(XMPPIQ*)iq;
- (void)xmppClient:(XMPPClient*)client didReceiveDiscoItemsRequest:(XMPPIQ*)iq;
- (void)xmppClient:(XMPPClient*)client didReceiveDiscoItemsError:(XMPPIQ*)iq;
- (void)xmppClient:(XMPPClient*)client didReceiveDiscoItemsServiceResult:(XMPPIQ*)iq;
- (void)xmppClient:(XMPPClient*)client didReceiveDiscoItemsServiceError:(XMPPIQ*)iq;
- (void)xmppClient:(XMPPClient*)client didReceiveDiscoInfoResult:(XMPPIQ*)iq;
- (void)xmppClient:(XMPPClient*)client didReceiveDiscoInfoRequest:(XMPPIQ*)iq;
- (void)xmppClient:(XMPPClient*)client didReceiveDiscoInfoError:(XMPPIQ*)iq;
- (void)xmppClient:(XMPPClient*)client didReceiveDiscoInfoServiceResult:(XMPPIQ*)iq;
- (void)xmppClient:(XMPPClient*)client didReceiveDiscoInfoServiceError:(XMPPIQ*)iq;

// pubsub
- (void)xmppClient:(XMPPClient*)client didReceivePubSubSubscriptionsError:(XMPPIQ*)iq;
- (void)xmppClient:(XMPPClient*)client didReceivePubSubSubscriptionsResult:(XMPPIQ*)iq;
- (void)xmppClient:(XMPPClient*)client didReceivePubSubDeleteError:(XMPPIQ*)iq;
- (void)xmppClient:(XMPPClient*)client didReceivePubSubDeleteResult:(XMPPIQ*)iq;
- (void)xmppClient:(XMPPClient*)client didReceivePubSubUnsubscribeError:(XMPPIQ*)iq;
- (void)xmppClient:(XMPPClient*)client didReceivePubSubUnsubscribeResult:(XMPPIQ*)iq;
- (void)xmppClient:(XMPPClient*)client didReceivePubSubSubscribeError:(XMPPIQ*)iq;
- (void)xmppClient:(XMPPClient*)client didReceivePubSubSubscribeResult:(XMPPIQ*)iq;
- (void)xmppClient:(XMPPClient*)client didReceivePubSubEntryError:(XMPPIQ*)iq;
- (void)xmppClient:(XMPPClient*)client didReceivePubSubEntryResult:(XMPPIQ*)iq;
- (void)xmppClient:(XMPPClient*)client didReceivePubSubItemError:(XMPPIQ*)iq;
- (void)xmppClient:(XMPPClient*)client didReceivePubSubItemResult:(XMPPIQ*)iq;

- (void)xmppClient:(XMPPClient*)client didDiscoverUserPubSubNode:(XMPPDiscoItem*)item forService:(XMPPJID*)serviceJID andParentNode:(NSString*)node;
- (void)xmppClient:(XMPPClient*)client didFailToDiscoverUserPubSubNode:(XMPPIQ*)iq;
- (void)xmppClient:(XMPPClient*)client didDiscoverAllUserPubSubNodes:(XMPPJID*)targetJID;
- (void)xmppClient:(XMPPClient*)client didDiscoverPubSubService:(XMPPIQ*)iq;

// register
- (void)xmppClient:(XMPPClient*)client didReceiveRegisterError:(XMPPIQ*)iq;
- (void)xmppClient:(XMPPClient*)client didReceiveRegisterResult:(XMPPIQ*)iq;

// iq
- (void)xmppClient:(XMPPClient*)client didReceiveIQResult:(XMPPIQ*)iq;
- (void)xmppClient:(XMPPClient*)client didReceiveIQError:(XMPPIQ*)iq;


@end
