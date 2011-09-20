//
//  XMPPEntry.h
//  webgnosus
//
//  Created by Troy Stribling on 10/2/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "NSXMLElementAdditions.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@class XMPPClient;
@class XMPPJID;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPEntry : NSXMLElement 

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPEntry*)createFromElement:(NSXMLElement*)element;
+ (XMPPEntry*)messageWithTitle:(NSString*)msgTitle;
- (XMPPEntry*)init;
- (XMPPEntry*)initWithTitle:(NSString*)msgTitle;

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)title;
- (void)addTitle:(NSString*)val;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)publish:(XMPPClient*)client JID:(XMPPJID*)jid node:(NSString*)node withTitle:(NSString*)title;

@end
