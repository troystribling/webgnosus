//
//  XMPPMessage.m
//  webgnosus
//
//  Created by Troy Stribling on 3/29/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPMessage.h"
#import "XMPPPubSubEvent.h"
#import "XMPPClient.h"
#import "XMPPJID.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPMessage

//-----------------------------------------------------------------------------------------------------------------------------------

//===================================================================================================================================
#pragma mark XMPPMessage

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPMessage*)createFromElement:(NSXMLElement*)element {
	XMPPMessage *result = (XMPPMessage *)element;
	result->isa = [XMPPMessage class];
	return result;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPMessage*)initWithType:(NSString*)msgType toJID:(NSString*)msgTo andBody:(NSString*)msgBody {
	if(self = (XMPPMessage*)[super initWithName:@"message" type:msgType andToJID:msgTo]) {
        [self addBody:msgBody];
	}
    return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)body {
	return [[self elementForName:@"body"] stringValue];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addBody:(NSString*)val {
	[self addChild:[NSXMLElement elementWithName:@"body" stringValue:val]];	
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPPubSubEvent*)event {
    XMPPPubSubEvent* evt = nil;
    NSXMLElement* evtElement = [self elementForName:@"event"];
    if (evtElement) {
        evt = [XMPPPubSubEvent createFromElement:evtElement];
    }
    return evt;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addEvent:(XMPPPubSubEvent*)val {
    [self addChild:val];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)isChatMessage {
	return [[[self attributeForName:@"type"] stringValue] isEqualToString:@"chat"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)hasBody {
	if([self isChatMessage])
	{
		NSString *body = [[self elementForName:@"body"] stringValue];		
		return ((body != nil) && ([body length] > 0));
	}	
	return NO;
}

//===================================================================================================================================
#pragma mark XMPPMessage

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)chat:(XMPPClient*)client JID:(XMPPJID*)jid messageBody:(NSString*)body {
    XMPPMessage* msg = [[self alloc] initWithType:@"chat" toJID:[jid full] andBody:body];
	[client sendElement:msg];
    [msg release];
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
