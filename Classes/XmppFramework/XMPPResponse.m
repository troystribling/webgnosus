//
//  XMPPResponse.m
//  webgnosus
//
//  Created by Troy Stribling on 9/17/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPResponse.h"
#import "XMPPIQ.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPResponse

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize stanzaID;
@synthesize delegate;

//===================================================================================================================================
#pragma mark XMPPResponse

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithDelegate:(id)initDelegate {
	if(self = [super init])  {
        self.delegate = initDelegate;
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleResponse:(XMPPClient*)client forStanza:(XMPPStanza*)stanza {
    if ([[stanza type] isEqualToString:@"result"]) {
        if ([self.delegate respondsToSelector:@selector(handleResult:forStanza:)]) {
            [self.delegate handleResult:client forStanza:stanza];
        }
    } else if ([[stanza type] isEqualToString:@"error"]) {
        if ([self.delegate respondsToSelector:@selector(handleError:forStanza:)]) {
            [self.delegate handleError:client forStanza:stanza];
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
