//
//  ProcessesUsingMostCpuCell.m
//  webgnosus_client
//
//  Created by Troy Stribling on 5/25/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "ProcessesUsingMostCpuCell.h"
#import "LabelGridView.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ProcessesUsingMostCpuCell

//===================================================================================================================================
#pragma mark ProcessesUsingMostMemoryCell

//===================================================================================================================================
#pragma mark ProcessesUsingMostMemoryCell PrivateAPI

//===================================================================================================================================
#pragma mark XDataMessageLabelGridView

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)messageAttributesToHeader {
    return [NSMutableArray arrayWithObjects: @"command", @"cpu(%)", @"mem(%)", nil];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)initLabelGridView:(LabelGridView*)labelGridView {
    [labelGridView setTextAlignment:UITextAlignmentCenter forColumn:1];
    [labelGridView setTextAlignment:UITextAlignmentCenter forColumn:2];
}

//===================================================================================================================================
#pragma mark XDataMessageLabelGridView Protocol

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)messageAttributes {
    return [NSMutableArray arrayWithObjects: @"command", @"cpu", @"memory", nil];
}

//===================================================================================================================================
#pragma mark UITableViewCell

//===================================================================================================================================
#pragma mark NSObject

@end
