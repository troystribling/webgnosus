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
+ (XMPPDiscoItemsServiceResponseDelegate*)delegate {    
    return [[[XMPPDiscoItemsServiceResponseDelegate alloc] init] autorelease];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleError:(XMPPClient*)client forStanza:(XMPPIQ*)iq {
    [[client multicastDelegate] xmppClient:client didReceiveDiscoItemsServiceError:iq];        
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleResult:(XMPPClient*)client forStanza:(XMPPIQ*)iq {
    XMPPDiscoItemsQuery* query = (XMPPDiscoItemsQuery*)[iq query];
	NSString* parentNode = [query node];
    NSArray* items = [query items];	
	XMPPJID* serviceJID = [iq fromJID];
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
