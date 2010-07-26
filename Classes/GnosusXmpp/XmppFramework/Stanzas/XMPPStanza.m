//
//  XMPPStanza.m
//  webgnosus
//
//  Created by Troy Stribling on 3/29/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPStanza.h"
#import "XMPPJID.h"
#import "NSXMLElementAdditions.h"

//-----------------------------------------------------------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPStanza

//-----------------------------------------------------------------------------------------------------------------------------------

//===================================================================================================================================
#pragma mark XMPPStanza

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPStanza*)createFromElement:(NSXMLElement*)element {
	XMPPStanza* result = (XMPPStanza*)element;
	result->isa = [XMPPStanza class];
	return result;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPStanza*)initWithName:(NSString*)stanzaName {
	if(self = [super initWithName:stanzaName]) {
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPStanza*)initWithName:(NSString*)stanzaName andType:(NSString*)stanzaType {
	if(self = [super initWithName:stanzaName]) {
		[self addType:stanzaType];
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPStanza*)initWithName:(NSString*)stanzaName andToJID:(NSString*)stanzaTo {
	if(self = [super initWithName:stanzaName]) {
		[self addToJID:stanzaTo];
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPStanza*)initWithName:(NSString*)stanzaName type:(NSString*)stanzaType andToJID:(NSString*)stanzaTo {
	if([self initWithName:stanzaName andType:stanzaType]) {
		[self addToJID:stanzaTo];
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)stanzaID {
    return [[self attributeForName:@"id"] stringValue];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addStanzaID:(NSString*)val {
    [self addAttributeWithName:@"id" stringValue:val];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)type {
    return [[self attributeForName:@"type"] stringValue];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addType:(NSString*)val {
    [self addAttributeWithName:@"type" stringValue:val];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPJID*)toJID {
    return [XMPPJID jidWithString:[[self attributeForName:@"to"] stringValue]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addToJID:(NSString*)val {
    [self addAttributeWithName:@"to" stringValue:val];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPJID*)fromJID {
    return [XMPPJID jidWithString:[[self attributeForName:@"from"] stringValue]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addFromJID:(NSString*)val {
    [self addAttributeWithName:@"from" stringValue:val];
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
