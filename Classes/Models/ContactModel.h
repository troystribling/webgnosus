//
//  ContactModel.h
//  webgnosus
//
//  Created by Troy Stribling on 2/5/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "UserModel.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@class AccountModel;

//-----------------------------------------------------------------------------------------------------------------------------------
typedef enum {
    ContactIsOk,
    ContactHasError,
} ContactState;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ContactModel : UserModel {
    NSString* latestClient;
	NSInteger accountPk;
    ContactState contactState;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, assign) NSInteger accountPk;
@property (nonatomic, retain) NSString* latestClient;
@property (nonatomic, assign) ContactState contactState;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)count;
+ (void)drop;
+ (void)create;
+ (NSMutableArray*)findAll;
+ (NSMutableArray*)findAllByAccount:(AccountModel*)account;
+ (ContactModel*)findByPk:(NSInteger)requestPk;
+ (ContactModel*)findByJid:(NSString*)requestJid andAccount:(AccountModel*)account;
+ (void)destroyAllByAccount:(AccountModel*)account;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insert;
- (void)destroy;
- (void)load;
- (void)update;
- (AccountModel*)account;
- (BOOL)hasError;

@end
