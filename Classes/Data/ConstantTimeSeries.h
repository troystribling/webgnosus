//
//  ConstantTimeSeries.h
//  webgnosus_client
//
//  Created by Troy Stribling on 5/14/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "GraphViewData.h"

//-----------------------------------------------------------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ConstantTimeSeries : NSObject <GraphViewData> {
    CGFloat contstantValue;
    GraphViewDataRange timeRange;
    NSArray* timePoints;
    CGFloat lineWidth;
    UIColor* lineColor;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, assign) CGFloat contstantValue;
@property (nonatomic, assign) GraphViewDataRange timeRange;
@property (nonatomic, retain) NSArray* timePoints;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, retain) UIColor* lineColor;

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithValue:(CGFloat)value timeRange:(GraphViewDataRange)range width:(CGFloat)width andColor:(UIColor*)color;
- (id)initWithValue:(CGFloat)value timeRange:(GraphViewDataRange)range andColor:(UIColor*)color;
- (id)initWithValue:(CGFloat)value timeRange:(GraphViewDataRange)range;

@end