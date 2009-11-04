//
//  XMPPRegisterQuery.m
//  webgnosus
//
//  Created by Troy Stribling on 3/29/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPRegisterQuery.h"
#import "XMPPRegisterQueryDelegate.h"
#import "XMPPClient.h"
#import "XMPPIQ.h"
#import "NSXMLElementAdditions.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPRegisterQuery

//-----------------------------------------------------------------------------------------------------------------------------------

//===================================================================================================================================
#pragma mark XMPPRegisterQuery

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPRegisterQuery*)createFromElement:(NSXMLElement*)element {
	XMPPRegisterQuery* result = (XMPPRegisterQuery*)element;
	result->isa = [XMPPRegisterQuery class];
	return result;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPRegisterQuery*)init {
	if(self = (XMPPRegisterQuery*)[super initWithXMLNS:@"jabber:iq:register"]) {
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPRegisterQuery*)initWithUsername:(NSString*)regUsername andPassword:(NSString*)regPassword {
	if(self = [self init]) {
        [self addUsername:regUsername];
        [self addPassword:regPassword];
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)username {
    return [[self elementForName:@"username"] stringValue];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addUsername:(NSString*)val {
    [self addChild:[NSXMLElement elementWithName:@"username" stringValue:val]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)password {
    return [[self elementForName:@"password"] stringValue];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addPassword:(NSString*)val {
    [self addChild:[NSXMLElement elementWithName:@"password" stringValue:val]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)email {
    return [[self elementForName:@"email"] stringValue];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addEmail:(NSString*)val {
    [self addChild:[NSXMLElement elementWithName:@"email" stringValue:val]];
}

//===================================================================================================================================
#pragma mark XMPPRegisterQuery Messages

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)set:(XMPPClient*)client user:(NSString *)username withPassword:(NSString *)password {
    XMPPIQ* iq = [[XMPPIQ alloc] initWithType:@"set"];
    XMPPRegisterQuery* regQuery = [[XMPPRegisterQuery alloc] initWithUsername:username andPassword:password];
    [iq addQuery:regQuery];			    
    [client send:iq andDelegateResponse:[[XMPPRegisterQueryDelegate alloc] init]];
    [iq release];
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
