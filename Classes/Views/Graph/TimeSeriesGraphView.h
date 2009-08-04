//
//  TimeSeriesGraphView.h
//  webgnosus_client
//
//  Created by Troy Stribling on 4/18/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

//-----------------------------------------------------------------------------------------------------------------------------------
@class TimeSeries;
@class GraphView;
@class ConstantTimeSeries;
@class LabelGridView;
@class GraphViewRectangle;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface TimeSeriesGraphView : UIView {
    TimeSeries* timeSeries;
    ConstantTimeSeries* averageSeries;
    ConstantTimeSeries* sigmaSeriesTop;
    ConstantTimeSeries* sigmaSeriesBottom;
    GraphViewRectangle* sigmaRect;
    UILabel* title;
    LabelGridView* statGrid;
    UIFont* font;
    GraphView* timeSeriesGraphView;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) TimeSeries* timeSeries;
@property (nonatomic, retain) ConstantTimeSeries* averageSeries;
@property (nonatomic, retain) ConstantTimeSeries* sigmaSeriesTop;
@property (nonatomic, retain) ConstantTimeSeries* sigmaSeriesBottom;
@property (nonatomic, retain) GraphViewRectangle* sigmaRect;
@property (nonatomic, retain) UILabel* title;
@property (nonatomic, retain) UIFont* font;
@property (nonatomic, retain) LabelGridView* statGrid;
@property (nonatomic, retain) GraphView* timeSeriesGraphView;

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)frame timeSeries:(TimeSeries*)timeSeies andFont:(UIFont*)statFont;
- (void)setLineWidth:(CGFloat)lineWidth;
- (void)setLineColor:(UIColor*)color;
- (void)setViewBackgroundColor:(UIColor*)color;
- (void)setAverageColor:(UIColor*)color;
- (void)setSigmaColor:(UIColor*)color;

@end
