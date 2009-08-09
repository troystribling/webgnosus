//
//  XMPPClient.m
//  webgnosus
//
//  Created by Troy Stribling on 3/29/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPClient.h"
#import "XMPPStream.h"
#import "XMPPJID.h"
#import "XMPPClientVersionQuery.h"
#import "XMPPIQ.h"
#import "XMPPMessage.h"
#import "XMPPPresence.h"
#import "XMPPRosterQuery.h"
#import "XMPPRosterItem.h"
#import "XMPPCommand.h"
#import "XMPPxData.h"

#import "NSObjectiPhoneAdditions.h"
#import "MulticastDelegate.h"
#import "SCNotificationManager.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPClient (PrivateAPI)

- (void)onConnecting;
- (void)onDidConnect;
- (void)onDidNotConnect;
- (void)onDidDisconnect;
- (void)onDidRegister;
- (void)onDidNotRegister:(NSXMLElement*)error;
- (void)onDidAuthenticate;
- (void)onDidNotAuthenticate:(NSXMLElement*)error;
- (void)onDidAddToRoster:(XMPPRosterItem*)user;
- (void)onDidRemoveFromRoster:(XMPPRosterItem*)user;
- (void)onDidReceivePresence:(XMPPPresence*)presence;
- (void)onDidReceiveErrorPresence:(XMPPPresence*)presence;
- (void)onDidReceiveBuddyRequest:(XMPPJID*)buddyJid;
- (void)onDidAcceptBuddyRequest:(XMPPJID*)buddyJid;
- (void)onDidRejectBuddyRequest:(XMPPJID*)buddyJid;
- (void)onDidReceiveIQ:(XMPPIQ*)iq;
- (void)onDidReceiveMessage:(XMPPMessage *)message;
- (void)onDidReceiveClientVersionResult:(XMPPIQ*)iq;
- (void)onDidReceiveClientVersionRequest:(XMPPIQ*)iq;
- (void)onDidReceiveRosterItems:(XMPPIQ*)iq;
- (void)onDidFinishReceivingRosterItems:(XMPPIQ*)iq;
- (void)onDidReceiveMethodResponse:(XMPPIQ*)iq;
- (void)onDidReceiveCommandResult:(XMPPIQ*)iq;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPClient

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize multicastDelegate;
@synthesize domain;
@synthesize myJID;
@synthesize password;
@synthesize xmppStream;
@synthesize scNotificationManager;
@synthesize port;
@synthesize priority;

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)init {
	if(self = [super init])
	{
		self.multicastDelegate = [[MulticastDelegate alloc] init];		
		self.priority = 1;
		self.xmppStream = [[XMPPStream alloc] initWithDelegate:self];				
		self.scNotificationManager = [[SCNotificationManager alloc] init];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusDidChange:) name:@"State:/Network/Global/IPv4" object:scNotificationManager];
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
	[multicastDelegate release];	
	[domain release];
	[myJID release];
	[password release];	
	[xmppStream setDelegate:nil];
	[xmppStream disconnect];
	[xmppStream release];
	[streamError release];	
	[scNotificationManager release];	
	[super dealloc];
}

//===================================================================================================================================
#pragma mark Delegation

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addDelegate:(id)delegate {
	[multicastDelegate addDelegate:delegate];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)removeDelegate:(id)delegate  {
	[multicastDelegate removeDelegate:delegate];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)removeAllDelgates {
	[multicastDelegate removeAllDelegates];
}

