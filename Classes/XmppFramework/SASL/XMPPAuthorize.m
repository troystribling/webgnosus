//
//  XMPPAuthorize.m
//  webgnosus
//
//  Created by Troy Stribling on 3/29/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "NSDataAdditions.h"
#import "XMPPAuthorize.h"
#import "XMPPStream.h"
#import "XMPPAuthorizationQuery.h"

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
#pragma mark XMPPAuthorize PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)send:(XMPPStream*)stream auth:(XMPPAuthorize*)auth {
    if(DEBUG_SEND) {
        NSLog(@"SEND: %@", auth);
    }
    [stream sendElement:auth];
}

//===================================================================================================================================
#pragma mark XMPPAuthorize Messages

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)authenticate:(XMPPStream*)stream user:(NSString*)username withPassword:(NSString*)password resource:(NSString*)resource {
    if([stream supportsDigestMD5Authentication]) {
        XMPPAuthorize* auth = [[self alloc] initWithMechanism:@"DIGEST-MD5"];	
		[self send:stream auth:auth];
        if(DEBUG_SEND) {
            NSLog(@"SEND: %@", auth);
        }
        [stream sendElement:auth];
    } else if([stream supportsPlainAuthentication]) {
        NSString* payload = [NSString stringWithFormat:@"%C%@%C%@", 0, username, 0, password];
        NSString* base64 = [[payload dataUsingEncoding:NSUTF8StringEncoding] base64Encoded];			
        XMPPAuthorize* auth = [[self alloc] initWithMechanism:@"PLAIN" andPlainCredentials:base64];			
		[self  send:stream auth:auth];
    } else {
        [XMPPAuthorizationQuery set:stream user:username withPassword:password resource:resource];
    }
}

@end
