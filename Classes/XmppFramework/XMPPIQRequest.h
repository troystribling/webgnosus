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
    NSString* requestID;
    XMPPIQ* request;
    id delegate;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, assign) NSString* requestID;
@property (nonatomic, retain) XMPPIQ* request;
@property (nonatomic, retain) id delegate;

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithRequest:(XMPPIQ*)accountClient andDelegate:(id)initDelegate;
- (void)handleRequest:(XMPPClient*)client forIQ:(XMPPIQ*)iq;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface NSObject (XMPPIQRequest)

- (void)handleError:(XMPPClient*)client forIQ:(XMPPIQ*)iq;
- (void)handleResult:(XMPPClient*)client forIQ:(XMPPIQ*)iq;

@end
