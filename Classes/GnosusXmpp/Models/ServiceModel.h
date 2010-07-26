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
@class XMPPDiscoIdentity;
@class XMPPJID;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ServiceModel : NSObject {
    NSInteger pk;
    NSString* jid;
    NSString* name;
    NSString* category;
    NSString* type;
    NSString* node;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, assign) NSInteger pk;
@property (nonatomic, retain) NSString* jid;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* category;
@property (nonatomic, retain) NSString* type;
@property (nonatomic, retain) NSString* node;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)count;
+ (void)drop;
+ (void)create;
+ (void)destroyAll;
+ (ServiceModel*)findByJID:(NSString*)requestJID type:(NSString*)requestType category:(NSString*)requestCategory andNode:(NSString*)requestNode;
+ (ServiceModel*)findByNode:(NSString*)requestNode;
+ (ServiceModel*)findByJID:(NSString*)requestJID andNode:(NSString*)requestNode;
+ (ServiceModel*)findByService:(NSString*)serverJID type:(NSString*)requestType andCategory:(NSString*)requestCategory;
+ (ServiceModel*)findIMService:(NSString*)requestJID;
+ (NSMutableArray*)findAll;
+ (NSMutableArray*)findAllByServiceType:(NSString*)requestType;
+ (void)insert:(XMPPDiscoIdentity*)ident forService:(XMPPJID*)serviceJID andNode:(NSString*)serviceNode;
+ (void)destroyAllByDomain:(NSString*)requestService;
    
//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insert;
- (void)destroy;
- (void)load;
- (void)update;

@end
