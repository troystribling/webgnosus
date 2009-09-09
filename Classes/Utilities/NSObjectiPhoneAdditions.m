//
//  NSObjectiPhoneAdditions.m
//  webgnosus
//
//  Created by Troy Stribling on 3/29/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <objc/runtime.h>
#import "NSObjectiPhoneAdditions.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation NSObject (NSObjectiPhoneAdditions)

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString *)className {
    return [NSString stringWithUTF8String:(char*)class_getName([self class])];
}

@end
