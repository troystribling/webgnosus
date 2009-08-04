//
//  XMPPClientManager.h
//  webgnosus_client
//
//  Created by Troy Stribling on 1/14/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "XMPPClient.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@class AccountModel;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPClientManager : NSObject {
	NSMutableDictionary* xmppClientDictionary;
	id delegate;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (retain) NSMutableDictionary* xmppClientDictionary;
@property (retain) id delegate;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPClientManager*)instance;

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPClient*)xmppClientForAccount:(AccountModel*)account;
- (void)openConnectionForAccount:(AccountModel*)account;
- (XMPPClient*)xmppClientForAccount:(AccountModel*)account andDelegateTo:(id)clientDelegate;
- (XMPPClient*)createXMPPClientForAccount:(AccountModel*)account;
- (void)removeXMPPClientForAccount:(AccountModel*)account;
- (void)removeXMPPClientDelegate:(id)clientDelegate forAccount:(AccountModel*)account;

@end
