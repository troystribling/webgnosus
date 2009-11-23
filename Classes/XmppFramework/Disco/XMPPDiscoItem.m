//
//  XMPPDiscoItem.m
//  webgnosus
//
//  Created by Troy Stribling on 8/4/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPDiscoItem.h"
#import "XMPPJID.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPDiscoItem

//-----------------------------------------------------------------------------------------------------------------------------------

//===================================================================================================================================
#pragma mark XMPPDiscoItem

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPDiscoItem*)createFromElement:(NSXMLElement*)element {
	XMPPDiscoItem* result = (XMPPDiscoItem*)element;
	result->isa = [XMPPDiscoItem class];
	return result;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPDiscoItem*)initWithJID:(NSString*)itemJID {
	if(self = [super initWithName:@"item"]) {
        [self addJID:itemJID];
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPDiscoItem*)initWithJID:(NSString*)itemJID andIname:(NSString*)itemIname {
	if([self initWithJID:itemJID]) {
        [self addIname:itemIname];
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPDiscoItem*)initWithJID:(NSString*)itemJID iname:(NSString*)itemIname andNode:(NSString*)itemNode {
	if([self initWithJID:itemJID andIname:itemIname]) {
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
- (NSString*)iname {
    return [[self attributeForName:@"name"] stringValue];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addIname:(NSString*)val {
    [self addAttributeWithName:@"name" stringValue:val];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPJID*)JID {
    return [XMPPJID jidWithString:[[self attributeForName:@"jid"] stringValue]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addJID:(NSString*)val {
    [self addAttributeWithName:@"jid" stringValue:val];
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
