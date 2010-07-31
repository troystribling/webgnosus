//
//  XMPPClientManager.m
//  webgnosus
//
//  Created by Troy Stribling on 1/14/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPClientManager.h"
#import "MulticastDelegate.h"
#import "AccountModel.h"
#import "AccountModel.h"
#import "XMPPJID.h"

//-----------------------------------------------------------------------------------------------------------------------------------
static XMPPClientManager* thisXMPPClientManager = nil;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPClientManager (PrivateAPI)

- (void)addDelegatesToClient:(XMPPClient*)xmppClient;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPClientManager

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize accountUpdateDelegate;
@synthesize messageCountUpdateDelegate;
@synthesize xmppClientDictionary;
@synthesize delegates;

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
- (void)addAccountUpdateDelegate:(id)mcastDelegate {
	[self.accountUpdateDelegate addDelegate:mcastDelegate];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)removeAccountUpdateDelegate:(id)mcastDelegate  {
	[self.accountUpdateDelegate removeDelegate:mcastDelegate];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addMessageCountUpdateDelegate:(id)mcastDelegate {
	[self.messageCountUpdateDelegate addDelegate:mcastDelegate];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)removeMessageCountUpdateDelegate:(id)mcastDelegate  {
	[self.messageCountUpdateDelegate removeDelegate:mcastDelegate];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPClient*)xmppClientForAccount:(AccountModel*)account {
	return [self connectXmppClientForAccount:account];;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPClient*)connectXmppClientForAccount:(AccountModel*)account {
	XMPPClient* xmppClient = (XMPPClient*)[xmppClientDictionary valueForKey:[account fullJID]];
	if (xmppClient == nil) {
		xmppClient = [self createXMPPClientForAccount:account];
		[xmppClient connect];
		[xmppClientDictionary setValue:xmppClient forKey:[account fullJID]];
	}
	return xmppClient;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addDelegate:(id)del {
    [self.delegates addObject:del];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)delegateTo:(id)clientDelegate forAccount:(AccountModel*)account {
	XMPPClient* xmppClient = [self xmppClientForAccount:account];
    [xmppClient addDelegate:clientDelegate];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)removeXMPPClientForAccount:(AccountModel*)account {
	XMPPClient* xmppClient = (XMPPClient*)[xmppClientDictionary valueForKey:[account fullJID]];
	if (xmppClient) {
		if([xmppClient isConnected]) {
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
	[self addDelegatesToClient:xmppClient];
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
#pragma mark MessageModel PrivateApi

//----------------------------------------------------------------------------------------------------------------------------------
- (void)addDelegatesToClient:(XMPPClient*)xmppClient {
    for(int i = 0; i < [delegates count]; i++) {        
        [xmppClient addDelegate:[delegates objectAtIndex:i]];
    }
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    thisXMPPClientManager = self;
	self.xmppClientDictionary = [NSMutableDictionary dictionaryWithCapacity:10];
    self.delegates = [NSMutableArray arrayWithCapacity:10];
    self.accountUpdateDelegate = [[MulticastDelegate alloc] init];		
    self.messageCountUpdateDelegate = [[MulticastDelegate alloc] init];		
    return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
