//
//  XMPPClientVersionQueryDeligate.h
//  webgnosus
//
//  Created by Troy Stribling on 11/29/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "XMPPResponse.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPClientVersionQueryDelegate : NSObject <XMPPResponseDelegate> {
}

//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
+(XMPPClientVersionQueryDelegate*)delegate;

@end
