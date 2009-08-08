//
//  XMPPPubSubItem.h
//  webgnosus
//
//  Created by Troy Stribling on 8/8/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "DDXML.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@class XMPPxData;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPPubSubItem : NSXMLElement 

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPPubSubItem*)createFromElement:(NSXMLElement*)element;
- (XMPPPubSubItem*)initWithData:(XMPPxData*)itemData;
- (XMPPPubSubItem*)initWithData:(XMPPxData*)itemData andItemId:(NSInteger)itemId;

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)itemId;
- (void)addItemId:(NSInteger)val;

- (XMPPxData*)data;
- (void)addData:(XMPPxData*)child;

@end
