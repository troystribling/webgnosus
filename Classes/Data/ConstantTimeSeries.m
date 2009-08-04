//
//  ConstantTimeSeries.m
//  webgnosus_client
//
//  Created by Troy Stribling on 5/14/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "ConstantTimeSeries.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ConstantTimeSeries (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ConstantTimeSeries

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize contstantValue;
@synthesize timeRange;
@synthesize timePoints;
@synthesize lineWidth;
@synthesize lineColor;

//===================================================================================================================================
#pragma mark ConstantValue

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithValue:(CGFloat)value timeRange:(GraphViewDataRange)range width:(CGFloat)width andColor:(UIColor*)color {
    if ([self initWithValue:value timeRange:range andColor:color]) {
        self.lineWidth = width;
    }
    return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithValue:(CGFloat)value timeRange:(GraphViewDataRange)range andColor:(UIColor*)color {
    if ([self initWithValue:value timeRange:range]) {
        self.lineWidth = 1.0f;
        self.lineColor = color;
    }
    return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithValue:(CGFloat)value timeRange:(GraphViewDataRange)range {
    if (self = [super init]) {
        self.timePoints = [[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:range.min], [NSNumber numberWithFloat:range.max], nil];
        self.lineWidth = 1.0f;
        self.lineColor = [UIColor colorWithWhite:0.0f alpha:1.0f];
        self.contstantValue = value;
        self.timeRange = range;
    }
    return self;
}

//===================================================================================================================================
#pragma mark ConstantValue PrivateAPI

//===================================================================================================================================
#pragma mark GraphViewData Protocol

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)xDataAtIndex:(NSUInteger)i {
    return [[self.timePoints objectAtIndex:i] floatValue];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)yDataAtIndex:(NSUInteger)i {
    return self.contstantValue;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (GraphViewDataRange)xRange {
    return self.timeRange;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (GraphViewDataRange)yRange {
    GraphViewDataRange range = {contstantValue, contstantValue, 0.0f};
    return range;
}

//-----------------------------------------------------------------------------------------------------------------------------------
-(NSInteger)length {
    return 2;
}

//===================================================================================================================================
#pragma mark NSObject Methods

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
