//
//  XMPPPubSubSubscriptions.h
//  webgnosus
//
//  Created by Troy Stribling on 8/8/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "NSXMLElementAdditions.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@class XMPPPubSubSubscription;
@class XMPPClient;
@class XMPPJID;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPPubSubSubscriptions : NSXMLElement 

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPPubSubSubscriptions*)createFromElement:(NSXMLElement*)element;

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSArray*)subscriptions;
- (void)addSubscription:(XMPPPubSubSubscription*)val;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)get:(XMPPClient*)client JID:(XMPPJID*)jid;
+ (void)subscribe:(XMPPClient*)client JID:(XMPPJID*)jid node:(NSString*)node;
+ (void)unsubscribe:(XMPPClient*)client JID:(XMPPJID*)jid node:(NSString*)node andSubId:(NSString*)subId;

@end
