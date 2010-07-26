//
//  XMPPPresence.m
//  webgnosus
//
//  Created by Troy Stribling on 3/29/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "XMPPStanza.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@class XMPPClient;
@class XMPPJID;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPPresence : XMPPStanza

//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPPresence*)createFromElement:(NSXMLElement*)element;
- (XMPPPresence*)initWithToJID:(NSString*)presenceTo;
- (XMPPPresence*)initWithType:(NSString*)presenceType;
- (XMPPPresence*)initWithPriority:(NSString*)presencePriority;
- (XMPPPresence*)initWithType:(NSString*)presenceType andPriority:(NSString*)presencePriority;
- (XMPPPresence*)initWithType:(NSString*)presenceType toJID:(NSString*)presenceTo;

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)show;
- (void)addShow:(NSString*)val;

- (NSString*)status;
- (void)addStatus:(NSString*)val;

- (int)priority;
- (void)addPriority:(NSString*)val;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)goOnline:(XMPPClient*)client withPriority:(NSInteger)priority;
+ (void)goOffline:(XMPPClient*)client;
+ (void)accept:(XMPPClient*)client JID:(XMPPJID*)jid;
+ (void)decline:(XMPPClient*)client JID:(XMPPJID*)jid;
+ (void)subscribe:(XMPPClient*)client JID:(XMPPJID*)jid;

@end
