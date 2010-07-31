//
//  XMPPPubSubDeleteDelegate.m
//  webgnosus
//
//  Created by Troy Stribling on 9/23/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPPubSubDeleteDelegate.h"
#import "XMPPResponse.h"
#import "XMPPClient.h"
#import "XMPPStanza.h"
#import "XMPPIQ.h"
#import "XMPPError.h"
#import "XMPPJID.h"
#import "ServiceItemModel.h"
#import "ServiceFeatureModel.h"
#import "ServiceModel.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPPubSubDeleteDelegate (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPPubSubDeleteDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize node;

//===================================================================================================================================
#pragma mark XMPPPubSubDeleteDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)init:(NSString*)initNode {
	if(self = [super init])  {
        self.node = initNode;
	}
	return self;
}

//===================================================================================================================================
#pragma mark XMPPPubSubDeleteDelegate PrivateAPI

//===================================================================================================================================
#pragma mark XMPPResponse Delegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleError:(XMPPClient*)client forStanza:(XMPPStanza*)stanza {
    XMPPIQ* iq = (XMPPIQ*)stanza;
    XMPPError* error = [iq error];	
    if (error) {
        if ([[error condition] isEqualToString:@"item-not-found"]) {
            ServiceItemModel* item = [ServiceItemModel findByNode:self.node];
            [item destroy];
        }
    }    
    [[client multicastDelegate] xmppClient:client didReceivePubSubDeleteError:(XMPPIQ*)stanza];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleResult:(XMPPClient*)client forStanza:(XMPPStanza*)stanza {
    ServiceItemModel* item = [ServiceItemModel findByNode:self.node];
    [item destroy];
    ServiceModel* service = [ServiceModel findByNode:self.node];
    if (service) {
        [service destroy];
        [ServiceFeatureModel destroyByService:[[stanza fromJID] full] andNode:self.node]; 
    }
    [[client multicastDelegate] xmppClient:client didReceivePubSubDeleteResult:(XMPPIQ*)stanza];
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