//===================================================================================================================================
#pragma mark Security

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)allowsSelfSignedCertificates {
	return [xmppStream allowsSelfSignedCertificates];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setAllowsSelfSignedCertificates:(BOOL)flag {
	[xmppStream setAllowsSelfSignedCertificates:flag];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)authenticateUser {
	[xmppStream authenticateUser:[myJID user] withPassword:password resource:[myJID resource]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)isSecure {
	return [xmppStream isSecure];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)isAuthenticated {
	return [xmppStream isAuthenticated];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)supportsInBandRegistration {
	return [xmppStream supportsInBandRegistration];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)registerUser {
	[xmppStream registerUser:[myJID user] withPassword:password];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)supportsPlainAuthentication {
	return [xmppStream supportsPlainAuthentication];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)supportsDigestMD5Authentication {
	return [xmppStream supportsDigestMD5Authentication];
}

//===================================================================================================================================
#pragma mark connection

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)connect {
	[self onConnecting];
    [xmppStream connectToHost:domain onPort:port withVirtualHost:[myJID domain]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)disconnect {
	[xmppStream disconnect];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)isDisconnected {
	return [xmppStream isDisconnected];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)isConnected {
	return [xmppStream isConnected];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSError *)streamError {
    return streamError;
}

//===================================================================================================================================
#pragma mark Status

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)goOnline {
	[xmppStream sendElement:[[XMPPPresence alloc] initWithPriority:[NSString stringWithFormat:@"%i", self.priority]]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)goOffline {
	[xmppStream sendElement:[[XMPPPresence alloc] initWithType:@"unavailable"]];
}

//===================================================================================================================================
#pragma mark Roster

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)fetchRoster {
    XMPPIQ* iq = [[XMPPIQ alloc] initWithType:@"get"];
    [iq addQuery:[[XMPPRosterQuery alloc] init]];
    [xmppStream sendElement:iq];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addBuddy:(XMPPJID*)jid {
	if(jid == nil) return;
	
    // send roster set iq
    XMPPRosterQuery* query = [[XMPPRosterQuery alloc] init];
    [query addItem:[[XMPPRosterItem alloc] initWithJID:[jid bare]]];
    XMPPIQ* iq = [[XMPPIQ alloc] initWithType:@"set"];
    [iq addQuery:query];
    [xmppStream sendElement:iq];
	
	// subscribe to the buddy's presence
	[xmppStream sendElement:[[XMPPPresence alloc] initWithType:@"subscribe" toJID:[jid bare]]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)removeBuddy:(XMPPJID *)jid {
	if(jid == nil) return;	
    XMPPRosterQuery* query = [[XMPPRosterQuery alloc] init];
    [query addItem:[[XMPPRosterItem alloc] initWithJID:[jid bare] andSubscription:@"remove"]];
    XMPPIQ* iq = [[XMPPIQ alloc] initWithType:@"set"];
    [iq addQuery:query];
    [xmppStream sendElement:iq];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)acceptBuddyRequest:(XMPPJID*)jid {
	// send presence response
	[xmppStream sendElement:[[XMPPPresence alloc] initWithType:@"subscribed" toJID:[jid bare]]];
	
	// add user to our roster
    XMPPRosterQuery* query = [[XMPPRosterQuery alloc] init];
    [query addItem:[[XMPPRosterItem alloc] initWithJID:[jid bare]]];
    XMPPIQ* iq = [[XMPPIQ alloc] initWithType:@"set"];
    [iq addQuery:query];
    [xmppStream sendElement:iq];
	
	// subscribe to the contact presence
	[xmppStream sendElement:[[XMPPPresence alloc] initWithType:@"subscribe" toJID:[jid bare]]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)rejectBuddyRequest:(XMPPJID *)jid {
	[xmppStream sendElement:[[XMPPPresence alloc] initWithType:@"unsubscribed" toJID:[jid bare]]];
}

//===================================================================================================================================
#pragma mark Service Discovery

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)sendClientVersion:(XMPPClientVersionQuery*)version forIQ:(XMPPIQ*)iq {
    XMPPIQ* responseIQ = [[XMPPIQ alloc] initWithType:@"result" toJID:[[iq fromJID] full]];
    [responseIQ addStanzaID:[iq stanzaID]];
    [responseIQ addQuery:version];
	[self sendElement:responseIQ];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)getClientVersionForJid:(XMPPJID*)jid {
    XMPPIQ* iq = [[XMPPIQ alloc] initWithType:@"get" toJID:[jid full]];
    [iq addQuery:[[XMPPClientVersionQuery alloc] init]];
	[self sendElement:iq];
}

//===================================================================================================================================
#pragma mark Sending Elements

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)sendElement:(NSXMLElement *)element {
	[xmppStream sendElement:element];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)sendElement:(NSXMLElement *)element andNotifyMe:(long)tag {
	[xmppStream sendElement:element andNotifyMe:tag];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)sendMessage:(NSString*)body toJID:(XMPPJID*)jid {
    XMPPMessage* msg = [[XMPPMessage alloc] initWithType:@"chat" toJID:[jid full] andBody:body];
	[self sendElement:msg];
}

//===================================================================================================================================
#pragma mark Commands

- (void)sendCommand:(NSString*)method toJID:(XMPPJID*)jid {
    XMPPIQ* iq = [[XMPPIQ alloc] initWithType:@"set" toJID:[jid full]];
    XMPPCommand* cmd = [[XMPPCommand alloc] initWithNode:method andAction:@"execute"];
    [iq addCommand:cmd];
    [self sendElement:iq];
    [iq release]; 
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)sendCommand:(NSString*)method withParameter:(NSMutableDictionary*)parameters toJID:(XMPPJID*)jid {
    NSEnumerator* enumerator = [parameters keyEnumerator];
    NSString* field;  
    XMPPxData* cmdData = [[XMPPxData alloc] initWithDataType:@"submit"];
    while ((field = (NSString*)[enumerator nextObject])) {
        NSString* fieldVal = (NSString*)[parameters objectForKey:field];
        [cmdData addField:field withValue:fieldVal]; 
    }  
    XMPPIQ* iq = [[XMPPIQ alloc] initWithType:@"set" toJID:[jid full]];
    XMPPCommand* cmd = [[XMPPCommand alloc] initWithNode:method action:@"execute" andData:cmdData];
    [iq addCommand:cmd];
    [self sendElement:iq];
    [iq release]; 
}

//===================================================================================================================================
#pragma mark XMPPStream Delegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppStreamDidOpen:(XMPPStream*)sender {
	[self onDidConnect];
    [self authenticateUser];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppStreamDidRegister:(XMPPStream*)sender {
	[self onDidRegister];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement*)error {
	[self onDidNotRegister:error];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppStreamDidAuthenticate:(XMPPStream*)sender {
	[self onDidAuthenticate];	
    [self fetchRoster];
    [self goOnline];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppStream:(XMPPStream*)sender didNotAuthenticate:(NSXMLElement*)error {
	[self onDidNotAuthenticate:error];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppStream:(XMPPStream*)sender didReceiveIQ:(XMPPIQ*)iq {
    XMPPQuery* query = [iq query];
    XMPPCommand* command = [iq command];
	if([[query className] isEqualToString:@"XMPPRosterQuery"]) {
        [self onDidReceiveRosterItems:iq];
	} else if ([[query className] isEqualToString:@"XMPPClientVersionQuery"] && [[iq type] isEqualToString:@"result"]) {
        [self onDidReceiveClientVersionResult:iq];
	} else if ([[query className] isEqualToString:@"XMPPClientVersionQuery"] && [[iq type] isEqualToString:@"get"]) {
        [self onDidReceiveClientVersionRequest:iq];
	} else if ([[query className] isEqualToString:@"XMPPRPCMethodResponse"] && [[iq type] isEqualToString:@"result"]) {
        [self onDidReceiveMethodResponse:iq];
	} else if (command && [[iq type] isEqualToString:@"result"]) {
        [self onDidReceiveCommandResult:iq];
    } else {
		[self onDidReceiveIQ:iq];
	}
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppStream:(XMPPStream*)sender didReceiveMessage:(XMPPMessage*)message {
	[self onDidReceiveMessage:message];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppStream:(XMPPStream*)sender didReceivePresence:(XMPPPresence*)presence {
	if([[presence type] isEqualToString:@"subscribe"]) {
        [self onDidReceiveBuddyRequest:[presence fromJID]];
	} else if ([[presence type] isEqualToString:@"subscribed"]) {
        [self onDidAcceptBuddyRequest:[presence fromJID]];
	} else if ([[presence type] isEqualToString:@"unsubscribed"]) {
        [self onDidRejectBuddyRequest:[presence fromJID]];
	} else if ([[presence type] isEqualToString:@"error"]) {
        [self onDidReceiveErrorPresence:presence];
    } else {
        [self onDidReceivePresence:presence];
	}
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppStream:(XMPPStream*)xs didReceiveError:(id)error {
	if([error isKindOfClass:[NSError class]]) {
		[streamError autorelease];
		streamError = [(NSError *)error copy];		
		if([xmppStream isAuthenticated]) {
			[self performSelector:@selector(attemptReconnect:) withObject:nil afterDelay:4.0];
		} else {
			[self onDidNotConnect];
		}
	}
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppStreamDidClose:(XMPPStream *)sender {
	[self onDidDisconnect];
}

//===================================================================================================================================
#pragma mark Reconnecting

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)attemptReconnect:(id)ignore {
	NSLog(@"XMPPClient: attempReconnect method called...");
	
//	if([xmppStream isDisconnected]) {
//		SCNetworkConnectionFlags reachabilityStatus;
//		BOOL success = SCNetworkCheckReachabilityByName("google.com", &reachabilityStatus);
//		
//		if(success && (reachabilityStatus & kSCNetworkFlagsReachable))
//		{
			[self connect];
//		}
//	}
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)networkStatusDidChange:(NSNotification*)notification {
	if([notification userInfo]) {
        [self performSelector:@selector(attemptReconnect:) withObject:nil afterDelay:4.0];
	}
}

//===================================================================================================================================
#pragma mark PrivateAPI:

//===================================================================================================================================
#pragma mark connection
//-----------------------------------------------------------------------------------------------------------------------------------
- (void)onConnecting {
	[multicastDelegate xmppClientConnecting:self];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)onDidConnect {
	[multicastDelegate xmppClientDidConnect:self];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)onDidNotConnect {
	[multicastDelegate xmppClientDidNotConnect:self];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)onDidDisconnect {
    [multicastDelegate xmppClientDidDisconnect:self];
}

//===================================================================================================================================
#pragma mark resgistration
//-----------------------------------------------------------------------------------------------------------------------------------
- (void)onDidRegister {
	[multicastDelegate xmppClientDidRegister:self];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)onDidNotRegister:(NSXMLElement*)error {
	[multicastDelegate xmppClient:self didNotRegister:error];
}

//===================================================================================================================================
#pragma mark authentication
//-----------------------------------------------------------------------------------------------------------------------------------
- (void)onDidAuthenticate {
	[multicastDelegate xmppClientDidAuthenticate:self];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)onDidNotAuthenticate:(NSXMLElement *)error {
	[multicastDelegate xmppClient:self didNotAuthenticate:error];
}

//===================================================================================================================================
#pragma mark messaging
//-----------------------------------------------------------------------------------------------------------------------------------
- (void)onDidReceiveIQ:(XMPPIQ*)iq {
	[multicastDelegate xmppClient:self didReceiveIQ:iq];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)onDidReceiveMessage:(XMPPMessage*)message {
	[multicastDelegate xmppClient:self didReceiveMessage:message];
}

//===================================================================================================================================
#pragma mark roster
//-----------------------------------------------------------------------------------------------------------------------------------
- (void)onDidReceiveRosterItems:(XMPPIQ*)iq {
    XMPPRosterQuery* query = (XMPPRosterQuery*)[iq query];
    NSArray* items = [query items];		
    int i;
    for(i = 0; i < [items count]; i++) {
        XMPPRosterItem* item = [XMPPRosterItem createFromElement:(NSXMLElement *)[items objectAtIndex:i]];            
        if([item.subscription isEqualToString:@"remove"]) {
            [self onDidRemoveFromRoster:item];
        }
        else {
            [self onDidAddToRoster:item];
        }
    }
    [self onDidFinishReceivingRosterItems:iq];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)onDidAddToRoster:(XMPPRosterItem*)item {
	[multicastDelegate  xmppClient:self didAddToRoster:item];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)onDidRemoveFromRoster:(XMPPRosterItem*)item {
	[multicastDelegate xmppClient:self didRemoveFromRoster:item];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)onDidFinishReceivingRosterItems:(XMPPIQ*)iq {
	[multicastDelegate xmppClient:self didFinishReceivingRosterItems:iq];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)onDidReceiveErrorPresence:(XMPPPresence*)presence {
	[multicastDelegate xmppClient:self didReceiveErrorPresence:presence];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)onDidReceivePresence:(XMPPPresence*)presence {
	[multicastDelegate xmppClient:self didReceivePresence:presence];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)onDidReceiveBuddyRequest:(XMPPJID *)buddyJid {
    [multicastDelegate xmppClient:self didReceiveBuddyRequest:buddyJid];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)onDidAcceptBuddyRequest:(XMPPJID *)buddyJid {
    [multicastDelegate xmppClient:self didAcceptBuddyRequest:buddyJid];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)onDidRejectBuddyRequest:(XMPPJID *)buddyJid {
    [multicastDelegate xmppClient:self didRejectBuddyRequest:buddyJid];
}

//===================================================================================================================================
#pragma mark service discovery
//-----------------------------------------------------------------------------------------------------------------------------------
- (void)onDidReceiveClientVersionResult:(XMPPIQ*)iq {
	[multicastDelegate xmppClient:self didReceiveClientVersionResult:iq];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)onDidReceiveClientVersionRequest:(XMPPIQ*)iq {
	[multicastDelegate xmppClient:self didReceiveClientVersionRequest:iq];
}

//===================================================================================================================================
#pragma mark Commands
//-----------------------------------------------------------------------------------------------------------------------------------
- (void)onDidReceiveCommandResult:(XMPPIQ*)iq {
	[multicastDelegate xmppClient:self didReceiveCommandResult:iq];
}

@end
