//
//  UserModel.h
//  webgnosus
//
//  Created by Troy Stribling on 3/6/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import <sqlite3.h>

//-----------------------------------------------------------------------------------------------------------------------------------
@class XMPPJID;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface UserModel : NSObject {
	NSInteger pk;
	NSString* jid;
	NSString* resource;
    NSString* nickname;
	NSString* host;
    NSString* clientName;
    NSString* clientVersion;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, assign) NSInteger pk;
@property (nonatomic, retain) NSString* jid;
@property (nonatomic, retain) NSString* resource;
@property (nonatomic, retain) NSString* nickname;
@property (nonatomic, retain) NSString* host;
@property (nonatomic, retain) NSString* clientName;
@property (nonatomic, retain) NSString* clientVersion;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPJID*)nodeToJID:(NSString*)node;
- (NSString*)bareJID;
- (NSString*)fullJID;
- (XMPPJID*)toJID;
- (NSString*)pubSubRoot;
- (XMPPJID*)pubSubService;
- (NSString*)pubSubDomain;
- (void)load;

@end
