//
//  XDataArrayHashCell.m
//  webgnosus
//
//  Created by Troy Stribling on 9/29/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XDataArrayHashCell.h"
#import "LabelGridView.h"
#import "XMPPxData.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XDataArrayHashCell (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XDataArrayHashCell

//-----------------------------------------------------------------------------------------------------------------------------------

//===================================================================================================================================
#pragma mark XDataArrayHashCell

//===================================================================================================================================
#pragma mark XDataArrayHashCell PrivateAPI

//===================================================================================================================================
#pragma mark XDataMessageLabelCell

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)initLabelGridView:(LabelGridView*)labelGridView {
    [labelGridView setHeaderColor:[UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1.0f]]; 
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)buildGridArray:(XMPPxData*)data {
    NSMutableArray* itemsArray = [data items];
    NSMutableArray* gridArray = [NSMutableArray arrayWithCapacity:[itemsArray count]];
    for(int i = 0; i < [itemsArray count]; i++) {
        NSMutableDictionary* fieldHash = [itemsArray objectAtIndex:i];
        NSMutableArray* gridRow = [NSMutableArray arrayWithCapacity:[fieldHash count]];
//        for(int j = 0; j < [attrs count]; j++) {
//            NSString* attr = [attrs objectAtIndex:j];
//            [gridRow addObject:[self formatMessageAttribute:attr value:[[fieldHash objectForKey:attr] lastObject]]];
//        }
        [gridArray addObject:gridRow];
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
