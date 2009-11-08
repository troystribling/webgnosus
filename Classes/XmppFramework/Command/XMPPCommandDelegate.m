//
//  XMPPCommandDelegate.m
//  webgnosus
//
//  Created by Troy Stribling on 11/5/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPCommandDelegate.h"
#import "XMPPMessageDelegate.h"
#import "XMPPClientManager.h"
#import "XMPPResponse.h"
#import "XMPPJID.h"
#import "XMPPIQ.h"
#import "XMPPCommand.h"
#import "XMPPxData.h"
#import "XMPPClient.h"
#import "XMPPStanza.h"
#import "AccountModel.h"
#import "MessageModel.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPCommandDelegate (PrivateAPI)

- (void)processCommandResult:(XMPPClient*)client forIQ:(XMPPIQ*)iq;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPCommandDelegate

//-----------------------------------------------------------------------------------------------------------------------------------

//===================================================================================================================================
#pragma mark XMPPDiscoInfoResponseDelegate

//===================================================================================================================================
#pragma mark XMPPDiscoInfoResponseDelegate PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)processCommandResult:(XMPPClient*)client forIQ:(XMPPIQ*)iq {
    [MessageModel insert:client commandResult:iq];
    [[[XMPPClientManager instance] messageCountUpdateDelegate] messageCountDidChange];
    [[client multicastDelegate] xmppClient:client didReceiveCommandResult:iq];        
}

//===================================================================================================================================
#pragma mark XMPPResponse Delegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleError:(XMPPClient*)client forStanza:(XMPPStanza*)stanza {
    [[client multicastDelegate] xmppClient:client didReceiveCommandError:(XMPPIQ*)stanza];        
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleResult:(XMPPClient*)client forStanza:(XMPPStanza*)stanza {
    XMPPIQ* iq = (XMPPIQ*)stanza;
    XMPPCommand* command = [iq command];
    if (command) {
        XMPPxData* cmdData = [command data];
        if (cmdData) {
            NSString* dataType = [cmdData dataType];
            if ([dataType isEqualToString:@"form"]) {
                [[client multicastDelegate] xmppClient:client didReceiveCommandForm:iq];        
            } else if ([dataType isEqualToString:@"result"]) {
                [self processCommandResult:client forIQ:iq];
            }
        } else {
            [self processCommandResult:client forIQ:iq];
        }
    } else {
        [self processCommandResult:client forIQ:iq];
    }
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
