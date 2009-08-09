//
//  XMPPDiscoItem.h
//  webgnosus
//
//  Created by Troy Stribling on 8/4/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "NSXMLElementAdditions.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@class XMPPJID;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPDiscoItem : NSXMLElement

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPDiscoItem*)createFromElement:(NSXMLElement*)element;
- (XMPPDiscoItem*)initWithJID:(NSString*)itemJID;
- (XMPPDiscoItem*)initWithJID:(NSString*)itemJID andIname:(NSString*)itemIname;
- (XMPPDiscoItem*)initWithJID:(NSString*)itemJID iname:(NSString*)itemIname andNode:(NSString*)itemNode;

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)node;
- (void)addNode:(NSString*)val;

- (NSString*)iname;
- (void)addIname:(NSString*)val;

- (XMPPJID*)JID;
- (void)addJID:(NSString*)val;

@end
