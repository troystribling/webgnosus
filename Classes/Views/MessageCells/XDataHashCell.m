//
//  XDataHashCell.m
//  webgnosus_client
//
//  Created by Troy Stribling on 4/16/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XDataHashCell.h"
#import "LabelGridView.h"
#import "XMPPxData.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XDataHashCell (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XDataHashCell

//-----------------------------------------------------------------------------------------------------------------------------------

//===================================================================================================================================
#pragma mark XDataHashCell

//===================================================================================================================================
#pragma mark XDataHashCell PrivateAPI

//===================================================================================================================================
#pragma mark XDataMessageLabelCell

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)initLabelGridView:(LabelGridView*)labelGridView {
    [labelGridView setCellColor:[UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1.0f] forColumn:0];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)buildGridArray:(XMPPxData*)data {
    NSMutableDictionary* fieldHash = [data fields];
    NSMutableArray* gridArray = [NSMutableArray arrayWithCapacity:[fieldHash count]];
    NSMutableArray* attrs = [self removeUnderscores:[fieldHash allKeys]];
    for(int j = 0; j < [attrs count]; j++) {
        NSString* attr = [attrs objectAtIndex:j];
        NSString* val = [self formatMessageAttribute:attr value:[[fieldHash objectForKey:attr] lastObject]];
        [gridArray addObject:[NSMutableArray arrayWithObjects:attr, val, nil]];
    }
    return gridArray;
}

//===================================================================================================================================
#pragma mark XDataMessageLabelGridView

//===================================================================================================================================
#pragma mark UITableViewCell

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
