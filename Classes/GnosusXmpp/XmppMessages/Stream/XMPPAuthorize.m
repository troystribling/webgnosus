//
//  XMPPAuthorize.m
//  webgnosus
//
//  Created by Troy Stribling on 3/29/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPAuthorize.h"
#import "NSXMLElementAdditions.h"

//-----------------------------------------------------------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPAuthorize

//-----------------------------------------------------------------------------------------------------------------------------------

//===================================================================================================================================
#pragma mark XMPPAuthorize

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPAuthorize*)createFromElement:(NSXMLElement*)element {
	XMPPAuthorize* result = (XMPPAuthorize*)element;
	result->isa = [XMPPAuthorize class];
	return result;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPAuthorize*)init {
	if(self = [super initWithName:@"auth"]) {
        [self addNamespace:[NSXMLNode namespaceWithName:@"" stringValue:@"urn:ietf:params:xml:ns:xmpp-sasl" ]];
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPAuthorize*)initWithMechanism:(NSString*)authMechanism {
	if([self init]) {
        [self addMechanism:authMechanism];
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPAuthorize*)initWithMechanism:(NSString*)authMechanism andPlainCredentials:(NSString*)authCredentials {
	if(self = [self initWithMechanism:authMechanism]) {
        [self addPlainCredentials:authCredentials];
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)mechanism {
    return [[self attributeForName:@"mechanism"] stringValue];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addMechanism:(NSString*)val {
    [self addAttributeWithName:@"mechanism" stringValue:val];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)plainCredentials {
    return [self stringValue];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addPlainCredentials:(NSString*)val {
    [self setStringValue:val];
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
