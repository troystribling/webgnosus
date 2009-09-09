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

//-----------------------------------------------------------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPPubSubItem

//-----------------------------------------------------------------------------------------------------------------------------------

//===================================================================================================================================
#pragma mark XMPPPubSubItem

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPPubSubItem*)createFromElement:(NSXMLElement*)element {
	XMPPPubSubItem* result = (XMPPPubSubItem*)element;
	result->isa = [XMPPPubSubItem class];
	return result;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPPubSubItem*)initWithData:(XMPPxData*)itemData {
	if(self = [super initWithName:@"item"]) {
        [self addNamespace:[NSXMLNode namespaceWithName:@"" stringValue:@"http://jabber.org/protocol/pubsub#event"]];
        [self addData:itemData];
	}
    return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPPubSubItem*)initWithData:(XMPPxData*)itemData andItemId:(NSInteger)itemId {
	if(self = [self initWithData:itemData]) {
        [self addItemId:itemId];
	}
    return self;
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

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
