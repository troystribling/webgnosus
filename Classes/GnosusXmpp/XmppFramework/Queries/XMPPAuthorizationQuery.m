//
//  XMPPAuthorizationQuery.m
//  webgnosus
//
//  Created by Troy Stribling on 3/29/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPAuthorizationQuery.h"
#import "NSXMLElementAdditions.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPAuthorizationQuery

//-----------------------------------------------------------------------------------------------------------------------------------

//===================================================================================================================================
#pragma mark XMPPAuthorizationQuery

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPAuthorizationQuery*)createFromElement:(NSXMLElement*)element {
	XMPPAuthorizationQuery* result = (XMPPAuthorizationQuery*)element;
	result->isa = [XMPPAuthorizationQuery class];
	return result;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPAuthorizationQuery*)initWithUsername:(NSString*)queryUsername digest:(NSString*)queryDigest andResource:(NSString*)queryResource {
	if(self = (XMPPAuthorizationQuery*)[super initWithXMLNS:@"jabber:iq:auth"]) {
        [self addUsername:queryUsername];
        [self addDigest:queryDigest];
        [self addResource:queryResource];
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (int)username {
	return [[[self elementForName:@"username"] stringValue] intValue];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addUsername:(NSString*)val {
	[self addChild:[NSXMLElement elementWithName:@"username" stringValue:val]];	
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (int)digest {
	return [[[self elementForName:@"digest"] stringValue] intValue];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addDigest:(NSString*)val {
	[self addChild:[NSXMLElement elementWithName:@"digest" stringValue:val]];	
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (int)resource {
	return [[[self elementForName:@"resource"] stringValue] intValue];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addResource:(NSString*)val {
	[self addChild:[NSXMLElement elementWithName:@"resource" stringValue:val]];	
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
