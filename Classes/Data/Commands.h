//
//  Commands.h
//  webgnosus_client
//
//  Created by Troy Stribling on 5/16/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface Commands : NSObject {
    NSMutableArray* commands;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) NSMutableArray* commands;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (Commands*)instance;

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSMutableArray*)atIndex:(NSUInteger)index;
- (NSMutableDictionary*)commandWithName:(NSString*)command;
- (BOOL)hasPerformanceCommand:(NSString*)command;

@end
