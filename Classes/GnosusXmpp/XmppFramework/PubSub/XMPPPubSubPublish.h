//
//  XMPPPubSubPublish.h
//  webgnosus
//
//  Created by Troy Stribling on 8/8/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "NSXMLElementAdditions.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@class XMPPPubSubItem;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPPubSubPublish : NSXMLElement 

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPPubSubPublish*)createFromElement:(NSXMLElement*)element;
- (XMPPPubSubPublish*)initWithNode:(NSString*)itemNode;

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)node;
- (void)addNode:(NSString*)val;

- (XMPPPubSubItem*)item;
- (void)addItem:(XMPPPubSubItem*)val;


@end
