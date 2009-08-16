//
//  XMPPAuthorize.m
//  webgnosus
//
//  Created by Troy Stribling on 3/29/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "DDXML.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPAuthorize : NSXMLElement 

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPAuthorize*)createFromElement:(NSXMLElement*)element;
- (XMPPAuthorize*)init;
- (XMPPAuthorize*)initWithMechanism:(NSString*)authMechanism;
- (XMPPAuthorize*)initWithMechanism:(NSString*)authMechanism andPlainCredentials:(NSString*)authCredentials;

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)mechanism;
- (void)addMechanism:(NSString*)val;

- (NSString*)plainCredentials;
- (void)addPlainCredentials:(NSString*)val;

@end
