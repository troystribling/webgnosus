//
//  XMPPCommand.m
//  webgnosus
//
//  Created by Troy Stribling on 3/29/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "NSXMLElementAdditions.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@class XMPPxData;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPCommand : NSXMLElement 

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPCommand*)createFromElement:(NSXMLElement*)element;
- (XMPPCommand*)initWithNode:(NSString*)cmdNode andAction:(NSString*)cmdAction;
- (XMPPCommand*)initWithNode:(NSString*)cmdNode action:(NSString*)cmdAction andData:(XMPPxData*)cmdData;
- (XMPPCommand*)initWithNode:(NSString*)cmdNode action:(NSString*)cmdAction data:(XMPPxData*)cmdData andStatus:(NSString*)cmdStatus;

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)node;
- (void)addNode:(NSString*)val;

- (NSString*)action;
- (void)addAction:(NSString*)val;

- (NSString*)status;
- (void)addStatus:(NSString*)val;

- (XMPPxData*)data;
- (void)addData:(XMPPxData*)child;

@end
