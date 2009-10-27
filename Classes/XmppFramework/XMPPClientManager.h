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
    MulticastDelegate* messageCountUpdateDelegate;
	NSMutableDictionary* xmppClientDictionary;
    NSMutableArray* delegates;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (retain) MulticastDelegate* accountUpdateDelegate;
@property (retain) MulticastDelegate* messageCountUpdateDelegate;
@property (retain) NSMutableDictionary* xmppClientDictionary;
@property (retain) NSMutableArray* delegates;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPClientManager*)instance;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addAccountUpdateDelegate:(id)mcastDelegate;
- (void)removeAccountUpdateDelegate:(id)mcastDelegate;
- (void)addMessageCountUpdateDelegate:(id)mcastDelegate;
- (void)removeMessageCountUpdateDelegate:(id)mcastDelegate;
- (void)addDelegate:(id)del;
- (XMPPClient*)xmppClientForAccount:(AccountModel*)account;
- (XMPPClient*)connectXmppClientForAccount:(AccountModel*)account;
- (void)delegateTo:(id)clientDelegate forAccount:(AccountModel*)account;
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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface NSObject (XMPPClientManagerMessageCountUpdateDelegate)

- (void)messageCountDidChange;

@end
