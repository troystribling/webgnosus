//
//  AcceptBuddyRequestView.h
//  webgnosus_client
//
//  Created by Troy Stribling on 2/22/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

//-----------------------------------------------------------------------------------------------------------------------------------
@class XMPPClient;
@class XMPPJID;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface AcceptBuddyRequestView : UIAlertView {
    XMPPClient* xmppClient;
    XMPPJID* buddyJid;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) XMPPClient* xmppClient;
@property (nonatomic, retain) XMPPJID* buddyJid;

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithClient:(XMPPClient*)client buddyJid:(XMPPJID*)aBuddyJid andDelegate:(id)delegate;

@end
