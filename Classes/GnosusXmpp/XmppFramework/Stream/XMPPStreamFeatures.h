//
//  XMPPStreamFeatures.m
//  webgnosus
//
//  Created by Troy Stribling on 3/29/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "DDXML.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPStreamFeatures : NSXMLElement 

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPStreamFeatures*)createFromElement:(NSXMLElement*)element;
- (XMPPStreamFeatures*)init;

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSArray*)mechanisms;
- (BOOL)supportsInBandRegistration;
- (BOOL)supportsPlainAuthentication;
- (BOOL)supportsDigestMD5Authentication;
- (BOOL)supportsTLS;
- (BOOL)requiresTLS;
- (BOOL)requiresBind;
- (BOOL)supportsSession;
@end
