//
//  XMPPRegisterQuery.m
//  webgnosus
//
//  Created by Troy Stribling on 3/29/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "XMPPQuery.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@class XMPPClient;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPRegisterQuery : XMPPQuery 

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPRegisterQuery*)createFromElement:(NSXMLElement*)element;
- (XMPPRegisterQuery*)init;
- (XMPPRegisterQuery*)initWithUsername:(NSString*)regUsername andPassword:(NSString*)regPassword;

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)username;
- (void)addUsername:(NSString*)val;

- (NSString*)password;
- (void)addPassword:(NSString*)val;

- (NSString*)email;
- (void)addEmail:(NSString*)val;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)set:(XMPPClient*)client user:(NSString *)username withPassword:(NSString *)password;

@end
