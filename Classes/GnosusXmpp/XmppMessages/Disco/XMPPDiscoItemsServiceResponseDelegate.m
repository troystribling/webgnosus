//
//  XMPPDiscoItemsServiceResponseDelegate.m
//  webgnosus
//
//  Created by Troy Stribling on 10/12/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPDiscoItemsServiceResponseDelegate.h"
#import "XMPPDiscoItem.h"
#import "XMPPDiscoItemsQuery.h"
#import "XMPPResponse.h"
#import "XMPPJID.h"
#import "XMPPClient.h"
#import "XMPPIQ.h"
#import "ServiceItemModel.h"


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPDiscoItemsServiceResponseDelegate (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPDiscoItemsServiceResponseDelegate

//===================================================================================================================================
#pragma mark XMPPDiscoItemsServiceResponseDelegate

//===================================================================================================================================
#pragma mark XMPPDiscoItemsServiceResponseDelegate PrivateAPI

//===================================================================================================================================
#pragma mark XMPPResponse Delegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleError:(XMPPClient*)client forStanza:(XMPPStanza*)stanza {
    [[client multicastDelegate] xmppClient:client didReceiveDiscoItemsServiceError:(XMPPIQ*)stanza];        
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleResult:(XMPPClient*)client forStanza:(XMPPStanza*)stanza {
    XMPPIQ* iq = (XMPPIQ*)stanza;
    XMPPDiscoItemsQuery* query = (XMPPDiscoItemsQuery*)[iq query];
	NSString* parentNode = [query node];
    NSArray* items = [query items];	
	XMPPJID* serviceJID = [stanza fromJID];
    for(int i = 0; i < [items count]; i++) {
        XMPPDiscoItem* item = [XMPPDiscoItem createFromElement:(NSXMLElement *)[items objectAtIndex:i]];
        [ServiceItemModel insert:item forService:serviceJID andParentNode:parentNode];
    }
    [[client multicastDelegate] xmppClient:client didReceiveDiscoItemsServiceResult:iq];        
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
