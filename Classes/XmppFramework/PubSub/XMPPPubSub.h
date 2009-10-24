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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPPubSub : NSXMLElement 

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPPubSub*)createFromElement:(NSXMLElement*)element;
- (XMPPPubSub*)init;

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSArray*)subscriptions;
- (void)addSubscription:(XMPPPubSubSubscriptions*)val;
- (XMPPPubSubSubscription*)subscription;
- (XMPPPubSubItems*)items;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)create:(XMPPClient*)client JID:(XMPPJID*)jid node:(NSString*)node;
+ (void)entry:(XMPPClient*)client JID:(XMPPJID*)jid node:(NSString*)node withTitle:(NSString*)title;
+ (void)get:(XMPPClient*)client JID:(XMPPJID*)jid node:(NSString*)node withId:(NSString*)itemId;

@end
