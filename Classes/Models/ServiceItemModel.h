//
//  ServiceItemModel.h
//  webgnosus
//
//  Created by Troy Stribling on 8/5/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import <sqlite3.h>

//-----------------------------------------------------------------------------------------------------------------------------------
@class XMPPDiscoItem;
@class XMPPJID;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ServiceItemModel : NSObject {
    NSInteger pk;
    NSString* parentNode;
    NSString* service;
    NSString* node;
    NSString* jid;
    NSString* itemName;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, assign) NSInteger pk;
@property (nonatomic, retain) NSString* parentNode;
@property (nonatomic, retain) NSString* service;
@property (nonatomic, retain) NSString* node;
@property (nonatomic, retain) NSString* jid;
@property (nonatomic, retain) NSString* itemName;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)count;
+ (NSInteger)countByService:(NSString*)requestService andParentNode:(NSString*)requestNode;
+ (void)drop;
+ (void)create;
+ (void)destroyAll;
+ (ServiceItemModel*)findByJID:(NSString*)requestJID;
+ (ServiceItemModel*)findByNode:(NSString*)requestNode;
+ (ServiceItemModel*)findByService:(NSString*)requestService andNode:(NSString*)requestNode;
+ (ServiceItemModel*)findByService:(NSString*)requestService;
+ (NSMutableArray*)findAllByService:(NSString*)requestService andParentNode:(NSString*)requestNode ;
+ (NSMutableArray*)findAllByService:(NSString*)requestService parentNode:(NSString*)requestParentNode andNode:(NSString*)requestNode;
+ (NSMutableArray*)findAll;
+ (NSMutableArray*)findAllByParentNode:(NSString*)requestNode;
+ (void)insert:(XMPPDiscoItem*)item forService:(XMPPJID*)serviceJID andParentNode:(NSString*)parent;
+ (void)destroyAllByService:(NSString*)requestService;
+ (void)destroyAllByService:(NSString*)requestService andParentNode:(NSString*)requestNode;
    
//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insert;
- (void)destroy;
- (void)load;
- (void)update;

@end
