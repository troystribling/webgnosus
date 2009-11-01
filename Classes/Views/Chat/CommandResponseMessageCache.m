//
//  CommandResponseMessageCache.m
//  webgnosus
//
//  Created by Troy Stribling on 10/31/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "CommandResponseMessageCache.h"
#import "MessageModel.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation CommandResponseMessageCache

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize jid;

//===================================================================================================================================
#pragma mark CommandResponseMessageCache

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithJid:(NSString*)initJid andAccount:(AccountModel*)initAccount {
	if(self = [super initWithAccount:initAccount]) {
        self.jid = initJid;
        [self load];
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSArray*)addMessages {
    return [MessageModel findAllCommandsByJid:self.jid forAccount:self.account withPkGreaterThan:self.lastPk andLimit:self.cacheIncrement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)totalCount {
    return [MessageModel countCommandsByJid:self.jid andAccount:self.account];
}

@end
