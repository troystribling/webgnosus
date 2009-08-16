//
//  XMPPMessageDelegate.h
//  webgnosus
//
//  Created by Troy Stribling on 8/11/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "NSXMLElementAdditions.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@class XMPPClient;
@class AccountModel;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPMessageDelegate : NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
+ (AccountModel*)accountForXMPPClient:(XMPPClient*)client;

@end
