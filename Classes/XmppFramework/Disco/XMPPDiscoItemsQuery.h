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
@class XMPPIQ;

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
+ (void)commands:(XMPPClient*)client forRequest:(XMPPIQ*)iq;
+ (void)itemNotFound:(XMPPClient*)client forRequest:iq;
+ (void)serviceUnavailable:(XMPPClient*)client forRequest:iq;
+ (void)notAllowed:(XMPPClient*)client forRequest:iq;
    
@end
