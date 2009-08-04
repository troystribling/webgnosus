//
//  LargestOpenFilesCell.m
//  webgnosus_client
//
//  Created by Troy Stribling on 5/25/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "LargestOpenFilesCell.h"
#import "LabelGridView.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation LargestOpenFilesCell

//===================================================================================================================================
#pragma mark LargestOpenFilesCell

//===================================================================================================================================
#pragma mark LargestOpenFilesCell PrivateAPI

//===================================================================================================================================
#pragma mark XDataMessageLabelGridView

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)messageAttributesToHeader {
    return [NSMutableArray arrayWithObjects: @"command", @"file", @"size(MB)", nil];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSString*)formatMessageAttribute:(NSString*)attr value:(NSString*)val {
    NSString* formatedVal = val;
    if ([attr isEqualToString:@"size"]) {
        formatedVal = [NSString stringWithFormat:@"%d", [val intValue]];
    }
    return formatedVal;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)initLabelGridView:(LabelGridView*)labelGridView {
    [labelGridView setLineBreakMode:UILineBreakModeHeadTruncation forColumn:1];
    [labelGridView setTextAlignment:UITextAlignmentCenter forColumn:2];
}

//===================================================================================================================================
#pragma mark XDataMessageLabelGridView Protocol

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)messageAttributes {
    return [NSMutableArray arrayWithObjects: @"command", @"file", @"size", nil];
}

//===================================================================================================================================
#pragma mark UITableViewCell

//===================================================================================================================================
#pragma mark NSObject

@end
