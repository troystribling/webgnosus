//
//  XMPPStreamFeatures.m
//  webgnosus
//
//  Created by Troy Stribling on 3/29/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPStreamFeatures.h"
#import "NSXMLElementAdditions.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPStreamFeatures (PrivateAPI)

- (BOOL)hasMechanism:(NSString*)mech;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPStreamFeatures

//-----------------------------------------------------------------------------------------------------------------------------------

//===================================================================================================================================
#pragma mark XMPPStreamFeatures

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPStreamFeatures*)createFromElement:(NSXMLElement*)element {
	XMPPStreamFeatures* result = (XMPPStreamFeatures*)element;
	result->isa = [XMPPStreamFeatures class];
	return result;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPStreamFeatures*)init {
	if(self = [super initWithName:@"stream:features"]) {
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSArray*)mechanisms {
    NSXMLElement *mech = [self elementForName:@"mechanisms" xmlns:@"urn:ietf:params:xml:ns:xmpp-sasl"];		
    return [mech elementsForName:@"mechanism"];		
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)supportsInBandRegistration {
    return ([self elementForName:@"register" xmlns:@"http://jabber.org/features/iq-register"] != nil);
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)supportsTLS {
    return ([self elementForName:@"starttls" xmlns:@"urn:ietf:params:xml:ns:xmpp-tls"] != nil);
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)requiresTLS {
    BOOL result = NO;
    if ([self supportsTLS]) { 
        if ([[self elementForName:@"starttls" xmlns:@"urn:ietf:params:xml:ns:xmpp-tls"] elementForName:@"required"]) {
            result = YES;
        }
    }    
    return result;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)requiresBind {
    return ([self elementForName:@"bind" xmlns:@"urn:ietf:params:xml:ns:xmpp-bind"] != nil);
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)supportsSession {
    return ([self elementForName:@"session" xmlns:@"urn:ietf:params:xml:ns:xmpp-session"] != nil);
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)supportsPlainAuthentication {
    return [self hasMechanism:@"PLAIN"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)supportsDigestMD5Authentication {
    return [self hasMechanism:@"DIGEST-MD5"];
}

//===================================================================================================================================
#pragma mark XMPPStreamFeatures PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)hasMechanism:(NSString*)mech {
    NSArray* mechs = [self mechanisms];		
    for(int i = 0; i < [mechs count]; i++) {
        if([[[mechs objectAtIndex:i] stringValue] isEqualToString:mech]) {
            return YES;
        }
    }
    return NO;
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
