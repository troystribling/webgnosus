//
//  XMPPClientVersionQuery.m
//  webgnosus_client
//
//  Created by Troy Stribling on 3/29/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPClientVersionQuery.h"
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

@end
