//
//  DiscoDelegate.h
//  webgnosus
//
//  Created by Troy Stribling on 9/14/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>

//-----------------------------------------------------------------------------------------------------------------------------------
@class XMPPJID;
@class XMPPClient;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface DiscoDelegate : NSObject {
    XMPPJID* targetJID;
    XMPPClient* accountClient;
    NSInteger pendingMsgID;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) XMPPJID* targetJID;
@property (nonatomic, retain) XMPPClient* accountClient;
@property (nonatomic, assign) NSInteger pendingMsgID;

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)init:(XMPPClient*)accountClient withDomain:(XMPPJID*)initJID;
- (NSString*)targetJIDPubSubRoot;

@end
