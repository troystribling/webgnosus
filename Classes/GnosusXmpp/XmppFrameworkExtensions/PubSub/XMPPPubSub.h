//-----------------------------------------------------------------------------------------------------------------------------------
//
//  XMPPPubSub.h
//  webgnosus
//
//  Created by Troy Stribling on 8/8/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "NSXMLElementAdditions.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@class XMPPPubSubSubscriptions;
@class XMPPPubSubSubscription;
@class XMPPClient;
@class XMPPJID;
@class XMPPPubSubItems;
@class XMPPIQ;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPPubSub : NSXMLElement 

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPPubSub*)createFromElement:(NSXMLElement*)element;
+ (XMPPPubSub*)message;
- (XMPPPubSub*)init;

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSArray*)subscriptions;
- (void)addSubscription:(XMPPPubSubSubscriptions*)val;
- (XMPPPubSubSubscription*)subscription;
- (XMPPPubSubItems*)items;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)create:(XMPPClient*)client JID:(XMPPJID*)jid node:(NSString*)node;
+ (void)get:(XMPPClient*)client JID:(XMPPJID*)jid node:(NSString*)node withId:(NSString*)itemId;
+ (XMPPIQ*)buildPubSubIQWithJID:(XMPPJID*)jid node:(NSString*)node andData:(NSXMLElement*)data;

@end
