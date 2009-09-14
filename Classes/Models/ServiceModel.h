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
    NSString* name;
    NSString* category;
    NSString* type;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, assign) NSInteger pk;
@property (nonatomic, retain) NSString* jid;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* category;
@property (nonatomic, retain) NSString* type;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)count;
+ (void)drop;
+ (void)create;
+ (void)destroyAll;
+ (ServiceModel*)findByJID:(NSString*)requestJID type:(NSString*)requestType andCategory:(NSString*)requestCategory;
+ (NSMutableArray*)findAll;
+ (NSArray*)findAllByServiceType:(NSString*)requestType;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insert;
- (void)destroy;
- (void)load;
- (void)update;

@end
