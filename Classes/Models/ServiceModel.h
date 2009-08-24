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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ServiceModel : NSObject {
    NSInteger pk;
	NSInteger accountPk;
    NSString* jid;
    NSString* serviceName;
    NSString* serviceCategory;
    NSString* serviceType;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, assign) NSInteger pk;
@property (nonatomic, assign) NSInteger accountPk;
@property (nonatomic, retain) NSString* jid;
@property (nonatomic, retain) NSString* serviceName;
@property (nonatomic, retain) NSString* serviceCategory;
@property (nonatomic, retain) NSString* serviceType;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)count;
+ (void)drop;
+ (void)create;
+ (NSMutableArray*)findAll;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insert;
- (void)destroy;
- (void)load;
- (void)update;

@end
