//
//  XMPPError.m
//  webgnosus
//
//  Created by Troy Stribling on 3/29/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "DDXML.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPError : NSXMLElement 

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPError*)createFromElement:(NSXMLElement*)element;
- (XMPPError*)init;
- (XMPPError*)initWithType:(NSString*)errotType;

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)type;
- (void)addType:(NSString*)val;

- (NSString*)code;
- (void)addCode:(NSString*)val;

- (NSString*)condition;
- (void)addCondition:(NSString*)val;

- (NSString*)text;
- (void)addText:(NSString*)val;

@end
