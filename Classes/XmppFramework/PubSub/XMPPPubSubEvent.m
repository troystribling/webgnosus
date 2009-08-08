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

//-----------------------------------------------------------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPPubSubEvent

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPPubSubEvent*)createFromElement:(NSXMLElement*)element {
	XMPPPubSubEvent* result = (XMPPPubSubEvent*)element;
	result->isa = [XMPPPubSubEvent class];
	return result;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSArray*)items {
    return [self elementsForName:@"items"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addItems:(XMPPPubSubItems*)val {
    [self addChild:val];
}

@end
