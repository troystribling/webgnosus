//
//  UserModel.m
//  webgnosus
//
//  Created by Troy Stribling on 3/6/09.
//  Copyright 2009 Plan-B Research. All rights rfullJIDeserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "UserModel.h"
#import "XMPPJID.h"
#import "ServiceModel.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface UserModel (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation UserModel

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize pk;
@synthesize jid;
@synthesize resource;
@synthesize nickname;
@synthesize host;
@synthesize clientName;
@synthesize clientVersion;

//===================================================================================================================================
#pragma mark UserModel

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPJID*)nodeToJID:(NSString*)node {
    NSArray* comp = [node componentsSeparatedByString:@"/"];
    return [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@", [comp objectAtIndex:3], [comp objectAtIndex:2]]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)bareJID {
    return self.jid;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)fullJID {
	NSString* aFullJid;
	if (self.resource) {
		aFullJid = [[NSString alloc] initWithFormat:@"%@/%@", self.jid, self.resource];
	} else {
		aFullJid = self.jid;
	}
	return aFullJid;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)pubSubRoot {
    XMPPJID* myJid = [self toJID];
	return [[NSString alloc] initWithFormat:@"/home/%@/%@", [myJid domain], [myJid user]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)pubSubDomain {
    XMPPJID* myJid = [self toJID];
	return [[NSString alloc] initWithFormat:@"/home/%@", [myJid domain]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPJID*)toJID {
    return [XMPPJID jidWithString:[self fullJID]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPJID*)pubSubService {
    NSString* domain = [[self toJID] domain];
    ServiceModel* service = [ServiceModel findByService:domain type:@"service" andCategory:@"pubsub"];
    return [XMPPJID jidWithString:service.jid];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)load {
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
