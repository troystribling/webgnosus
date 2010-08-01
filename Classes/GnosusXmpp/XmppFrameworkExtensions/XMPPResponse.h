//
//  XMPPResponse.h
//  webgnosus
//
//  Created by Troy Stribling on 9/17/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>

//-----------------------------------------------------------------------------------------------------------------------------------
@class XMPPIQ;
@class XMPPClient;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPResponse : NSObject {
    NSString* stanzaID;
    id delegate;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, assign) NSString* stanzaID;
@property (nonatomic, retain) id delegate;

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithDelegate:(id)initDelegate;
- (void)handleResponse:(XMPPClient*)client forStanza:(XMPPIQ*)stanza;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@protocol XMPPResponseDelegate

- (void)handleError:(XMPPClient*)client forStanza:(XMPPIQ*)stanza;
- (void)handleResult:(XMPPClient*)client forStanza:(XMPPIQ*)stanza;

@end
