//
//  XMPPClientManager.h
//  webgnosus
//
//  Created by Troy Stribling on 1/14/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "XMPPClient.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@class AccountModel;
@class MulticastDelegate;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPClientManager : NSObject {
    MulticastDelegate* accountUpdateDelegate;
	NSMutableDictionary* xmppClientDictionary;
    NSMutableArray* delegates;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (retain) MulticastDelegate* accountUpdateDelegate;
@property (retain) NSMutableDictionary* xmppClientDictionary;
@property (retain) NSMutableArray* delegates;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPClientManager*)instance;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addAccountUpdateDelegate:(id)mcastDelegate;
- (void)removeAccountUpdateDelegate:(id)mcastDelegate;
- (void)addDelegate:(id)del;
- (XMPPClient*)xmppClientForAccount:(AccountModel*)account;
- (void)openConnectionForAccount:(AccountModel*)account;
- (XMPPClient*)xmppClientForAccount:(AccountModel*)account andDelegateTo:(id)clientDelegate;
- (XMPPClient*)createXMPPClientForAccount:(AccountModel*)account;
- (void)removeXMPPClientForAccount:(AccountModel*)account;
- (void)removeXMPPClientDelegate:(id)clientDelegate forAccount:(AccountModel*)account;

@end

//-----------------------------------------------------------------------------------------------------------------------------------
#pragma mark -
//-----------------------------------------------------------------------------------------------------------------------------------

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface NSObject (XMPPClientManagerAccountUpdateDelegate)

- (void)didAddAccount;
- (void)didRemoveAccount;
- (void)didUpdateAccount;

@end
