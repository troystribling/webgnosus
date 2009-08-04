//
//  TimeSeriesGraphView.m
//  webgnosus_client
//
//  Created by Troy Stribling on 5/10/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "TimeSeriesGraphView.h"
#import "TimeSeries.h"
#import "GraphViewRectangle.h"
#import "ConstantTimeSeries.h"
#import "LabelGridView.h"
#import "GraphView.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface TimeSeriesGraphView (PrivateAPI)

- (void)createLabel;
- (void)createGraph;
- (NSString*)monitorPeriod:(NSUInteger)timeMax;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TimeSeriesGraphView

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize timeSeries;
@synthesize averageSeries;
@synthesize sigmaSeriesTop;
@synthesize sigmaSeriesBottom;
@synthesize sigmaRect;
@synthesize title;
@synthesize statGrid;
@synthesize font;
@synthesize timeSeriesGraphView;

//===================================================================================================================================
#pragma mark TimeSeriesGraphView

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)frame timeSeries:(TimeSeries*)series andFont:(UIFont*)statFont {
    if (self = [super initWithFrame:frame]) {
        self.timeSeries = series;
        self.font = statFont;
        [self createGraph];
        [self createLabel];
        [self setSigmaColor:[UIColor colorWithRed:1.0f green:0.4f blue:0.0 alpha:1.0f]];
        [self setAverageColor:[UIColor colorWithRed:0.2f green:0.2f blue:1.0f alpha:1.0f]];
        [self setLineColor:[UIColor colorWithWhite:0.5f alpha:1.0f]];
    }
    return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setViewBackgroundColor:(UIColor*)color {
    self.backgroundColor = color;
    self.title.backgroundColor = color;
    self.timeSeriesGraphView.backgroundColor = color;
    [self.statGrid setCellColor:color];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setLineWidth:(CGFloat)lineWidth {
    self.timeSeries.lineWidth = lineWidth;
    self.averageSeries.lineWidth = lineWidth;
    self.sigmaSeriesTop.lineWidth = lineWidth;
    self.sigmaSeriesBottom.lineWidth = lineWidth;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setLineColor:(UIColor*)color {
    self.timeSeries.lineColor = color;
    UILabel* maxLabel = (UILabel*)[self.statGrid viewForRow:0 andColumn:1];
    UILabel* timeLabel = (UILabel*)[self.statGrid viewForRow:0 andColumn:2];
    UILabel* minLabel = (UILabel*)[self.statGrid viewForRow:1 andColumn:1];
    maxLabel.textColor = color;
    timeLabel.textColor = color;
    minLabel.textColor = color;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setTitleColor:(UIColor*)color {
    self.title.textColor = color;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setAverageColor:(UIColor*)color {
    self.averageSeries.lineColor = color;
    UILabel* averageLabel = (UILabel*)[self.statGrid viewForRow:0 andColumn:0];
    averageLabel.textColor = color;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setSigmaColor:(UIColor*)color {
    self.sigmaSeriesTop.lineColor = color;
    self.sigmaSeriesBottom.lineColor = color;
    CGColorRef lineColor = color.CGColor;
    self.sigmaRect.rectColor = [UIColor colorWithCGColor:CGColorCreateCopyWithAlpha(lineColor, 0.05f*CGColorGetAlpha(lineColor))];
    UILabel* sigmaLabel = (UILabel*)[self.statGrid viewForRow:1 andColumn:0];
    sigmaLabel.textColor = color;
}

//===================================================================================================================================
#pragma mark TimeSeriesGraphView PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)createLabel {
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(kTIME_SERIES_LABEL_X_OFFSET, kTIME_SERIES_LABEL_Y_OFFSET, kTIME_SERIES_LABEL_WIDTH, kTIME_SERIES_LABEL_HEIGHT)];
    self.title.textAlignment = UITextAlignmentLeft;
    self.title.font = self.font;

    NSMutableArray* statLabelText = [[NSMutableArray alloc] initWithCapacity:10];
    [statLabelText addObject:[NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%6.2f", self.timeSeries.average], [NSString stringWithFormat:@"%6.2f", self.timeSeries.valueMax], 
                              [self monitorPeriod:self.timeSeries.timeMax], nil]];
    [statLabelText addObject:[NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%6.2f", self.timeSeries.sigma], [NSString stringWithFormat:@"%6.2f", self.timeSeries.valueMin], @"", nil]];
    
     
    UIFont* dataFontSize = [self.font fontWithSize:0.9f*self.font.pointSize];
    NSMutableArray* statLabels = [LabelGridView buildViews:statLabelText labelOffSet:1.0f labelHeight:kTIME_SERIES_STAT_CELL_HEIGHT andFont:dataFontSize];
    self.statGrid = [[LabelGridView alloc] initWithLabelViews:statLabels borderWidth:0.0f maxWidth:kTIME_SERIES_STAT_CELL_WIDTH gridXOffset:kTIME_SERIES_STAT_CELL_X_OFFSET + kTIME_SERIES_GRAPH_WIDTH 
                                               andGridYOffset:kTIME_SERIES_STAT_CELL_Y_OFFSET];
    for (int i = 0; i < 3; i++) {
        [self.statGrid setTextAlignment:UITextAlignmentRight forColumn:i];
    }
    
    [self addSubview:self.title];
    [self addSubview:self.statGrid];
    [statLabelText release];
    [statLabels release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)createGraph {
    self.timeSeriesGraphView = 
        [[GraphView alloc] initWithFrame:CGRectMake(kTIME_SERIES_GRAPH_X_OFFSET, kTIME_SERIES_LABEL_HEIGHT+kTIME_SERIES_GRAPH_Y_OFFSET, kTIME_SERIES_GRAPH_WIDTH, kTIME_SERIES_GRAPH_HEIGHT)];
    GraphViewDataRange timeRange = {self.timeSeries.timeMin, self.timeSeries.timeMax, self.timeSeries.timeMax-self.timeSeries.timeMin};
    GraphViewDataRange sigmaRectRange = {self.timeSeries.average-self.timeSeries.sigma, self.timeSeries.average+self.timeSeries.sigma, 2*self.timeSeries.sigma};
    self.averageSeries = [[ConstantTimeSeries alloc] initWithValue:self.timeSeries.average timeRange:timeRange];
    self.sigmaSeriesTop = [[ConstantTimeSeries alloc] initWithValue:(self.timeSeries.average + self.timeSeries.sigma) timeRange:timeRange];
    self.sigmaSeriesBottom = [[ConstantTimeSeries alloc] initWithValue:(self.timeSeries.average - self.timeSeries.sigma) timeRange:timeRange];
    self.sigmaRect = [[GraphViewRectangle alloc] initWithXRange:timeRange andYRange:sigmaRectRange];
    [self.timeSeriesGraphView addGraphData:self.timeSeries];
    [self.timeSeriesGraphView addGraphData:self.averageSeries];
    [self.timeSeriesGraphView addGraphData:self.sigmaSeriesTop];
    [self.timeSeriesGraphView addGraphData:self.sigmaSeriesBottom];
    [self.timeSeriesGraphView addRect:self.sigmaRect];
    [self addSubview:self.timeSeriesGraphView];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)monitorPeriod:(NSUInteger)timeMax {
    NSString* periodString = nil;
    NSUInteger period = (NSUInteger)(timeMax / 3600);
    if (period > 0) {
        periodString = [NSString stringWithFormat:@" %dh", period + 1];
    } else {
        period = (NSUInteger)(timeMax / 60);
        if (period > 0) {
            periodString = [NSString stringWithFormat:@" %dm", period + 1];
        } else { 
            period = (NSUInteger)(timeMax);
            periodString = [NSString stringWithFormat:@" %ds", period + 1];
        }
    }
    return periodString;
}

//===================================================================================================================================
#pragma mark UIView

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)drawRect:(CGRect)rect {
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
