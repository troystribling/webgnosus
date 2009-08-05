//
//  XMPPClientManager.m
//  webgnosus
//
//  Created by Troy Stribling on 1/14/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPClientManager.h"
#import "AccountModel.h"
#import "AccountModel.h"
#import "XMPPJID.h"

//-----------------------------------------------------------------------------------------------------------------------------------
static XMPPClientManager* thisXMPPClientManager = nil;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPClientManager

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize xmppClientDictionary;
@synthesize delegate;

//===================================================================================================================================
#pragma mark XMPPClientManager

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPClientManager*)instance {	
    @synchronized(self) {
        if (thisXMPPClientManager == nil) {
            [[self alloc] init]; 
        }
    }       
    return thisXMPPClientManager;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPClient*)xmppClientForAccount:(AccountModel*)account {
	XMPPClient* xmppClient = (XMPPClient*)[xmppClientDictionary valueForKey:[account fullJID]];
	if (xmppClient == nil) {
		xmppClient = [self createXMPPClientForAccount:account];
		[xmppClient connect];
		[xmppClientDictionary setValue:xmppClient forKey:[account fullJID]];
	}
	return xmppClient;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPClient*)xmppClientForAccount:(AccountModel*)account andDelegateTo:(id)clientDelegate {
	XMPPClient* xmppClient = [self xmppClientForAccount:account];
    [xmppClient addDelegate:clientDelegate];
	return xmppClient;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)openConnectionForAccount:(AccountModel*)account {
    [self xmppClientForAccount:account];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)removeXMPPClientForAccount:(AccountModel*)account {
	XMPPClient* xmppClient = (XMPPClient*)[xmppClientDictionary valueForKey:[account fullJID]];
	if (xmppClient) {
		if([xmppClient isConnected])
		{
            [xmppClient removeAllDelgates];
			[xmppClient disconnect];
            [xmppClient release];
		}
		[xmppClientDictionary removeObjectForKey:[account fullJID]];
	}
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)removeXMPPClientDelegate:(id)clientDelegate forAccount:(AccountModel*)account {
	XMPPClient* xmppClient = (XMPPClient*)[xmppClientDictionary valueForKey:[account fullJID]];
	if (xmppClient) {
        [xmppClient removeDelegate:clientDelegate];
	}
}

//----------------------------------------------------------------------------------------------------------------------------------
- (XMPPClient*)createXMPPClientForAccount:(AccountModel*)account {
	XMPPClient* xmppClient = [[XMPPClient alloc] init];
	[xmppClient addDelegate:self.delegate];
	XMPPJID* jid;
	if (account.resource) {
		jid = [XMPPJID jidWithString:account.jid resource:account.resource];
	} else {
		jid = [XMPPJID jidWithString:account.jid];	
	}
	xmppClient.myJID = jid;
	xmppClient.password = account.password;
	xmppClient.domain = account.host;
    xmppClient.port = account.port;
	return xmppClient;
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    thisXMPPClientManager = self;
	self.xmppClientDictionary = [NSMutableDictionary dictionaryWithCapacity:10];
    return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
