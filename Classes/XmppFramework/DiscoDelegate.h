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
    XMPPClient* delegateClient;
    BOOL pubSubDiscoDone;
    BOOL versionDiscoDone;
    BOOL commandDiscoDone;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) XMPPJID* targetJID;
@property (nonatomic, retain) XMPPClient* delegateClient;
@property (nonatomic, assign) BOOL pubSubDiscoDone;
@property (nonatomic, assign) BOOL versionDiscoDone;
@property (nonatomic, assign) BOOL commandDiscoDone;

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initForAccount:(XMPPClient*)accountClient withJID:(XMPPJID*)initJID;
- (id)initForContact:(XMPPClient*)initClient withJID:(XMPPJID*)initJID;
- (NSString*)targetJIDPubSubRoot;

@end
