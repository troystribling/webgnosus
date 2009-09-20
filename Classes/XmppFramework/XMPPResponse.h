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
@class XMPPStanza;
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
- (void)handleResponse:(XMPPClient*)client forStanza:(XMPPStanza*)stanza;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface NSObject (XMPPResponse)

- (void)handleError:(XMPPClient*)client forStanza:(XMPPStanza*)stanza;
- (void)handleResult:(XMPPClient*)client forStanza:(XMPPStanza*)stanza;

@end
