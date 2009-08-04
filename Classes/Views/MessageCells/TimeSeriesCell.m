//
//  TimeSeriesCell.m
//  webgnosus_client
//
//  Created by Troy Stribling on 5/12/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "TimeSeriesCell.h"
#import "TimeSeriesGraphView.h"
#import "TimeSeries.h"
#import "MessageModel.h"
#import "CellUtils.h"
#import "Commands.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface TimeSeriesCell (PrivateAPI)

+ (NSString*)monitorPeriod:(TimeSeriesGraphView*)graphView;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TimeSeriesCell

//-----------------------------------------------------------------------------------------------------------------------------------

//===================================================================================================================================
#pragma mark TimeSeriesCell

//-----------------------------------------------------------------------------------------------------------------------------------
+ (CGFloat)tableView:(UITableView *)tableView heightForRowWithMessage:(MessageModel*)message {
    return kTIME_SERIES_HEIGHT + kTIME_SERIES_CELL_HEIGHT_PAD;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath forMessage:(MessageModel*)message {        
    TimeSeriesCell* cell = (TimeSeriesCell*)[CellUtils createCell:[TimeSeriesCell class] forTableView:tableView];
    TimeSeries* timeSeries = [[TimeSeries alloc] initWithMessage:message];
    if ([timeSeries length] > 0) {
        TimeSeriesGraphView* graphView = 
        [[TimeSeriesGraphView alloc] initWithFrame:CGRectMake(kTIME_SERIES_X_OFFSET, kTIME_SERIES_Y_OFFSET, kDISPLAY_WIDTH, kTIME_SERIES_HEIGHT) timeSeries:timeSeries
                                           andFont:[UIFont fontWithName:[NSString stringWithUTF8String:kTIME_SERIES_LABEL_FONT] size:kTIME_SERIES_TITLE_SIZE]];
        [graphView setViewBackgroundColor:[UIColor colorWithRed:0.94f green:0.94f blue:0.92f alpha:1.0f]];
        NSMutableDictionary* command = [[Commands instance] commandWithName:message.node];
        NSString* unit = [command  objectForKey:@"unit"];
        if ([unit isEqualToString:@""]) {
            graphView.title.text = [NSString  stringWithFormat:@"%@", [command  objectForKey:@"description"]];
        } else {
            graphView.title.text = [NSString  stringWithFormat:@"%@ (%@)", [command  objectForKey:@"description"], [command  objectForKey:@"unit"]];
        }
        [graphView setLineWidth:kTIME_SERIES_GRAPH_LINE_WIDTH];
        [cell setJidAndTime:message];
        [cell addSubview:graphView];
        [graphView release];
    }
    [timeSeries release];
    return cell;
}

//===================================================================================================================================
#pragma mark TimeSeriesCell PrivateAPI

//===================================================================================================================================
#pragma mark UITableViewCell


@end
