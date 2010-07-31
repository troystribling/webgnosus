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
#import "XMPPPubSub.h"
#import "XMPPPubSubEvent.h"
#import "XMPPResponse.h"
#import "XMPPxData.h"

#import "NSObjectWebgnosus.h"
#import "NSXMLElementAdditions.h"
#import "MulticastDelegate.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPClient (PrivateAPI)

- (void)addResponseDelegate:(XMPPResponse*)request;
- (XMPPResponse*)getResponseDelegateWithID:(NSString*)requestID;
- (NSString*)generateStanzaID;
- (void)removeResponseDelegateWithID:(NSString*)reqID;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPClient

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize multicastDelegate;
@synthesize xmppResponseList;
@synthesize domain;
@synthesize myJID;
@synthesize password;
@synthesize xmppStream;
@synthesize port;
@synthesize stanzaID;
@synthesize sessionID;
@synthesize priority;

//===================================================================================================================================
#pragma mark XMPPClient

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)isAccountJID:(NSString*)requestJID {
    return [[self.myJID full] isEqualToString:requestJID];
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
    [multicastDelegate  xmppClientConnecting:self];
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
#pragma mark Sending Elements

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)send:(XMPPStanza*)stanza andDelegateResponse:(id)reqDelegate {
    XMPPResponse* xmppResp = [[XMPPResponse alloc] initWithDelegate:reqDelegate];
    NSString* stanID = [self generateStanzaID];
    xmppResp.stanzaID = stanID;
    [self addResponseDelegate:xmppResp];
    [stanza addStanzaID:stanID];
    [self sendElement:stanza];
    [xmppResp release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)sendElement:(NSXMLElement*)element {
	[xmppStream sendElement:element];
}

//===================================================================================================================================
#pragma mark XMPPStream Delegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppStreamDidOpen:(XMPPStream*)sender {
    [multicastDelegate xmppClientDidConnect:self];
    [self authenticateUser];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppStreamDidRegister:(XMPPStream*)sender {
	[multicastDelegate xmppClientDidRegister:self];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement*)error {
	[multicastDelegate xmppClient:self didNotRegister:error];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppStreamDidAuthenticate:(XMPPStream*)sender {
	[multicastDelegate xmppClientDidAuthenticate:self];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppStream:(XMPPStream*)sender didNotAuthenticate:(NSXMLElement*)error {
	[multicastDelegate xmppClient:self didNotAuthenticate:error];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppStream:(XMPPStream*)sender didReceiveIQ:(XMPPIQ*)iq {
    NSString* stanID = [iq stanzaID];
    XMPPResponse* resp = (XMPPResponse*)[self getResponseDelegateWithID:stanID];
    if (resp) {
        [resp handleResponse:self forStanza:iq];
        [self removeResponseDelegateWithID:stanID];
        return;
    }
    XMPPQuery* query = [iq query];
    XMPPPubSub* pubsub = [iq pubsub];
    // Roster
	if([[query className] isEqualToString:@"XMPPRosterQuery"] && [[iq type] isEqualToString:@"result"]) {
        [multicastDelegate  xmppClient:self didReceiveRosterResult:iq];
    } else if([[query className] isEqualToString:@"XMPPRosterQuery"] && [[iq type] isEqualToString:@"set"]) {
        [multicastDelegate  xmppClient:self didReceiveRosterResult:iq];
	} else if ([[query className] isEqualToString:@"XMPPRosterQuery"] && [[iq type] isEqualToString:@"error"]) {
        [multicastDelegate  xmppClient:self didReceiveRosterError:iq];
    // Client Version
	} else if ([[query className] isEqualToString:@"XMPPClientVersionQuery"] && [[iq type] isEqualToString:@"result"]) {
        [multicastDelegate  xmppClient:self didReceiveClientVersionResult:iq];
	} else if ([[query className] isEqualToString:@"XMPPClientVersionQuery"] && [[iq type] isEqualToString:@"get"]) {
        [multicastDelegate  xmppClient:self didReceiveClientVersionRequest:iq];
	} else if ([[query className] isEqualToString:@"XMPPClientVersionQuery"] && [[iq type] isEqualToString:@"error"]) {
        [multicastDelegate  xmppClient:self didReceiveClientVersionError:iq];
    // Disco Items
	} else if ([[query className] isEqualToString:@"XMPPDiscoItemsQuery"] && [[iq type] isEqualToString:@"result"]) {
        [multicastDelegate  xmppClient:self didReceiveDiscoItemsResult:iq];
	} else if ([[query className] isEqualToString:@"XMPPDiscoItemsQuery"] && [[iq type] isEqualToString:@"get"]) {
        [multicastDelegate  xmppClient:self didReceiveDiscoItemsRequest:iq];
	} else if ([[query className] isEqualToString:@"XMPPDiscoItemsQuery"] && [[iq type] isEqualToString:@"error"]) {
        [multicastDelegate  xmppClient:self didReceiveDiscoItemsError:iq];
    // Diso Info
	} else if ([[query className] isEqualToString:@"XMPPDiscoInfoQuery"] && [[iq type] isEqualToString:@"result"]) {
        [multicastDelegate  xmppClient:self didReceiveDiscoInfoResult:iq];
	} else if ([[query className] isEqualToString:@"XMPPDiscoInfoQuery"] && [[iq type] isEqualToString:@"get"]) {
        [multicastDelegate  xmppClient:self didReceiveDiscoInfoRequest:iq];
	} else if ([[query className] isEqualToString:@"XMPPDiscoInfoQuery"] && [[iq type] isEqualToString:@"error"]) {
        [multicastDelegate  xmppClient:self didReceiveDiscoInfoError:iq];
    // PubSub    
    } else if (pubsub) {
    // IQ
	} else if ([[iq type] isEqualToString:@"result"]) {
        [multicastDelegate xmppClient:self didReceiveIQResult:iq];
    } else if ([[iq type] isEqualToString:@"error"]) {
        [multicastDelegate xmppClient:self didReceiveIQError:iq];
	}
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppStream:(XMPPStream*)sender didReceiveMessage:(XMPPMessage*)message {
    XMPPPubSubEvent* event = [message event];
    if (event) {
        [multicastDelegate xmppClient:self didReceiveEvent:message];
    } else {
        [multicastDelegate xmppClient:self didReceiveMessage:message];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppStream:(XMPPStream*)sender didReceivePresence:(XMPPPresence*)presence {
	if([[presence type] isEqualToString:@"subscribe"]) {
        [multicastDelegate  xmppClient:self didReceiveBuddyRequest:[presence fromJID]];
	} else if ([[presence type] isEqualToString:@"subscribed"]) {
        [multicastDelegate  xmppClient:self didAcceptBuddyRequest:[presence fromJID]];
	} else if ([[presence type] isEqualToString:@"unsubscribed"]) {
        [multicastDelegate  xmppClient:self didRejectBuddyRequest:[presence fromJID]];
	} else if ([[presence type] isEqualToString:@"error"]) {
        [multicastDelegate  xmppClient:self didReceiveErrorPresence:presence];
    } else {
        [multicastDelegate  xmppClient:self didReceivePresence:presence];
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
            [multicastDelegate xmppClientDidNotConnect:self];
		}
	}
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppStreamDidClose:(XMPPStream *)sender {
	[multicastDelegate xmppClientDidDisconnect:self];
}

//===================================================================================================================================
#pragma mark Reconnecting

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)attemptReconnect:(id)ignore {
	NSLog(@"XMPPClient: attempReconnect method called...");
    [self connect];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)networkStatusDidChange:(NSNotification*)notification {
	if([notification userInfo]) {
        [self performSelector:@selector(attemptReconnect:) withObject:nil afterDelay:4.0];
	}
}

//===================================================================================================================================
#pragma mark XMPPClient PrivateAPI:

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addResponseDelegate:(XMPPResponse*)response {
    [self.xmppResponseList setValue:response forKey:response.stanzaID];
}    

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPResponse*)getResponseDelegateWithID:(NSString*)stanID {
    XMPPResponse* resp = nil;
    if (stanID) {
        resp = [self.xmppResponseList valueForKey:stanID];
    }
    return resp;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)removeResponseDelegateWithID:(NSString*)stanID {
    if (stanID) {
        [self.xmppResponseList removeObjectForKey:stanID];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)generateStanzaID {
    self.stanzaID++;
    return [NSString stringWithFormat:@"%d", self.stanzaID];
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)init {
	if(self = [super init]) {
		self.multicastDelegate = [[MulticastDelegate alloc] init];	
        self.stanzaID = 0;
		self.priority = 1;
		self.xmppStream = [[XMPPStream alloc] initWithDelegate:self];				
        self.xmppResponseList = [NSMutableDictionary dictionaryWithCapacity:10];
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
	[super dealloc];
}

@end
