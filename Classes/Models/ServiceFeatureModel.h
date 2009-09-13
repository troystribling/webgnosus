//
//  ServiceFeatureModel.h
//  webgnosus
//
//  Created by Troy Stribling on 8/5/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import <sqlite3.h>

//-----------------------------------------------------------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ServiceFeatureModel : NSObject {
    NSInteger pk;
    NSString* parentNode;
    NSString* service;
    NSString* var;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, assign) NSInteger pk;
@property (nonatomic, retain) NSString* parentNode;
@property (nonatomic, retain) NSString* service;
@property (nonatomic, retain) NSString* var;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)count;
+ (void)drop;
+ (void)create;
+ (NSMutableArray*)findAll;
+ (void)destroyAll;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insert;
- (void)destroy;
- (void)load;
- (void)update;

@end
