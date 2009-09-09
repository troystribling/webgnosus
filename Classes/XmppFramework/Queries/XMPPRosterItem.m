//
//  XMPPRosterItem.m
//  webgnosus
//
//  Created by Troy Stribling on 3/29/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPRosterItem.h"
#import "XMPPJID.h"
#import "NSXMLElementAdditions.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPRosterItem

//-----------------------------------------------------------------------------------------------------------------------------------

//===================================================================================================================================
#pragma mark XMPPRosterItem

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPRosterItem*)createFromElement:(NSXMLElement*)element {
	XMPPRosterItem* result = (XMPPRosterItem*)element;
	result->isa = [XMPPRosterItem class];
	return result;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPRosterItem*)initWithJID:(NSString*)itemJID {
	if(self = [super initWithName:@"item"]) {
        [self addJID:itemJID];
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPRosterItem*)initWithJID:(NSString*)itemJID andSubscription:(NSString*)itemSubscrition {
	if([self initWithJID:itemJID]) {
        [self addSubscription:itemSubscrition];
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPJID*)jid {
    return [XMPPJID jidWithString:[[self attributeForName:@"jid"] stringValue]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addJID:(NSString*)val {
    [self addAttributeWithName:@"jid" stringValue:val];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)nickname {
    return [[self attributeForName:@"name"] stringValue];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addNickname:(NSString*)val {
    [self addAttributeWithName:@"name" stringValue:val];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)subscription{
    return [[self attributeForName:@"subscription"] stringValue];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addSubscription:(NSString*)val {
    [self addAttributeWithName:@"subscription" stringValue:val];
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
