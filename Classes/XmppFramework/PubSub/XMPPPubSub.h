//-----------------------------------------------------------------------------------------------------------------------------------
//
//  XMPPPubSub.h
//  webgnosus
//
//  Created by Troy Stribling on 8/8/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSXMLElementAdditions.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@class XMPPPubSubSubscriptions;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPPubSub : NSXMLElement 

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPPubSub*)createFromElement:(NSXMLElement*)element;
- (XMPPPubSub*)init;

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSArray*)subscriptions;
- (void)addSubscription:(XMPPPubSubSubscriptions*)val;

@end
