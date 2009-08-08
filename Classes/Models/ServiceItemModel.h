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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ServiceItemModel : NSObject {
    NSInteger pk;
	NSInteger accountPk;
    NSString* node;
    NSString* jid;
    NSString* iname;
    NSString* category;
    NSString* type;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, assign) NSInteger pk;
@property (nonatomic, assign) NSInteger accountPk;
@property (nonatomic, retain) NSString* node;
@property (nonatomic, retain) NSString* jid;
@property (nonatomic, retain) NSString* iname;
@property (nonatomic, retain) NSString* category;
@property (nonatomic, retain) NSString* type;

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
