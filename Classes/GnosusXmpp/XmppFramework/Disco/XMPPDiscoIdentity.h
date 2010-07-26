//
//  XMPPDiscoIdentity.h
//  webgnosus
//
//  Created by Troy Stribling on 8/4/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "NSXMLElementAdditions.h"

//-----------------------------------------------------------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPDiscoIdentity : NSXMLElement

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPDiscoIdentity*)createFromElement:(NSXMLElement*)element;
- (XMPPDiscoIdentity*)initWithCategory:(NSString*)identCategory;
- (XMPPDiscoIdentity*)initWithCategory:(NSString*)identCategory andIname:(NSString*)identIname;
- (XMPPDiscoIdentity*)initWithCategory:(NSString*)identCategory iname:(NSString*)identIname andType:(NSString*)identType;
- (XMPPDiscoIdentity*)initWithCategory:(NSString*)identCategory iname:(NSString*)identIname node:(NSString*)identNode andType:(NSString*)identType;

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)node;
- (void)addNode:(NSString*)val;

- (NSString*)iname;
- (void)addIname:(NSString*)val;

- (NSString*)category;
- (void)addCategory:(NSString*)val;

- (NSString*)type;
- (void)addType:(NSString*)val;

@end
