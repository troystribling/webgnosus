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
    XMPPIQ* iq = [[XMPPIQ alloc] initWithType:@"get"];
    [iq addQuery:[[self alloc] init]];
    [client sendElement:iq];
    [iq release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)update:(XMPPClient*)client JID:(XMPPJID*)jid {
    XMPPRosterQuery* query = [[XMPPRosterQuery alloc] init];
    [query addItem:[[XMPPRosterItem alloc] initWithJID:[jid bare]]];
    XMPPIQ* iq = [[XMPPIQ alloc] initWithType:@"set"];
    [iq addQuery:query];
    [client sendElement:iq];
    [iq release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)remove:(XMPPClient*)client JID:(XMPPJID*)jid {
    XMPPRosterQuery* query = [[XMPPRosterQuery alloc] init];
    [query addItem:[[XMPPRosterItem alloc] initWithJID:[jid bare] andSubscription:@"remove"]];
    XMPPIQ* iq = [[XMPPIQ alloc] initWithType:@"set"];
    [iq addQuery:query];
    [client sendElement:iq];
    [iq release];
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
