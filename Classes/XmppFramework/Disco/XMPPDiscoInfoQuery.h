//
//  XMPPDiscoInfoQuery.h
//  webgnosus
//
//  Created by Troy Stribling on 8/4/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "XMPPQuery.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@class XMPPDiscoFeature;
@class XMPPDiscoIdentity;
@class XMPPJID;
@class XMPPClient;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPDiscoInfoQuery : XMPPQuery 

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPDiscoInfoQuery*)createFromElement:(NSXMLElement*)element;
- (XMPPDiscoInfoQuery*)init;
- (XMPPDiscoInfoQuery*)initWithNode:(NSString*)itemsNode;

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)node;
- (void)addNode:(NSString*)val;

- (NSArray*)features;
- (void)addFeature:(XMPPDiscoFeature*)val;

- (NSArray*)identities;
- (void)addIdentity:(XMPPDiscoIdentity*)val;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)get:(XMPPClient*)client JID:(XMPPJID*)jid forTarget:(XMPPJID*)targetJID;
+ (void)get:(XMPPClient*)client JID:(XMPPJID*)jid node:(NSString*)node forTarget:(XMPPJID*)targetJID;
+ (void)get:(XMPPClient*)client JID:(XMPPJID*)jid node:(NSString*)node andDelegateResponse:(id)responseDelegate;
+ (void)features:(XMPPClient*)client toJID:(XMPPJID*)jid;
+ (void)itemNotFound:(XMPPClient*)client toJID:(XMPPJID*)jid andNode:(NSString*)itemNode;
+ (void)serviceUnavailable:(XMPPClient*)client toJID:(XMPPJID*)jid andNode:(NSString*)itemNode;
+ (void)itemNotFound:(XMPPClient*)client toJID:(XMPPJID*)jid;
+ (void)serviceUnavailable:(XMPPClient*)client toJID:(XMPPJID*)jid;
    
@end
