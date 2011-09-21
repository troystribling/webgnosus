//
//  XMPPRosterQuery.m
//  webgnosus
//
//  Created by Troy Stribling on 3/29/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPRosterQuery.h"
#import "XMPPRosterItem.h"
#import "XMPPClient.h"
#import "XMPPJID.h"
#import "XMPPIQ.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPRosterQuery

//-----------------------------------------------------------------------------------------------------------------------------------

//===================================================================================================================================
#pragma mark XMPPRosterQuery

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPRosterQuery*)createFromElement:(NSXMLElement*)element {
	XMPPRosterQuery* result = (XMPPRosterQuery*)element;
	result->isa = [XMPPRosterQuery class];
	return result;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPRosterQuery*)message {
    return [[[XMPPRosterQuery alloc] init] autorelease];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPRosterQuery*)init {
	if(self = (XMPPRosterQuery*)[super initWithXMLNS:@"jabber:iq:roster"]) {
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSArray*)items {
    return [self elementsForName:@"item"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addItem:(XMPPRosterItem*)val {
    [self addChild:val];
}

//===================================================================================================================================
#pragma mark XMPPRosterQuery Messages

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)get:(XMPPClient*)client {
    XMPPIQ* iq = [XMPPIQ messageWithType:@"get"];
    [iq addQuery:[self message]];
    [client sendElement:iq];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)update:(XMPPClient*)client JID:(XMPPJID*)jid {
    XMPPRosterQuery* query = [self message];
    [query addItem:[XMPPRosterItem messageWithJID:[jid bare]]];
    XMPPIQ* iq = [XMPPIQ messageWithType:@"set"];
    [iq addQuery:query];
    [client sendElement:iq];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)remove:(XMPPClient*)client JID:(XMPPJID*)jid {
    XMPPRosterQuery* query = [self message];
    [query addItem:[XMPPRosterItem messageWithJID:[jid bare] andSubscription:@"remove"]];
    XMPPIQ* iq = [XMPPIQ messageWithType:@"set"];
    [iq addQuery:query];
    [client sendElement:iq];
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
