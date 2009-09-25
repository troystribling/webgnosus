//
//  XMPPPubSubPublish.m
//  webgnosus
//
//  Created by Troy Stribling on 8/8/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPPubSubPublish.h"
#import "XMPPPubSubItem.h"

//-----------------------------------------------------------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPPubSubPublish

//-----------------------------------------------------------------------------------------------------------------------------------

//===================================================================================================================================
#pragma mark XMPPPubSubPublish

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPPubSubPublish*)createFromElement:(NSXMLElement*)element {
	XMPPPubSubPublish* result = (XMPPPubSubPublish*)element;
	result->isa = [XMPPPubSubPublish class];
	return result;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPPubSubPublish*)initWithNode:(NSString*)itemNode {
	if(self = [super initWithName:@"publish"]) {
        [self addNamespace:[NSXMLNode namespaceWithName:@"" stringValue:@"http://jabber.org/protocol/pubsub"]];
        [self addNode:itemNode];
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
- (XMPPPubSubItem*)item {
    XMPPPubSubItem* pubItem = nil;
    NSXMLElement* pubItemElement = [self elementForName:@"item"];
    if (pubItemElement) {
        pubItem = [XMPPPubSubItem createFromElement:pubItemElement];
    }
    return pubItem;
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
