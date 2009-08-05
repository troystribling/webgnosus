//
//  XMPPStanza.m
//  webgnosus
//
//  Created by Troy Stribling on 3/29/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "DDXML.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@class XMPPJID;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPStanza : NSXMLElement

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPStanza*)createFromElement:(NSXMLElement*)element;
- (XMPPStanza*)initWithName:(NSString*)stanzaName;
- (XMPPStanza*)initWithName:(NSString*)stanzaName andToJID:(NSString*)stanzaTo;
- (XMPPStanza*)initWithName:(NSString*)stanzaName andType:(NSString*)stanzaType;
- (XMPPStanza*)initWithName:(NSString*)stanzaName type:(NSString*)stanzaType andToJID:(NSString*)stanzaTo;

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)stanzaID;
- (void)addStanzaID:(NSString*)val;

- (NSString*)type;
- (void)addType:(NSString*)val;

- (XMPPJID*)toJID;
- (void)addToJID:(NSString*)val;

- (XMPPJID*)fromJID;
- (void)addFromJID:(NSString*)val;

@end
