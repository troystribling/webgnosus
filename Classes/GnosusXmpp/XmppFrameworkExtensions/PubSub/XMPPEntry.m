//
//  XMPPEntry.m
//  webgnosus
//
//  Created by Troy Stribling on 10/2/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPEntry.h"
#import "XMPPClient.h"
#import "XMPPJID.h"
#import "XMPPIQ.h"
#import "XMPPPubSub.h"
#import "XMPPPubSubEntryDelegate.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPEntry

//===================================================================================================================================
#pragma mark XMPPEntry

//-----------------------------------------------------------------------------------------------------------------------------------

//===================================================================================================================================
#pragma mark XMPPEntry

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPEntry*)createFromElement:(NSXMLElement*)element {
    XMPPEntry* result = (XMPPEntry*)element;
    result->isa = [XMPPEntry class];
    return result;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPEntry*)messageWithTitle:(NSString*)msgTitle {
    return [[[XMPPEntry alloc] initWithName:msgTitle] autorelease];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPEntry*)init {
	if(self = [super initWithName:@"entry"]) {
        [self addNamespace:[NSXMLNode namespaceWithName:@"" stringValue:@"http://www.w3.org/2005/Atom"]];
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPEntry*)initWithTitle:(NSString*)msgTitle {
	if(self = [self init]) {
        [self addTitle:msgTitle];
	}
    return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)title {
	return [[self elementForName:@"title"] stringValue];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addTitle:(NSString*)val {
	[self addChild:[NSXMLElement elementWithName:@"title" stringValue:val]];	
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)publish:(XMPPClient*)client JID:(XMPPJID*)jid node:(NSString*)node withTitle:(NSString*)title {
    XMPPEntry* entry = [XMPPEntry messageWithTitle:title];
    XMPPIQ* iq = [XMPPPubSub buildPubSubIQWithJID:jid node:node andData:entry];
    [client send:iq andDelegateResponse:[XMPPPubSubEntryDelegate delegate]];
}

@end
