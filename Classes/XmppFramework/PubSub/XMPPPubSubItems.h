//
//  XMPPPubSubItems.h
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
@interface XMPPPubSubItems : NSXMLElement 

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPPubSubItems*)createFromElement:(NSXMLElement*)element;
- (XMPPPubSubItems*)initWithNode:(NSString*)itemNode;
- (XMPPPubSubItems*)initWithNode:(NSString*)itemNode andSubId:(NSInteger)itemSubId;
- (XMPPPubSubItems*)initWithNode:(NSString*)itemNode andSubId:(NSInteger)itemSubId andMaxItems:(NSInteger)itemMaxItems;

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)node;
- (void)addNode:(NSString*)val;

- (NSInteger)subId;
- (void)addSubId:(NSInteger)val;

- (NSInteger)maxItems;
- (void)addMaxItems:(NSInteger)val;

- (NSArray*)toArray;
- (void)addItem:(XMPPPubSubItem*)val;

@end
