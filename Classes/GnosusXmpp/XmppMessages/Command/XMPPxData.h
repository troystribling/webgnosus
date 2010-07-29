//
//  XMPPxData.m
//  webgnosus
//
//  Created by Troy Stribling on 3/29/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "NSXMLElementAdditions.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPxData : NSXMLElement 

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPxData*)createFromElement:(NSXMLElement*)element;
- (XMPPxData*)init;
- (XMPPxData*)initWithDataType:(NSString*)dataType;

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)dataType;
- (void)addDataType:(NSString*)val;
- (NSMutableArray*)fieldsToArrayOfHashes;
- (NSMutableArray*)fields;
- (void)addFields:(NSArray*)fieldArray;
- (NSMutableArray*)reported;
- (NSMutableArray*)items;
- (NSString*)title;
- (NSString*)instructions;

@end
