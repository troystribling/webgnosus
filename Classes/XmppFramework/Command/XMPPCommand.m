//
//  XMPPCommand.m
//  webgnosus
//
//  Created by Troy Stribling on 3/29/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPCommand.h"
#import "XMPPxData.h"
#import "XMPPClient.h"
#import "XMPPJID.h"
#import "XMPPIQ.h"
#import "XMPPCommandDelegate.h"

//-----------------------------------------------------------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPCommand

//-----------------------------------------------------------------------------------------------------------------------------------

//===================================================================================================================================
#pragma mark XMPPCommand

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPCommand*)createFromElement:(NSXMLElement*)element {
	XMPPCommand* result = (XMPPCommand*)element;
	result->isa = [XMPPCommand class];
	return result;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPCommand*)initWithNode:(NSString*)cmdNode {
	if(self = [super initWithName:@"command"]) {
        [self addNamespace:[NSXMLNode namespaceWithName:@"" stringValue:@"http://jabber.org/protocol/commands"]];
        [self addNode:cmdNode];
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPCommand*)initWithNode:(NSString*)cmdNode andAction:(NSString*)cmdAction {
	if([self initWithNode:cmdNode]) {
        [self addAction:cmdAction];
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPCommand*)initWithNode:(NSString*)cmdNode andData:(XMPPxData*)cmdData {
	if([self initWithNode:cmdNode]) {
        [self addData:cmdData];
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPCommand*)initWithNode:(NSString*)cmdNode action:(NSString*)cmdAction andData:(XMPPxData*)cmdData {
	if([self initWithNode:cmdNode andAction:cmdAction]) {
        [self addData:cmdData];
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPCommand*)initWithNode:(NSString*)cmdNode action:(NSString*)cmdAction data:(XMPPxData*)cmdData andStatus:(NSString*)cmdStatus {
	if([self initWithNode:cmdNode action:cmdAction andData:cmdData]) {
        [self addStatus:cmdStatus];
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
- (NSString*)status {
    return [[self attributeForName:@"status"] stringValue];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addStatus:(NSString*)val {
    [self addAttributeWithName:@"status" stringValue:val];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)sessionID {
    return [[self attributeForName:@"sessionid"] stringValue];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addSessionID:(NSString*)val {
    [self addAttributeWithName:@"sessionid" stringValue:val];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)action {
    return [[self attributeForName:@"action"] stringValue];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addAction:(NSString*)val {
    [self addAttributeWithName:@"action" stringValue:val];
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
#pragma mark XMPPCommand Messages

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)set:(XMPPClient*)client commandNode:(NSString*)node JID:(XMPPJID*)jid {
    [self set:client commandNode:node JID:jid andDelegateResponse:[[XMPPCommandDelegate alloc] init]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)set:(XMPPClient*)client commandNode:(NSString*)node JID:(XMPPJID*)jid andDelegateResponse:(id)responseDelegate {
    XMPPIQ* iq = [[XMPPIQ alloc] initWithType:@"set" toJID:[jid full]];
    XMPPCommand* cmd = [[XMPPCommand alloc] initWithNode:node andAction:@"execute"];
    [iq addCommand:cmd];
    [client send:iq andDelegateResponse:responseDelegate];
    [iq release]; 
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)set:(XMPPClient*)client commandNode:(NSString*)node JID:(XMPPJID*)jid andSessionID:(NSString*)sessionID {
    [self set:client commandNode:node JID:jid sessionID:sessionID andDelegateResponse:[[XMPPCommandDelegate alloc] init]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)set:(XMPPClient*)client commandNode:(NSString*)node JID:(XMPPJID*)jid sessionID:(NSString*)sessionID andDelegateResponse:(id)responseDelegate {
    XMPPIQ* iq = [[XMPPIQ alloc] initWithType:@"set" toJID:[jid full]];
    XMPPCommand* cmd = [[XMPPCommand alloc] initWithNode:node andAction:@"execute"];
    if (sessionID) {
        [cmd addSessionID:sessionID];
    }
    [iq addCommand:cmd];
    [client send:iq andDelegateResponse:responseDelegate];
    [iq release]; 
}


//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)set:(XMPPClient*)client commandNode:(NSString*)node withData:(XMPPxData*)data JID:(XMPPJID*)jid andSessionID:(NSString*)sessionID {
    [self set:client commandNode:node withData:data JID:jid sessionID:sessionID andDelegateResponse:[[XMPPCommandDelegate alloc] init]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)set:(XMPPClient*)client commandNode:(NSString*)node withData:(XMPPxData*)data JID:(XMPPJID*)jid sessionID:(NSString*)sessionID andDelegateResponse:(id)responseDelegate {
    XMPPIQ* iq = [[XMPPIQ alloc] initWithType:@"set" toJID:[jid full]];
    XMPPCommand* cmd = [[XMPPCommand alloc] initWithNode:node andData:data];
    if (sessionID) {
        [cmd addSessionID:sessionID];
    }
    [iq addCommand:cmd];
    [client send:iq andDelegateResponse:responseDelegate];
    [iq release]; 
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)cancel:(XMPPClient*)client commandNode:(NSString*)node JID:(XMPPJID*)jid andSessionID:(NSString*)sessionID {
    XMPPIQ* iq = [[XMPPIQ alloc] initWithType:@"set" toJID:[jid full]];
        XMPPCommand* cmd = [[XMPPCommand alloc] initWithNode:node andAction:@"cancel"];
    if (sessionID) {
        [cmd addSessionID:sessionID];
    }
    [iq addCommand:cmd];
    [client send:iq andDelegateResponse:[[XMPPCommandDelegate alloc] init]];
    [iq release]; 
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
