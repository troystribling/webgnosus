//
//  XMPPRegisterQueryDelegate.h
//  webgnosus
//
//  Created by Troy Stribling on 11/3/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "XMPPResponse.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPRegisterQueryDelegate : NSObject <XMPPResponseDelegate> {
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPRegisterQueryDelegate*)delegate;

@end
