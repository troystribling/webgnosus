//
//  XMPPDiscoInfoServiceResponseDelegate.h
//  webgnosus
//
//  Created by Troy Stribling on 10/14/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "XMPPResponse.h"

//-----------------------------------------------------------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPDiscoInfoServiceResponseDelegate : NSObject <XMPPResponseDelegate> {

}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPDiscoInfoServiceResponseDelegate*)delegate;

@end
