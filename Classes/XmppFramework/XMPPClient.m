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
#import "XMPPxData.h"

#import "NSObjectiPhoneAdditions.h"
#import "NSXMLElementAdditions.h"
#import "MulticastDelegate.h"
#import "SCNotificationManager.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPClient (PrivateAPI)

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
- (void)sendElement:(NSXMLElement *)element {
	[xmppStream sendElement:element];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)sendElement:(NSXMLElement *)element andNotifyMe:(long)tag {
	[xmppStream sendElement:element andNotifyMe:tag];
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
    XMPPQuery* query = [iq query];
    XMPPCommand* command = [iq command];
    XMPPPubSub* pubsub = [iq pubsub];
	if([[query className] isEqualToString:@"XMPPRosterQuery"]) {
        [multicastDelegate  xmppClient:self didReceiveRosterItems:iq];
	} else if ([[query className] isEqualToString:@"XMPPClientVersionQuery"] && [[iq type] isEqualToString:@"result"]) {
        [multicastDelegate  xmppClient:self didReceiveClientVersionResult:iq];
	} else if ([[query className] isEqualToString:@"XMPPClientVersionQuery"] && [[iq type] isEqualToString:@"get"]) {
        [multicastDelegate  xmppClient:self didReceiveClientVersionRequest:iq];
	} else if ([[query className] isEqualToString:@"XMPPClientVersionQuery"] && [[iq type] isEqualToString:@"error"]) {
        [multicastDelegate  xmppClient:self didReceiveClientVersionError:iq];
	} else if ([[query className] isEqualToString:@"XMPPDiscoItemsQuery"] && [[iq type] isEqualToString:@"result"]) {
        [multicastDelegate  xmppClient:self didReceiveDiscoItemsResult:iq];
	} else if ([[query className] isEqualToString:@"XMPPDiscoItemsQuery"] && [[iq type] isEqualToString:@"error"]) {
        [multicastDelegate  xmppClient:self didReceiveDiscoItemsError:iq];
	} else if ([[query className] isEqualToString:@"XMPPDiscoInfoQuery"] && [[iq type] isEqualToString:@"result"]) {
        [multicastDelegate  xmppClient:self didReceiveDiscoInfoResult:iq];
	} else if ([[query className] isEqualToString:@"XMPPDiscoInfoQuery"] && [[iq type] isEqualToString:@"error"]) {
        [multicastDelegate  xmppClient:self didReceiveDiscoInfoError:iq];
	} else if (command && [[iq type] isEqualToString:@"result"]) {
        [multicastDelegate xmppClient:self didReceiveCommandResult:iq];
	} else if (pubsub) {
        NSXMLElement* createElement = [pubsub elementForName:@"create"];
        NSXMLElement* subscriptionsElement = [pubsub elementForName:@"subscriptions"];
        if ([[iq type] isEqualToString:@"error"] && createElement) {
            [multicastDelegate xmppClient:self didReceiveCreateSubscriptionError:iq];
        } else if ([[iq type] isEqualToString:@"result"] && subscriptionsElement) {
            [multicastDelegate xmppClient:self didReceiveSubscriptionsResult:iq];
        }
	} else if ([[iq type] isEqualToString:@"result"]) {
        [multicastDelegate xmppClient:self didReceiveIQResult:iq];
    } else if ([[iq type] isEqualToString:@"error"]) {
        [multicastDelegate xmppClient:self didReceiveIQError:iq];
	}
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppStream:(XMPPStream*)sender didReceiveMessage:(XMPPMessage*)message {
    [multicastDelegate xmppClient:self didReceiveMessage:message];
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
#pragma mark PrivateAPI:

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)init {
	if(self = [super init]) {
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
	[super dealloc];
}

@end
