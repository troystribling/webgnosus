//
//  XMPPMessageDelegate.h
//  webgnosus
//
//  Created by Troy Stribling on 8/11/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "NSXMLElementAdditions.h"
#import "AccountModel.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@class XMPPClient;
@class AccountModel;
@class XMPPJID;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPMessageDelegate : NSObject {
}

//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
+ (AccountModel*)accountForXMPPClient:(XMPPClient*)client;
+ (void)updateAccountConnectionState:(AccountConnectionState)title forClient:(XMPPClient*)client;
+ (NSString*)userPubSubRoot:(XMPPClient*)client;

+ (void)removeContact:(XMPPClient*)client JID:(XMPPJID*)contactJid;
+ (void)addContact:(XMPPClient*)client JID:(XMPPJID*)contactJid;

+ (void)acceptBuddyRequest:(XMPPClient*)client JID:(XMPPJID*)buddyJid;
+ (void)addBuddy:(XMPPClient*)client JID:(XMPPJID*)buddyJid;

@end
