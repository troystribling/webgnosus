//
//  XMPPBind.m
//  webgnosus
//
//  Created by Troy Stribling on 3/29/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "DDXML.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPBind : NSXMLElement 

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPBind*)createFromElement:(NSXMLElement*)element;
- (XMPPBind*)init;
- (XMPPBind*)initWithResource:(NSString*)bindResource;

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)resource;
- (void)addResource:(NSString*)val;

@end
