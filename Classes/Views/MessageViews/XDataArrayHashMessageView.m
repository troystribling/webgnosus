//
//  XDataArrayHashMessageView.m
//  webgnosus
//
//  Created by Troy Stribling on 10/24/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XDataArrayHashMessageView.h"
#import "LabelGridView.h"
#import "XMPPxData.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XDataArrayHashMessageView (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XDataArrayHashMessageView

//-----------------------------------------------------------------------------------------------------------------------------------

//===================================================================================================================================
#pragma mark XDataArrayHashMessageView

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)initLabelGridView:(LabelGridView*)labelGridView {
    [labelGridView setCellColor:[UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1.0f] forRow:0];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)buildGridArray:(XMPPxData*)data {
    NSMutableArray* itemsArray = [data items];
    NSMutableArray* header = [data reported];
    NSMutableArray* gridArray = [NSMutableArray arrayWithCapacity:[itemsArray count]];
    NSMutableArray* gridRow = [NSMutableArray arrayWithCapacity:[header count]];
    for(int i = 0; i < [header count]; i++) {
        [gridRow addObject:[header objectAtIndex:i]];
    }
    [gridArray addObject:gridRow];
    for(int i = 0; i < [itemsArray count]; i++) {
        NSMutableArray* fieldHash = [itemsArray objectAtIndex:i];
        NSMutableArray* gridRow = [NSMutableArray arrayWithCapacity:[fieldHash count]];
        for(int j = 0; j < [fieldHash count]; j++) {
            NSMutableArray* attrs = [fieldHash objectAtIndex:j];
            [gridRow addObject:[self stringifyArray:[attrs lastObject]]];
        }
        [gridArray addObject:gridRow];
    }
    return gridArray;
}

//===================================================================================================================================
#pragma mark XDataArrayHashMessageView PrivateAPI

//===================================================================================================================================
#pragma mark XDataMessageView

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
