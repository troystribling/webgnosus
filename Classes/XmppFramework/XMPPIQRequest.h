//
//  XMPPIQRequest.h
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
@interface XMPPIQRequest : NSObject {
    NSInteger requestID;
    XMPPIQ* request;
    id delegate;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, assign) requestID;
@property (nonatomic, retain) request;
@property (nonatomic, retain) delegate;

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithRequest:(XMPPIQ*)accountClient andDelegate:(id)initJID;
- (void)handleRequest:(XMPPClient*)client forIQ:(XMPPIQ*)iq;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface NSObject (XMPPRequest)

- (void)handleError:(XMPPClient*)client forIQ:(XMPPIQ*)iq;
- (void)handleResult:(XMPPClient*)client forIQ:(XMPPIQ*)iq;

@end
