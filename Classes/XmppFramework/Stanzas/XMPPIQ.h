//
//  XMPPIQ.m
//  webgnosus
//
//  Created by Troy Stribling on 3/29/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "XMPPStanza.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@class XMPPQuery;
@class XMPPSession;
@class XMPPBind;
@class XMPPCommand;
@class XMPPError;
@class XMPPPubSub;
@class XMPPPubSubOwner;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPIQ : XMPPStanza

//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPIQ*)createFromElement:(NSXMLElement *)element;
- (XMPPIQ*)initWithType:(NSString*)iqType;
- (XMPPIQ*)initWithType:(NSString*)iqType toJID:(NSString*)iqTo;
- (XMPPIQ*)initWithType:(NSString*)iqType toJID:(NSString*)iqTo andId:(NSString*)iqId;

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPQuery*)query;
- (void)addQuery:(XMPPQuery*)child;

- (XMPPSession*)session;
- (void)addSession:(XMPPSession*)child;

- (XMPPBind*)bind;
- (void)addBind:(XMPPBind*)child;

- (XMPPCommand*)command;
- (void)addCommand:(XMPPCommand*)child;

- (XMPPError*)error;
- (void)addError:(XMPPError*)val;

- (XMPPPubSub*)pubsub;
- (void)addPubSub:(XMPPPubSub*)child;
- (void)addPubSubOwner:(XMPPPubSubOwner*)child;

@end
