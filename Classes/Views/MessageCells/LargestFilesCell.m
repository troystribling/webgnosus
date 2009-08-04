//
//  LargestFilesCell.m
//  webgnosus_client
//
//  Created by Troy Stribling on 5/25/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "LargestFilesCell.h"
#import "LabelGridView.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation LargestFilesCell

//===================================================================================================================================
#pragma mark ListeningTcpSocketsCell

//===================================================================================================================================
#pragma mark ListeningTcpSocketsCell PrivateAPI

//===================================================================================================================================
#pragma mark XDataMessageLabelGridView

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)messageAttributesToHeader {
    return [NSMutableArray arrayWithObjects: @"file", @"size(MB)", nil];
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
    [labelGridView setLineBreakMode:UILineBreakModeHeadTruncation forColumn:0];
    [labelGridView setTextAlignment:UITextAlignmentCenter forColumn:1];
}

//===================================================================================================================================
#pragma mark XDataMessageLabelGridView Protocol

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)messageAttributes {
    return [NSMutableArray arrayWithObjects: @"file", @"size", nil];
}

//===================================================================================================================================
#pragma mark UITableViewCell

//===================================================================================================================================
#pragma mark NSObject

@end
