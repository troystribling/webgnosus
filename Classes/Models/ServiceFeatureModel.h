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
@class XMPPDiscoFeature;
@class XMPPJID;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ServiceFeatureModel : NSObject {
    NSInteger pk;
    NSString* parentNode;
    NSString* service;
    NSString* var;
    BOOL synched;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, assign) NSInteger pk;
@property (nonatomic, retain) NSString* parentNode;
@property (nonatomic, retain) NSString* service;
@property (nonatomic, retain) NSString* var;
@property (nonatomic, assign) BOOL synched;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)count;
+ (void)drop;
+ (void)create;
+ (void)destroyAll;
+ (NSMutableArray*)findAll;
+ (ServiceFeatureModel*)findByService:(NSString*)requestService andVar:(NSString*)requestVar;
+ (void)insert:(XMPPDiscoFeature*)feature forService:(XMPPJID*)serviceJID andParentNode:(NSString*)parent;
+ (void)resetSyncFlag;
+ (void)destroyAllUnsyched;
+ (void)destroyAllUnsychedByService:(NSString*)requestService;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insert;
- (void)destroy;
- (void)load;
- (void)update;
- (NSInteger)synchedAsInteger;
- (void)setSynchedAsInteger:(NSInteger)value;
- (void)sync;
    
@end
