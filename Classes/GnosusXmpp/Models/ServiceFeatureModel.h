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
    NSString* node;
    NSString* service;
    NSString* var;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, assign) NSInteger pk;
@property (nonatomic, retain) NSString* node;
@property (nonatomic, retain) NSString* service;
@property (nonatomic, retain) NSString* var;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)count;
+ (NSInteger)countByService:(NSString*)requestService andNode:(NSString*)requestNode;
+ (void)drop;
+ (void)create;
+ (void)destroyAll;
+ (void)destroyByService:(NSString*)requestService andNode:(NSString*)requestNode;
+ (NSMutableArray*)findAll;
+ (ServiceFeatureModel*)findByService:(NSString*)requestService andVar:(NSString*)requestVar;
+ (ServiceFeatureModel*)findByService:(NSString*)requestService node:(NSString*)requestNode  andVar:(NSString*)requestVar;
+ (NSMutableArray*)findAllByService:(NSString*)requestService andNode:(NSString*)requestNode;
+ (void)insert:(XMPPDiscoFeature*)feature forService:(XMPPJID*)serviceJID andNode:(NSString*)parent;
+ (void)destroyAllByService:(NSString*)requestService;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insert;
- (void)destroy;
- (void)load;
- (void)update;
    
@end
