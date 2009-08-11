//
//  XMPPClientVersionQuery.m
//  webgnosus
//
//  Created by Troy Stribling on 3/29/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "XMPPQuery.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@class XMPPClient;
@class XMPPIQ;
@class XMPPJID;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPClientVersionQuery : XMPPQuery 

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPClientVersionQuery*)createFromElement:(NSXMLElement*)element;
- (XMPPClientVersionQuery*)init;
- (XMPPClientVersionQuery*)initWithName:(NSString*)name andVersion:(NSString*)version;
- (XMPPClientVersionQuery*)initWithName:(NSString*)name version:(NSString*)version andOs:(NSString*)os;

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)clientName;
- (void)addClientName:(NSString*)val;

- (NSString*)clientVersion;
- (void)addClientVersion:(NSString*)val;

- (NSString*)clientOs;
- (void)addClientOs:(NSString*)val;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)get:(XMPPClient*)client JID:(XMPPJID*)jid;
+ (void)result:(XMPPClient*)client forIQ:(XMPPIQ*)iq;

@end
