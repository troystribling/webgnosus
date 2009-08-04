//
//  GraphView.m
//  webgnosus_client
//
//  Created by Troy Stribling on 5/10/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "GraphView.h"
#import "TimeSeries.h"
#import "GraphViewRectangle.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface GraphView (PrivateAPI)

- (CGPoint)xMin;
- (CGPoint)xMax;
- (CGFloat)xDataAtIndex:(NSUInteger)i scaledByViewWidth:(CGFloat)height xMin:(CGFloat)xMin andXMax:(CGFloat)xMax;
- (CGFloat)yDataAtIndex:(NSUInteger)i scaledByViewHeight:(CGFloat)height yMin:(CGFloat)yMin andYMax:(CGFloat)yMax;
- (CGRect)rectAtIndex:(NSUInteger)i scaledByView:(CGRect)viewRect xRange:(GraphViewDataRange)plotXRange andYRange:(GraphViewDataRange)plotYRange;
- (CGFloat)scaleValue:(CGFloat)val by:(CGFloat)scaleFactor andRange:(GraphViewDataRange)range;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation GraphView

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize graphData;
@synthesize rectangles;

//===================================================================================================================================
#pragma mark GraphView

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addGraphData:(id<GraphViewData>)data {
    [self.graphData addObject:data];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addRect:(GraphViewRectangle*)rect {
    [self.rectangles addObject:rect];
}

//===================================================================================================================================
#pragma mark GraphView PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (GraphViewDataRange)xRange {
    GraphViewDataRange range = [[self.graphData lastObject] xRange];
    CGFloat maxVal = range.max;
    CGFloat minVal = range.min;
    for (int i = 0; i < [self.graphData count]; i++) {
        range = [[self.graphData objectAtIndex:i] xRange];
        maxVal = MAX(maxVal, range.max);
        minVal = MIN(minVal, range.min);
    }
    GraphViewDataRange result = {minVal, maxVal, maxVal - minVal};
    return result;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (GraphViewDataRange)yRange {
    GraphViewDataRange range = [[self.graphData lastObject] yRange];
    CGFloat maxVal = range.max;
    CGFloat minVal = range.min;
    for (int i = 0; i < [self.graphData count]; i++) {
        range = [[self.graphData objectAtIndex:i] yRange];
        maxVal = MAX(maxVal, range.max);
        minVal = MIN(minVal, range.min);
    }
    GraphViewDataRange result = {minVal, maxVal, maxVal - minVal};
    return result;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)xDataAtIndex:(NSUInteger)i forDataSet:(NSUInteger)j scaledByViewWidth:(CGFloat)width andRange:(GraphViewDataRange)range {
    CGFloat val = 0.0f;
    if (range.interval > 0) {
        val = width * ([[self.graphData objectAtIndex:j] xDataAtIndex:i] - range.min) / range.interval;
    }
    return val;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)yDataAtIndex:(NSUInteger)i forDataSet:(NSUInteger)j scaledByViewHeight:(CGFloat)height andRange:(GraphViewDataRange)range {
    CGFloat val = 0.0f;
    if (range.interval > 0) {
        val = height * ([[self.graphData objectAtIndex:j] yDataAtIndex:i] - range.min) / range.interval;
    }
    return val;
}
//-----------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)scaleValue:(CGFloat)val by:(CGFloat)scaleFactor andRange:(GraphViewDataRange)range {
    CGFloat sacledVal = 0.0f;
    if (range.interval > 0) {
        sacledVal = scaleFactor * (val - range.min) / range.interval;
    }
    return sacledVal;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGRect)rectAtIndex:(NSUInteger)i scaledByView:(CGRect)viewRect xRange:(GraphViewDataRange)plotXRange andYRange:(GraphViewDataRange)plotYRange {
    GraphViewRectangle* rect = [[self rectangles] objectAtIndex:i];
    CGFloat xMinPos = [self scaleValue:rect.xRange.min by:viewRect.size.width andRange:plotXRange];
    CGFloat xMaxPos = [self scaleValue:rect.xRange.max by:viewRect.size.width andRange:plotXRange];
    CGFloat yMinPos = viewRect.size.height - [self scaleValue:rect.yRange.min by:viewRect.size.height andRange:plotYRange];
    CGFloat yMaxPos = viewRect.size.height - [self scaleValue:rect.yRange.max by:viewRect.size.height andRange:plotYRange];
    return CGRectMake(xMinPos, yMinPos, xMaxPos - xMinPos, yMaxPos - yMinPos);
}

//===================================================================================================================================
#pragma mark UIView

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.graphData = [[NSMutableArray alloc] initWithCapacity:10];
        self.rectangles = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    GraphViewDataRange xRange = [self xRange];
    GraphViewDataRange yRange = [self yRange];
    for (int j = 0; j < [self.rectangles count]; j++) {
        GraphViewRectangle* graphRect = [self.rectangles objectAtIndex:j];
        CGRect scaledGraphRect = [self rectAtIndex:j scaledByView:rect xRange:xRange andYRange:yRange];
        UIColor* rectColor = graphRect.rectColor;
        CGContextSetFillColorWithColor(context, rectColor.CGColor);
        CGContextAddRect(context, scaledGraphRect);
        CGContextFillPath(context);
    }
    for (int j = 0; j < [self.graphData count]; j++) { 
        id <GraphViewData> data = [self.graphData objectAtIndex:j];
        CGFloat lineWidth = [data lineWidth];
        CGContextSetLineWidth(context, lineWidth);
        UIColor* lineColor = [data lineColor];
        CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
        for(int i = 0; i < [data length]; i++) {
            CGFloat xData = [self xDataAtIndex:i forDataSet:j scaledByViewWidth:rect.size.width andRange:xRange];
            CGFloat yData = rect.size.height - [self yDataAtIndex:i forDataSet:j scaledByViewHeight:rect.size.height andRange:yRange];
            if (i > 0) {
                CGContextAddLineToPoint(context, xData, yData);
            } else {
                CGContextMoveToPoint(context, xData, yData);
            }
        }
        CGContextStrokePath(context);
    }
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
