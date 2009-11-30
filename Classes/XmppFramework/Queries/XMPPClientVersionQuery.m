//
//  XMPPClientVersionQuery.m
//  webgnosus
//
//  Created by Troy Stribling on 3/29/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPClientVersionQuery.h"
#import "XMPPIQ.h"
#import "XMPPJID.h"
#import "XMPPClient.h"
#import "XMPPClientVersionQueryDeligate.h"
#import "NSXMLElementAdditions.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPClientVersionQuery

//-----------------------------------------------------------------------------------------------------------------------------------

//===================================================================================================================================
#pragma mark XMPPClientVersion

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPClientVersionQuery*)createFromElement:(NSXMLElement*)element {
	XMPPClientVersionQuery* result = (XMPPClientVersionQuery*)element;
	result->isa = [XMPPClientVersionQuery class];
	return result;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPClientVersionQuery*)init {
	if(self = (XMPPClientVersionQuery*)[super initWithXMLNS:@"jabber:iq:version"]) {
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPClientVersionQuery*)initWithName:(NSString*)name andVersion:(NSString*)version {
	if(self = [self init]) {
        [self addClientName:name];
        [self addClientVersion:version];
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPClientVersionQuery*)initWithName:(NSString*)name version:(NSString*)version andOs:(NSString*)os {
	if(self = [self init]) {
        [self addClientName:name];
        [self addClientVersion:version];
        [self addClientOs:os];
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)clientName {
    return [[self elementForName:@"name"] stringValue];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addClientName:(NSString*)val {
    [self addChild:[NSXMLElement elementWithName:@"name" stringValue:val]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)clientVersion {
    return [[self elementForName:@"version"] stringValue];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addClientVersion:(NSString*)val {
    [self addChild:[NSXMLElement elementWithName:@"version" stringValue:val]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)clientOs {
    return [[self elementForName:@"os"] stringValue];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addClientOs:(NSString*)val {
    [self addChild:[NSXMLElement elementWithName:@"os" stringValue:val]];
}

//===================================================================================================================================
#pragma mark XMPPClientVersionQuery Messages

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)get:(XMPPClient*)client JID:(XMPPJID*)jid {
    XMPPIQ* iq = [[XMPPIQ alloc] initWithType:@"get" toJID:[jid full]];
    [iq addQuery:[[self alloc] init]];
    [client send:iq andDelegateResponse:[[XMPPClientVersionQueryDeligate alloc] init]];
    [iq release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)result:(XMPPClient*)client forIQ:(XMPPIQ*)iq {
    XMPPClientVersionQuery* version = [[self alloc] initWithName:[NSString stringWithUTF8String:kAPP_NAME] version:[NSString stringWithUTF8String:kAPP_VERSION] andOs:[NSString stringWithUTF8String:kOS_VERSION]];
    XMPPIQ* responseIQ = [[XMPPIQ alloc] initWithType:@"result" toJID:[[iq fromJID] full]];
    [responseIQ addStanzaID:[iq stanzaID]];
    [responseIQ addQuery:version];
	[client sendElement:responseIQ];
    [responseIQ release];
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
