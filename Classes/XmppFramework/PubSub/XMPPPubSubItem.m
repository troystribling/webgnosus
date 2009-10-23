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
#import "XMPPEntry.h"

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
- (XMPPPubSubItem*)initWithId:(NSString*)initItemId {
    if(self = [super initWithName:@"item"]) {
        [self addItemId:initItemId];
    }
    return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)itemId {
    return [[self attributeForName:@"id"] stringValue];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addItemId:(NSString*)val {
    [self addAttributeWithName:@"id" stringValue:val];
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
- (XMPPEntry*)entry {
    XMPPEntry* entryData = nil;
    NSXMLElement* entryElement = [self elementForName:@"entry"];
    if (entryElement) {
        entryData = [XMPPEntry createFromElement:entryElement];
    }
    return entryData;
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
