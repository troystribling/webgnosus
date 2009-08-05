//
//  XMPPClientVersionQuery.m
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
@interface XMPPClientVersionQuery : XMPPQuery 

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPClientVersionQuery*)createFromElement:(NSXMLElement*)element;
- (XMPPClientVersionQuery*)init;
- (XMPPClientVersionQuery*)initWithName:(NSString*)name andVersion:(NSString*)version;

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)clientName;
- (void)addClientName:(NSString*)val;

- (NSString*)clientVersion;
- (void)addClientVersion:(NSString*)val;

@end
