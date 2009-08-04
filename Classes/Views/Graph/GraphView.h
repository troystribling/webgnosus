//
//  GraphView.h
//  webgnosus_client
//
//  Created by Troy Stribling on 4/18/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>
#import "GraphViewData.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@class TimeSeries;
@class GraphViewRectangle;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface GraphView : UIView {
    NSMutableArray* graphData;   
    NSMutableArray* rectangles;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) NSMutableArray* graphData;
@property (nonatomic, retain) NSMutableArray* rectangles;

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)frame;
- (void)addGraphData:(id<GraphViewData>)data;
- (void)addRect:(GraphViewRectangle*)rect;

@end
