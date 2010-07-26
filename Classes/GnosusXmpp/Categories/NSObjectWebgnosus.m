//
//  NSObjectWebgnosus.m
//  webgnosus
//
//  Created by Troy Stribling on 3/29/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <objc/runtime.h>
#import "NSObjectWebgnosus.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation NSObject (NSObjectWebgnosus)

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString *)className {
    return [NSString stringWithUTF8String:(char*)class_getName([self class])];
}

@end
