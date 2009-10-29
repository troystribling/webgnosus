//
//  MessageCache.h
//  webgnosus
//
//  Created by Troy Stribling on 10/28/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import <sqlite3.h>

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface MessageCache : NSObject {
    NSMutableArray* messageList;
    NSInteger cacheIncrement;
    NSInteger lastIndex;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) NSMutableArray* messageList;
@property (nonatomic, assign) NSInteger cacheIncrement;
@property (nonatomic, assign) NSInteger lastIndex;

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithCacheIncrement:(NSInteger)initCacheIncrement;
- (id)objectAtIndex:(NSInteger)index;
- (NSInteger)count;
- (void)grow;

@end
