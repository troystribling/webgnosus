//
//  XMPPxDataField.h
//  webgnosus
//
//  Created by Troy Stribling on 11/6/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "NSXMLElementAdditions.h"

//-----------------------------------------------------------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPxDataField : NSXMLElement 

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPxDataField*)createFromElement:(NSXMLElement*)element;
- (XMPPxDataField*)initWithType:(NSString*)initType andVar:(NSString*)initVar;
- (XMPPxDataField*)initWithType:(NSString*)initType var:(NSString*)initVar andValues:(NSArray*)initValues;

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)type;
- (void)addType:(NSString*)val;
- (NSString*)label;
- (void)addLabel:(NSString*)val;
- (NSString*)var;
- (void)addVar:(NSString*)val;
- (NSArray*)values;
- (void)addValues:(NSArray*)val;
- (NSDictionary*)options;

@end
