//
//  XMPPPubSubEvent.m
//  webgnosus
//
//  Created by Troy Stribling on 8/8/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPPubSubEvent.h"
#import "XMPPPubSubItems.h"
#import "NSXMLElementAdditions.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPPubSubEvent (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPPubSubEvent

//===================================================================================================================================
#pragma mark XMPPPubSubEvent PrivateAPI

//===================================================================================================================================
#pragma mark XMPPPubSubEvent

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPPubSubEvent*)createFromElement:(NSXMLElement*)element {
	XMPPPubSubEvent* result = (XMPPPubSubEvent*)element;
	result->isa = [XMPPPubSubEvent class];
	return result;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPPubSubEvent*)init {
	if(self = [super initWithName:@"event"]) {
        [self addNamespace:[NSXMLNode namespaceWithName:@"" stringValue:@"http://jabber.org/protocol/pubsub#event"]];
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)node {
    return [[[self elementForName:@"items"] attributeForName:@"node"] stringValue];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPPubSubItems*)items {
    XMPPPubSubItems* pubItems = nil;
    NSXMLElement* pubItemsElement = [self elementForName:@"items"];
    if (pubItemsElement) {
        pubItems = [XMPPPubSubItems createFromElement:pubItemsElement];
    }
    return pubItems;
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
