//
//  XMPPRosterQuery.m
//  webgnosus
//
//  Created by Troy Stribling on 3/29/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "XMPPQuery.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@class XMPPRosterItem;
@class XMPPClient;
@class XMPPJID;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPRosterQuery : XMPPQuery 

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPRosterQuery*)createFromElement:(NSXMLElement*)element;
- (XMPPRosterQuery*)init;

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSArray*)items;
- (void)addItem:(XMPPRosterItem*)val;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)get:(XMPPClient*)client;
+ (void)update:(XMPPClient*)client JID:(XMPPJID*)jid;
+ (void)remove:(XMPPClient*)client JID:(XMPPJID*)jid;

@end
