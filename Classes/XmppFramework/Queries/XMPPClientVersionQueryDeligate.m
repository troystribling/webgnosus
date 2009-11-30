//
//  XMPPClientVersionQueryDeligate.m
//  webgnosus
//
//  Created by Troy Stribling on 11/29/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPClientVersionQueryDeligate.h"
#import "XMPPResponse.h"
#import "XMPPClient.h"
#import "XMPPStanza.h"
#import "XMPPIQ.h"
#import "XMPPRegisterQuery.h"
#import "XMPPMessageDelegate.h"
#import "XMPPJID.h"
#import "AccountModel.h"
#import "RosterItemModel.h"
#import "ContactModel.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPClientVersionQueryDeligate (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPClientVersionQueryDeligate

//===================================================================================================================================
#pragma mark XMPPClientVersionQueryDeligate

//===================================================================================================================================
#pragma mark XMPPClientVersionQueryDeligate PrivateAPI

//===================================================================================================================================
#pragma mark XMPPResponse Delegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleError:(XMPPClient*)client forStanza:(XMPPStanza*)stanza {
    [[client multicastDelegate] xmppClient:client didReceiveClientVersionError:(XMPPIQ*)stanza];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleResult:(XMPPClient*)client forStanza:(XMPPStanza*)stanza {
    XMPPIQ* iq = (XMPPIQ*)stanza;
    XMPPClientVersionQuery* version = (XMPPClientVersionQuery*)[iq query];
    AccountModel* account = [XMPPMessageDelegate accountForXMPPClient:client];
    if (account) {
        XMPPJID* fromJid = [iq fromJID];
        RosterItemModel* rosterItem = [RosterItemModel findByFullJid:[fromJid full] andAccount:account];    
        if (rosterItem) {
            rosterItem.clientName = [version clientName]; 
            rosterItem.clientVersion = [version clientVersion];
            [rosterItem update];
            NSInteger maxPriority = [RosterItemModel maxPriorityForJid:[fromJid bare] andAccount:account];
            ContactModel* contact = [ContactModel findByJid:[fromJid bare] andAccount:account]; 
            if ((maxPriority <= rosterItem.priority && [[version clientName] isEqualToString:@"AgentXMPP"]) || [contact.clientName isEqualToString:@"Unknown"]) {
                contact.clientName = [version clientName]; 
                contact.clientVersion = [version clientVersion];
                [contact update];
            }
        }
    }
    [[client multicastDelegate] xmppClient:client didReceiveClientVersionResult:(XMPPIQ*)stanza];
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
