//
//  XMPPPubSubOwner.m
//  webgnosus
//
//  Created by Troy Stribling on 8/8/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPPubSubOwner.h"
#import "XMPPClient.h"
#import "XMPPJID.h"
#import "XMPPIQ.h"
#import "XMPPPubSubDeleteDelegate.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPPubSubOwner

//===================================================================================================================================
#pragma mark XMPPPubSubOwner

//-----------------------------------------------------------------------------------------------------------------------------------

//===================================================================================================================================
#pragma mark XMPPPubSubOwner

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPPubSubOwner*)createFromElement:(NSXMLElement*)element {
    XMPPPubSubOwner* result = (XMPPPubSubOwner*)element;
    result->isa = [XMPPPubSubOwner class];
    return result;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPPubSubOwner*)init {
	if(self = [super initWithName:@"pubsub"]) {
        [self addNamespace:[NSXMLNode namespaceWithName:@"" stringValue:@"http://jabber.org/protocol/pubsub#owner"]];
	}
	return self;
}

//===================================================================================================================================
#pragma mark XMPPPubSubOwner Messages

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)delete:(XMPPClient*)client JID:(XMPPJID*)jid node:(NSString*)node {
    XMPPIQ* iq = [[XMPPIQ alloc] initWithType:@"set" toJID:[jid full]];
    XMPPPubSubOwner* pubsub = [[XMPPPubSubOwner alloc] init];
    NSXMLElement* deleteElement = [NSXMLElement elementWithName:@"delete"];
    [deleteElement addAttributeWithName:@"node" stringValue:node];
    [pubsub addChild:deleteElement];	
    [iq addPubSubOwner:pubsub];    
    [client send:iq andDelegateResponse:[[XMPPPubSubDeleteDelegate alloc] init:node]];
    [iq release];
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
