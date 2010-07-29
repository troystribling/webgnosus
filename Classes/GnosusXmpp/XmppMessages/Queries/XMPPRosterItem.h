//
//  XMPPRosterItem.m
//  webgnosus
//
//  Created by Troy Stribling on 3/29/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "DDXML.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@class XMPPJID;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPRosterItem : NSXMLElement 

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPRosterItem*)createFromElement:(NSXMLElement*)element;
- (XMPPRosterItem*)initWithJID:(NSString*)itemJID;
- (XMPPRosterItem*)initWithJID:(NSString*)itemJID andSubscription:(NSString*)itemSubscrition;

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPJID*)jid;
- (void)addJID:(NSString*)val;

- (NSString*)nickname;
- (void)addNickname:(NSString*)val;

- (NSString*)subscription;
- (void)addSubscription:(NSString*)val;

@end
