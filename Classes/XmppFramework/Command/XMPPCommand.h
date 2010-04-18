//
//  XMPPCommand.m
//  webgnosus
//
//  Created by Troy Stribling on 3/29/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "NSXMLElementAdditions.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@class XMPPxData;
@class XMPPClient;
@class XMPPJID;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPCommand : NSXMLElement 

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPCommand*)createFromElement:(NSXMLElement*)element;
- (XMPPCommand*)initWithNode:(NSString*)cmdNode;
- (XMPPCommand*)initWithNode:(NSString*)cmdNode andAction:(NSString*)cmdAction;
- (XMPPCommand*)initWithNode:(NSString*)cmdNode andData:(XMPPxData*)cmdData;
- (XMPPCommand*)initWithNode:(NSString*)cmdNode action:(NSString*)cmdAction andData:(XMPPxData*)cmdData;
- (XMPPCommand*)initWithNode:(NSString*)cmdNode action:(NSString*)cmdAction data:(XMPPxData*)cmdData andStatus:(NSString*)cmdStatus;

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)node;
- (void)addNode:(NSString*)val;

- (NSString*)action;
- (void)addAction:(NSString*)val;

- (NSString*)status;
- (void)addStatus:(NSString*)val;

- (XMPPxData*)data;
- (void)addData:(XMPPxData*)child;

- (NSString*)sessionID;
- (void)addSessionID:(NSString*)val;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)set:(XMPPClient*)client commandNode:(NSString*)node JID:(XMPPJID*)jid;
+ (void)set:(XMPPClient*)client commandNode:(NSString*)node JID:(XMPPJID*)jid andDelegateResponse:(id)responseDelegate;
+ (void)set:(XMPPClient*)client commandNode:(NSString*)node JID:(XMPPJID*)jid andSessionID:(NSString*)sessionID;
+ (void)set:(XMPPClient*)client commandNode:(NSString*)node JID:(XMPPJID*)jid sessionID:(NSString*)sessionID andDelegateResponse:(id)responseDelegate;
+ (void)set:(XMPPClient*)client commandNode:(NSString*)node withData:(XMPPxData*)data JID:(XMPPJID*)jid andSessionID:(NSString*)sessionID;
+ (void)set:(XMPPClient*)client commandNode:(NSString*)node withData:(XMPPxData*)data JID:(XMPPJID*)jid sessionID:(NSString*)sessionId andDelegateResponse:(id)responseDelegate;
+ (void)cancel:(XMPPClient*)client commandNode:(NSString*)node JID:(XMPPJID*)jid andSessionID:(NSString*)sessionID;

@end
