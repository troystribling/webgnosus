//
//  XMPPDiscoInfoServiceResponseDelegate.m
//  webgnosus
//
//  Created by Troy Stribling on 10/14/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPDiscoInfoServiceResponseDelegate.h"
#import "XMPPDiscoItem.h"
#import "XMPPResponse.h"
#import "XMPPJID.h"
#import "XMPPClient.h"
#import "XMPPIQ.h"
#import "XMPPDiscoInfoQuery.h"
#import "XMPPDiscoIdentity.h"
#import "XMPPDiscoFeature.h"
#import "ServiceModel.h"
#import "ServiceFeatureModel.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPDiscoInfoServiceResponseDelegate (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPDiscoInfoServiceResponseDelegate

//===================================================================================================================================
#pragma mark XMPPDiscoInfoServiceResponseDelegate

//===================================================================================================================================
#pragma mark XMPPDiscoInfoServiceResponseDelegate PrivateAPI

//===================================================================================================================================
#pragma mark XMPPResponse Delegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleError:(XMPPClient*)client forStanza:(XMPPStanza*)stanza {
    [[client multicastDelegate] xmppClient:client didReceiveDiscoInfoServiceError:(XMPPIQ*)stanza];        
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleResult:(XMPPClient*)client forStanza:(XMPPStanza*)stanza {
    XMPPIQ* iq = (XMPPIQ*)stanza;
    XMPPDiscoInfoQuery* query = (XMPPDiscoInfoQuery*)[iq query];
    NSArray* identities = [query identities];	
	NSString* node = [query node];
	XMPPJID* serviceJID = [iq fromJID];
    for(int i = 0; i < [identities count]; i++) {
        XMPPDiscoIdentity* identity = [XMPPDiscoIdentity createFromElement:(NSXMLElement *)[identities objectAtIndex:i]];
        [ServiceModel insert:identity forService:serviceJID andNode:node];
    }
    NSArray* features = [query features];		
    for(int i = 0; i < [features count]; i++) {
        XMPPDiscoFeature* feature = [XMPPDiscoFeature createFromElement:(NSXMLElement *)[features objectAtIndex:i]];
        [ServiceFeatureModel insert:feature forService:serviceJID andNode:node];
    }
    [[client multicastDelegate] xmppClient:client didReceiveDiscoInfoServiceResult:iq];        
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
