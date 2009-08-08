//
//  XMPPPubSubItem.m
//  webgnosus
//
//  Created by Troy Stribling on 8/8/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPPubSubItem.h"
#import "XMPPxData.h"
#import "NSXMLElementAdditions.h"

//-----------------------------------------------------------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPPubSubItem

//-----------------------------------------------------------------------------------------------------------------------------------

//===================================================================================================================================
#pragma mark XMPPDiscoItem

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPPubSubItem*)createFromElement:(NSXMLElement*)element {
	XMPPPubSubItem* result = (XMPPPubSubItem*)element;
	result->isa = [XMPPPubSubItem class];
	return result;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPPubSubItem*)initWithData:(XMPPxData*)itemData {
	if(self = [super initWithName:@"item"]) {
        [self addNamespace:[NSXMLNode namespaceWithName:@"" stringValue:@"http://jabber.org/protocol/pubsub#event"]]
        [self addData:itemData];
	}
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPPubSubItem*)initWithData:(XMPPxData*)itemData andItemId:(NSInteger)itemId {
	if(self = [super initWithData:itemData]) {
        [self addItemId:itemData];
	}
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)itemId {
    return [[[self attributeForName:@"id"] stringValue] integerValue];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addItemId:(NSInteger)val {
    [self addAttributeWithName:@"id" stringValue:[NSString stringWithFormat:@"%d", val]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPxData*)data {
    XMPPxData* xData = nil;
    NSXMLElement* xElement = [self elementForName:@"x"];
    if (xElement) {
        xData = [XMPPxData createFromElement:xElement];
    }
    return xData;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addData:(XMPPxData*)child {
    [self addChild:child];
}

@end
