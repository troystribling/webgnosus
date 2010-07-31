//
//  XMPPGeoLoc.m
//  webgnosus
//
//  Created by Troy Stribling on 3/29/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPGeoLoc.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPGeoLoc (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPGeoLoc

//-----------------------------------------------------------------------------------------------------------------------------------

//===================================================================================================================================
#pragma mark XMPPGeoLoc

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPGeoLoc*)createFromElement:(NSXMLElement*)element {
	XMPPGeoLoc* result = (XMPPxData*)element;
	result->isa = [XMPPGeoLoc class];
	return result;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPGeoLoc*)init {
	if(self = [super initWithName:@"geoloc"]) {
        [self addNamespace:[NSXMLNode namespaceWithName:@"" stringValue:@"http://jabber.org/protocol/geoloc"]];
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (double)lat {
	return [[[self elementForName:@"lat"] stringValue] doubleValue];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addLat:(double)val {
	[self addChild:[NSXMLElement elementWithName:@"lat" stringValue:[NSString stringWithFormat:@"%f", val]]];	
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (double)lon {
	return [[[self elementForName:@"lon"] stringValue] doubleValue];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addLon:(double)val {
	[self addChild:[NSXMLElement elementWithName:@"lon" stringValue:[NSString stringWithFormat:@"%f", val]]];	
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (double)accuracy {
	return [[[self elementForName:@"accuracy"] stringValue] doubleValue];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addAccuracy:(double)val {
	[self addChild:[NSXMLElement elementWithName:@"accuracy" stringValue:[NSString stringWithFormat:@"%f", val]]];	
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (double)bearing {
	return [[[self elementForName:@"bearing"] stringValue] doubleValue];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addBearing:(double)val {
	[self addChild:[NSXMLElement elementWithName:@"bearing" stringValue:[NSString stringWithFormat:@"%f", val]]];	
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)locality {
    return [[self elementForName:@"locality"] stringValue];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addLocality:(NSString*)val {
    [self addChild:[NSXMLElement elementWithName:@"locality" stringValue:val]];	
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)country {
    return [[self elementForName:@"country"] stringValue];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addCountry:(NSString*)val {
    [self addChild:[NSXMLElement elementWithName:@"contry" stringValue:val]];	
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSDate*)timestamp {
	return [[[self elementForName:@"timestamp"] stringValue] doubleValue];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addTimestamp:(NSDate*)val {
	[self addChild:[NSXMLElement elementWithName:@"timestamp" stringValue:[val description]]];	
}

//===================================================================================================================================
#pragma mark XMPPGeoLoc PrivateAPI


//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
