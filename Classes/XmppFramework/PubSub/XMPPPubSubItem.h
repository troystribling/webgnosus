//
//  XMPPPubSubItem.h
//  webgnosus
//
//  Created by Troy Stribling on 8/8/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "NSXMLElementAdditions.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@class XMPPxData;
@class XMPPEntry;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPPubSubItem : NSXMLElement 

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPPubSubItem*)createFromElement:(NSXMLElement*)element;
- (XMPPPubSubItem*)initWithId:(NSString*)itemId;

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)itemId;
- (void)addItemId:(NSString*)val;
- (XMPPxData*)data;
- (XMPPEntry*)entry;

@end
