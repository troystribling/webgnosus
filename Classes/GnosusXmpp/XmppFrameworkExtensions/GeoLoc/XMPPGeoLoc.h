//
//  XMPPGeoLoc.m
//  webgnosus
//
//  Created by Troy Stribling on 3/29/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "NSXMLElementAdditions.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@class XMPPClient;
@class AccountModel;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPGeoLoc : NSXMLElement 

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPGeoLoc*)createFromElement:(NSXMLElement*)element;

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPGeoLoc*)init;
- (double)lat;
- (void)addLat:(double)val;
- (double)lon;
- (void)addLon:(double)val;
- (double)alt;
- (void)addAlt:(double)val;
- (double)accuracy;
- (void)addAccuracy:(double)val;
- (double)bearing;
- (void)addBearing:(double)val;
- (NSString*)locality;
- (void)addLocality:(NSString*)val;
- (NSString*)country;
- (void)addCountry:(NSString*)val;
- (NSDate*)timestamp;
- (void)addTimestamp:(NSDate*)val;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)publish:(XMPPClient*)client forAccount:(AccountModel*)account withData:(XMPPGeoLoc*)data;

@end
