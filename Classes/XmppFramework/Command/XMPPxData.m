//
//  XMPPData.m
//  webgnosus
//
//  Created by Troy Stribling on 3/29/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPxData.h"
#import "XMPPxDataField.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPxData (PrivateAPI)

- (NSMutableArray*)hashifyFields:(NSXMLElement*)structElement;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPxData

//-----------------------------------------------------------------------------------------------------------------------------------

//===================================================================================================================================
#pragma mark XMPPxData

//-----------------------------------------------------------------------------------------------------------------------------------
+ (XMPPxData*)createFromElement:(NSXMLElement*)element {
	XMPPxData* result = (XMPPxData*)element;
	result->isa = [XMPPxData class];
	return result;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPxData*)init {
	if(self = [super initWithName:@"x"]) {
        [self addNamespace:[NSXMLNode namespaceWithName:@"" stringValue:@"jabber:x:data"]];
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPxData*)initWithDataType:(NSString*)dataType {
	if([self init]) {
		[self addDataType:dataType];
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)dataType {
    return [[self attributeForName:@"type"] stringValue];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addDataType:(NSString*)val {
    [self addAttributeWithName:@"type" stringValue:val];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSMutableArray*)fieldsToArrayOfHashes {
    return [self hashifyFields:self];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSMutableArray*)fields {
    NSArray* fieldElementArray = [self elementsForName:@"field"];
    NSMutableArray* fieldArray = [NSMutableArray arrayWithCapacity:[fieldElementArray count]];
    if (fieldElementArray) {
        for(int i = 0; i < [fieldElementArray count]; i++) {
            XMPPxDataField* field = [XMPPxDataField createFromElement:[fieldElementArray objectAtIndex:i]];
            [fieldArray addObject:field];
        }
    }
    return fieldArray;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addFields:(NSArray*)fieldArray {
    for(int i = 0; i < [fieldArray count]; i++) {
        XMPPxDataField* field = [fieldArray objectAtIndex:i];
        [self addChild:field];	
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSMutableArray*)reported {
    NSArray* reportedElements = [[self elementForName:@"reported"]  elementsForName:@"field"];
    NSMutableArray* reportedArray = [NSMutableArray arrayWithCapacity:[reportedElements count]];
    if (reportedElements) {
        for(int i = 0; i < [reportedElements count]; i++) {
            NSXMLElement* reportedElement = [reportedElements objectAtIndex:i];
            [reportedArray addObject:[[reportedElement attributeForName:@"var"] stringValue]];
        }
    }
    return reportedArray;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSMutableArray*)items {
    NSArray* itemElementArray = [self elementsForName:@"item"];
    NSMutableArray* itemArray = [NSMutableArray arrayWithCapacity:[itemElementArray count]];
    if (itemElementArray) {
        for(int i = 0; i < [itemElementArray count]; i++) {
            [itemArray addObject:[self hashifyFields:[itemElementArray objectAtIndex:i]]];
        }
    }
    return itemArray;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)title {
	return [[self elementForName:@"title"] stringValue];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)instructions {
	return [[self elementForName:@"instructions"] stringValue];
}

//===================================================================================================================================
#pragma mark XMPPxData PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSMutableArray*)hashifyFields:(NSXMLElement*)fieldsElement {
    NSArray* fieldArray = [fieldsElement elementsForName:@"field"];
    NSMutableArray* fieldHash = [NSMutableArray arrayWithCapacity:[fieldArray count]];
    if (fieldArray) {
        for(int i = 0; i < [fieldArray count]; i++) {
            NSXMLElement* fieldElement = [fieldArray objectAtIndex:i];
            NSString* field = [[fieldElement attributeForName:@"var"] stringValue];
            NSArray* valElements = [fieldElement elementsForName:@"value"];
            if (valElements) {
                NSMutableArray* vals = [NSMutableArray arrayWithCapacity:[valElements count]];
                for(int i = 0; i < [valElements count]; i++) {
                    [vals addObject:[[valElements objectAtIndex:i] stringValue]];
                }
                if (field) {
                    [fieldHash addObject:[NSMutableArray arrayWithObjects:field, vals, nil]];
                } else {
                    [fieldHash addObject:[NSMutableArray arrayWithObjects:vals, nil]];
                }
            }
        }
    }
    return fieldHash;
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
