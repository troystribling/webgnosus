//
//  XMPPIQRequest.m
//  webgnosus
//
//  Created by Troy Stribling on 9/17/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPIQRequest.h"
#import "XMPPIQ.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPIQRequest

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize requestID;
@synthesize request;
@synthesize delegate;

//===================================================================================================================================
#pragma mark XMPPIQRequest

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithRequest:(XMPPIQ*)initRequest andDelegate:(id)initDelegate {
	if(self = [super init])  {
        self.request = initRequest;
        self.delegate = initDelegate;
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleRequest:(XMPPClient*)client forIQ:(XMPPIQ*)iq {
    if ([[iq type] isEqualToString:@"result"]) {
        if ([self.delegate respondsToSelector:@selector(handleResult:forIQ:)]) {
            [self.delegate handleResult:client forIQ:iq];
        }
    } else if ([[iq type] isEqualToString:@"error"]) {
        if ([self.delegate respondsToSelector:@selector(handleError:forIQ:)]) {
            [self.delegate handleError:client forIQ:iq];
        }
    }
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
	[super dealloc];
}

@end
