//
//  ServiceModel.h
//  webgnosus
//
//  Created by Troy Stribling on 8/23/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import <sqlite3.h>

//-----------------------------------------------------------------------------------------------------------------------------------
@class UserModel;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ServiceModel : NSObject {
    NSInteger pk;
    NSString* jid;
    NSString* serviceName;
    NSString* serviceCategory;
    NSString* serviceType;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, assign) NSInteger pk;
@property (nonatomic, retain) NSString* jid;
@property (nonatomic, retain) NSString* serviceName;
@property (nonatomic, retain) NSString* serviceCategory;
@property (nonatomic, retain) NSString* serviceType;

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
