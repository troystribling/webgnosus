//
//  XMPPDiscoInfoResponseDelegate.h
//  webgnosus
//
//  Created by Troy Stribling on 9/18/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "XMPPResponse.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@class XMPPJID;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPDiscoInfoResponseDelegate : NSObject <XMPPResponseDelegate> {
    XMPPJID* targetJID;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) XMPPJID* targetJID;
           
//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPDiscoInfoResponseDelegate*)delegate:(XMPPJID*)_jid;
- (id)init:(XMPPJID*)initJID;
           
@end
