//
//  XMPPxData.m
//  webgnosus_client
//
//  Created by Troy Stribling on 3/29/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "DDXML.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPxData : NSXMLElement 

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPxData*)createFromElement:(NSXMLElement*)element;
- (XMPPxData*)init;
- (XMPPxData*)initWithDataType:(NSString*)dataType;

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)dataType;
- (void)addDataType:(NSString*)val;

- (NSMutableDictionary*)fields;
- (void)addField:(NSString*)fieldVal withValue:(NSString*)val;

- (NSMutableArray*)reported;

- (NSMutableArray*)items;

@end
