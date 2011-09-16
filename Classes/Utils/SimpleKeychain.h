//
//  SimpleKeychain.h
//  webgnosus
//
//  Created by Troy Stribling on 9/15/11.
//  Copyright 2011 imaginaryProducts. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface SimpleKeychain : NSObject

+ (void)save:(NSString*)service data:(id)data;
+ (id)get:(NSString*)service;
+ (void)delete:(NSString*)service;

@end