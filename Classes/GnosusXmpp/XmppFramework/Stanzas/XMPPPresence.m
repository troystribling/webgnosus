//
//  XMPPPresence.m
//  webgnosus
//
//  Created by Troy Stribling on 3/29/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPPresence.h"
#import "XMPPClient.h"
#import "XMPPJID.h"
#import "NSXMLElementAdditions.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPPresence

//-----------------------------------------------------------------------------------------------------------------------------------

//===================================================================================================================================
#pragma mark XMPPPresence

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPPresence*)createFromElement:(NSXMLElement *)element {
	XMPPPresence *result = (XMPPPresence *)element;
	result->isa = [XMPPPresence class];
	return result;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPPresence*)initWithToJID:(NSString*)presenceTo {
	if(self = (XMPPPresence*)[super initWithName:@"presence" andToJID:presenceTo]) {
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPPresence*)init {
	if(self = (XMPPPresence*)[super initWithName:@"presence"]) {
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPPresence*)initWithType:(NSString*)presenceType {
	if(self = (XMPPPresence*)[super initWithName:@"presence" andType:presenceType]) {
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPPresence*)initWithPriority:(NSString*)presencePriority {
	if([self init]) {
        [self addPriority:presencePriority];
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPPresence*)initWithType:(NSString*)presenceType toJID:(NSString*)presenceTo {
	if(self = (XMPPPresence*)[super initWithName:@"presence" type:presenceType andToJID:presenceTo]) {
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPPresence*)initWithType:(NSString*)presenceType andPriority:(NSString*)presencePriority {
	if([self initWithType:presenceType]) {
        [self addPriority:presencePriority];
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString *)show {
	return [[self elementForName:@"show"] stringValue];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addShow:(NSString*)val {
	[self addChild:[NSXMLElement elementWithName:@"show" stringValue:val]];	
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString *)status {
	return [[self elementForName:@"status"] stringValue];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addStatus:(NSString*)val {
	[self addChild:[NSXMLElement elementWithName:@"status" stringValue:val]];	
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (int)priority {
	return [[[self elementForName:@"priority"] stringValue] intValue];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addPriority:(NSString*)val {
	[self addChild:[NSXMLElement elementWithName:@"priority" stringValue:val]];	
}

//===================================================================================================================================
#pragma mark XMPPPresence Messages

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)goOnline:(XMPPClient*)client withPriority:(NSInteger)priority {
	[client sendElement:[[XMPPPresence alloc] initWithPriority:[NSString stringWithFormat:@"%i", priority]]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)goOffline:(XMPPClient*)client {
	[client sendElement:[[XMPPPresence alloc] initWithType:@"unavailable"]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)accept:(XMPPClient*)client JID:(XMPPJID*)jid {
    [client sendElement:[[XMPPPresence alloc] initWithType:@"subscribed" toJID:[jid bare]]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)decline:(XMPPClient*)client JID:(XMPPJID*)jid{
    [client sendElement:[[XMPPPresence alloc] initWithType:@"unsubscribed" toJID:[jid bare]]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)subscribe:(XMPPClient*)client JID:(XMPPJID*)jid {
    [client sendElement:[[XMPPPresence alloc] initWithType:@"subscribe" toJID:[jid bare]]];
}


//===================================================================================================================================
#pragma mark XMPPStanza

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString *)type {
    NSString* type = [[self attributeForName:@"type"] stringValue];
    if(type)
        return type;
    else
        return @"available";
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
