//
//  AcceptBuddyRequestView.m
//  webgnosus
//
//  Created by Troy Stribling on 2/22/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "AcceptBuddyRequestView.h"
#import "AccountModel.h"

#import "XMPPClient.h"
#import "XMPPJID.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface AcceptBuddyRequestView (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation AcceptBuddyRequestView

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize xmppClient;
@synthesize buddyJid;

//===================================================================================================================================
#pragma mark AcceptBuddyRequestView

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithClient:(XMPPClient*)client buddyJid:(XMPPJID*)aBuddyJid andDelegate:(id)delegate {
    NSString* message = [[NSString alloc] initWithFormat:@"contact request from \n '%@'", [aBuddyJid full]];
    if (self = [super initWithTitle:[[client myJID] full] message:message delegate:delegate cancelButtonTitle:@"reject" otherButtonTitles:nil]) {
        [self addButtonWithTitle:@"accept"];
        self.xmppClient = client;
        self.buddyJid = aBuddyJid;
    }
    return self;
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
