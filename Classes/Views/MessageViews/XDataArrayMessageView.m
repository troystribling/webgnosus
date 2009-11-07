//
//  XDataArrayMessageView.m
//  webgnosus
//
//  Created by Troy Stribling on 10/24/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XDataArrayMessageView.h"
#import "LabelGridView.h"
#import "XMPPxData.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XDataArrayMessageView (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XDataArrayMessageView

//-----------------------------------------------------------------------------------------------------------------------------------

//===================================================================================================================================
#pragma mark XDataArrayMessageView

//===================================================================================================================================
#pragma mark XDataArrayMessageView PrivateAPI

//===================================================================================================================================
#pragma mark XDataMessageView

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)initLabelGridView:(LabelGridView*)labelGridView {
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)buildGridArray:(XMPPxData*)data {
    NSMutableArray* valArray = [[[data fieldsToArrayOfHashes] lastObject] lastObject];
    NSMutableArray* gridArray = [NSMutableArray arrayWithCapacity:1];
    for(int j = 0; j < [valArray count]; j++) {
        NSMutableArray* val = [valArray objectAtIndex:j];
        [gridArray addObject:[NSMutableArray arrayWithObjects:val, nil]];
    }
    return gridArray;
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
