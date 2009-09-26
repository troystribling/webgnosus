//
//  XMPPPubSubSubscription.h
//  webgnosus
//
//  Created by Troy Stribling on 8/8/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "NSXMLElementAdditions.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@class XMPPJID;
@class XMPPClient;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPPubSubSubscription : NSXMLElement 

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPPubSubSubscription*)createFromElement:(NSXMLElement*)element;

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)node;
- (void)addNode:(NSString*)val;

- (NSString*)subscription;
- (void)addsubScription:(NSString*)val;

- (NSString*)subId;
- (void)addSubId:(NSString*)val;

- (XMPPJID*)JID;
- (void)addJID:(NSString*)val;

@end
