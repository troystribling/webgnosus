//
//  XMPPMessage.m
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
@class XMPPPubSubEvent;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPMessage : XMPPStanza

//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPMessage*)createFromElement:(NSXMLElement*)element;
- (XMPPMessage*)initWithType:(NSString*)msgType toJID:(NSString*)msgTo andBody:(NSString*)msgBody;

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)body;
- (void)addBody:(NSString*)val;

- (XMPPPubSubEvent*)event;
- (void)addEvent:(XMPPPubSubEvent*)val;

- (BOOL)isChatMessage;
- (BOOL)hasBody;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)chat:(XMPPClient*)client JID:(XMPPJID*)jid messageBody:(NSString*)body;

@end
