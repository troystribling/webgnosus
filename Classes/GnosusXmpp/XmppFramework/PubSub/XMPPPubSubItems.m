//
//  XMPPPubSubItems.m
//  webgnosus
//
//  Created by Troy Stribling on 8/8/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPPubSubItems.h"
#import "XMPPPubSubItem.h"

//-----------------------------------------------------------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPPubSubItems

//-----------------------------------------------------------------------------------------------------------------------------------

//===================================================================================================================================
#pragma mark XMPPPubSubItems

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPPubSubItems*)createFromElement:(NSXMLElement*)element {
	XMPPPubSubItems* result = (XMPPPubSubItems*)element;
	result->isa = [XMPPPubSubItems class];
	return result;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPPubSubItems*)initWithNode:(NSString*)itemNode {
	if(self = [super initWithName:@"items"]) {
        [self addNode:itemNode];
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPPubSubItems*)initWithNode:(NSString*)itemNode andSubId:(NSInteger)itemSubId {
	if([self initWithNode:itemNode]) {
        [self addSubId:itemSubId];
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPPubSubItems*)initWithNode:(NSString*)itemNode andSubId:(NSInteger)itemSubId andMaxItems:(NSInteger)itemMaxItems {
	if([self initWithNode:itemNode andSubId:itemSubId]) {
        [self addMaxItems:itemMaxItems];
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)node {
    return [[self attributeForName:@"node"] stringValue];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addNode:(NSString*)val {
    [self addAttributeWithName:@"node" stringValue:val];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)subId {
    return [[[self attributeForName:@"subid"] stringValue] integerValue];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addSubId:(NSInteger)val {
    [self addAttributeWithName:@"subid" stringValue:[NSString stringWithFormat:@"%d'", val]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)maxItems {
    return [[[self attributeForName:@"max_items"] stringValue] integerValue];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addMaxItems:(NSInteger)val {
    [self addAttributeWithName:@"max_items" stringValue:[NSString stringWithFormat:@"%d'", val]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSArray*)toArray {
    return [self elementsForName:@"item"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addItem:(XMPPPubSubItem*)val {
    [self addChild:val];
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
