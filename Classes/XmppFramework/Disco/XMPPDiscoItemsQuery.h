//
//  XMPPDiscoItemsQuery.h
//  webgnosus
//
//  Created by Troy Stribling on 8/4/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "XMPPQuery.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@class XMPPDiscoItem;
@class XMPPJID;
@class XMPPClient;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPDiscoItemsQuery : XMPPQuery

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPDiscoItemsQuery*)createFromElement:(NSXMLElement*)element;
- (XMPPDiscoItemsQuery*)initWithNode:(NSString*)itemsNode;

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)node;
- (void)addNode:(NSString*)val;

- (NSArray*)items;
- (void)addItem:(XMPPDiscoItem*)val;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)get:(XMPPClient*)client JID:(XMPPJID*)jid forTarget:(XMPPJID*)targetJID;
+ (void)get:(XMPPClient*)client JID:(XMPPJID*)jid andNode:(NSString*)node;
+ (void)get:(XMPPClient*)client JID:(XMPPJID*)jid node:(NSString*)node forTarget:(XMPPJID*)targetJID;
+ (void)get:(XMPPClient*)client JID:(XMPPJID*)jid node:(NSString*)node andDelegateResponse:(id)responseDelegate;
+ (void)commands:(XMPPClient*)client toJID:(XMPPJID*)jid;
+ (void)itemNotFound:(XMPPClient*)client toJID:(XMPPJID*)jid andNode:(NSString*)itemNode;
+ (void)serviceUnavailable:(XMPPClient*)client toJID:(XMPPJID*)jid andNode:(NSString*)itemNode;
+ (void)notAllowed:(XMPPClient*)client toJID:(XMPPJID*)jid andNode:(NSString*)itemNode;
+ (void)itemNotFound:(XMPPClient*)client toJID:(XMPPJID*)jid;
+ (void)serviceUnavailable:(XMPPClient*)client toJID:(XMPPJID*)jid;
+ (void)notAllowed:(XMPPClient*)client toJID:(XMPPJID*)jid;
    
@end
