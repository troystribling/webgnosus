//
//  XMPPPubSubOwner.h
//  webgnosus
//
//  Created by Troy Stribling on 8/8/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "NSXMLElementAdditions.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@class XMPPClient;
@class XMPPJID;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPPubSubOwner : NSXMLElement 

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPPubSubOwner*)createFromElement:(NSXMLElement*)element;
- (XMPPPubSubOwner*)init;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)delete:(XMPPClient*)client JID:(XMPPJID*)jid node:(NSString*)node;

@end
