//
//  XMPPAuthorizationQuery.m
//  webgnosus
//
//  Created by Troy Stribling on 3/29/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "XMPPQuery.h"

//-----------------------------------------------------------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPAuthorizationQuery : XMPPQuery 

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPAuthorizationQuery*)createFromElement:(NSXMLElement*)element;
- (XMPPAuthorizationQuery*)initWithUsername:(NSString*)queryUsername digest:(NSString*)queryDigest andResource:(NSString*)queryResource;

//-----------------------------------------------------------------------------------------------------------------------------------
- (int)username;
- (void)addUsername:(NSString*)val;

- (int)digest;
- (void)addDigest:(NSString*)val;

- (int)resource;
- (void)addResource:(NSString*)val;

@end
