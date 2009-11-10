//
//  XMPPxDataField.m
//  webgnosus
//
//  Created by Troy Stribling on 11/6/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPxDataField.h"

//-----------------------------------------------------------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPxDataField

//-----------------------------------------------------------------------------------------------------------------------------------

//===================================================================================================================================
#pragma mark XMPPxDataField

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPxDataField*)createFromElement:(NSXMLElement*)element {
	XMPPxDataField* result = (XMPPxDataField*)element;
	result->isa = [XMPPxDataField class];
	return result;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPxDataField*)init {
	if(self = [super initWithName:@"field"]) {
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPxDataField*)initWithType:(NSString*)initType andVar:(NSString*)initVar {
	if(self = [self init]) {
        [self addType:initType];
        [self addVar:initVar];
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPxDataField*)initWithType:(NSString*)initType var:(NSString*)initVar andValues:(NSArray*)initValues {
	if(self = [self initWithType:initType andVar:initVar]) {
        [self addValues:initValues];
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)type {
    return [[self attributeForName:@"type"] stringValue];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addType:(NSString*)val {
    [self addAttributeWithName:@"type" stringValue:val];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)label {
    return [[self attributeForName:@"label"] stringValue];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addLabel:(NSString*)val {
    [self addAttributeWithName:@"label" stringValue:val];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)var {
    return [[self attributeForName:@"var"] stringValue];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addVar:(NSString*)val {
    [self addAttributeWithName:@"var" stringValue:val];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSArray*)values {
    NSArray* valElements = [self elementsForName:@"value"];
    NSMutableArray* vals = [NSMutableArray arrayWithCapacity:[valElements count]];
    if (valElements) {
        for(int i = 0; i < [valElements count]; i++) {
            [vals addObject:[[valElements objectAtIndex:i] stringValue]];
        }
    }
    return vals;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addValues:(NSArray*)vals {
    for(int i = 0; i < [vals count]; i++) {
        NSString* val = [vals objectAtIndex:i];
        [self addChild:[NSXMLElement elementWithName:@"value" stringValue:val]];	
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSDictionary*)options {
    NSArray* optElements = [self elementsForName:@"option"];
    NSMutableDictionary* opts = [NSMutableDictionary dictionaryWithCapacity:[optElements count]];
    if (optElements) {
        for(int i = 0; i < [optElements count]; i++) {
            NSXMLElement* optElement = [optElements objectAtIndex:i];
            NSString* label = [[optElement attributeForName:@"label"] stringValue];
            NSString* value = [[[optElement elementsForName:@"value"] lastObject]  stringValue];
            [opts setValue:value forKey:label];
        }
    }
    return opts;
}

@end
