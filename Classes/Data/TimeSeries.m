//
//  TimeSeries.m
//  webgnosus_client
//
//  Created by Troy Stribling on 5/10/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "TimeSeries.h"
#import "MessageModel.h"
#import "XMPPxData.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface TimeSeries (PrivateAPI)

-(void)extractTimeSeries:(MessageModel*)message;
-(void)computeStats;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TimeSeries

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize valueMax;
@synthesize valueMin;
@synthesize timeMin;
@synthesize timeMax;
@synthesize sigma;
@synthesize average;
@synthesize valuePoints;
@synthesize timePoints;
@synthesize lineWidth;
@synthesize lineColor;

//===================================================================================================================================
#pragma mark TimeSeriesStats

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithMessage:(MessageModel*)message width:(CGFloat)width andColor:(UIColor*)color {
    if ([self initWithMessage:message andColor:color]) {
        self.lineWidth = width;
    }
    return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithMessage:(MessageModel*)message andColor:(UIColor*)color {
    if ([self initWithMessage:message]) {
        self.lineColor = color;
        self.lineWidth = 1.0f;
    }
    return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithMessage:(MessageModel*)message {
    if (self = [super init]) {
        self.lineWidth = 1.0f;
        self.lineColor = [UIColor colorWithWhite:0.0f alpha:1.0f];
        [self extractTimeSeries:message];
        [self computeStats];
    }
    return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
-(CGFloat)valueDataAtIndex:(NSUInteger)i {
    return [[self.valuePoints objectAtIndex:i] floatValue];
}

//-----------------------------------------------------------------------------------------------------------------------------------
-(CGFloat)timeDataAtIndex:(NSUInteger)i {
    return [[self.timePoints objectAtIndex:i] floatValue];
}

//===================================================================================================================================
#pragma mark TimeSeriesStats PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
-(void)extractTimeSeries:(MessageModel*)message {
    NSMutableArray* itemsArray = [[MessageModel parseXDataMessage:message] items];
    self.valuePoints = [[NSMutableArray alloc] initWithCapacity:[itemsArray count]];
    self.timePoints = [[NSMutableArray alloc] initWithCapacity:[itemsArray count]];
    for(int i = 0; i < [itemsArray count]; i++) {
        NSMutableDictionary* fieldHash = [itemsArray objectAtIndex:i];
        [self.valuePoints addObject:[[fieldHash objectForKey:@"value"] lastObject]];
        [self.timePoints addObject:[[fieldHash objectForKey:@"time"] lastObject]];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
-(void)computeStats {
    if ([self length] > 0) {
        self.timeMax = [[self.timePoints lastObject] floatValue];
        self.timeMin = [self timeDataAtIndex:0];
        self.valueMax = [self valueDataAtIndex:0];
        self.valueMin = [self valueDataAtIndex:0];
        self.average = 0.0f;
        self.sigma = 0.0f;
        for (int i = 0; i < [self length]; i++) {
            CGFloat currentVal = [self valueDataAtIndex:i];
            self.valueMax = MAX(self.valueMax, currentVal);
            self.valueMin = MIN(self.valueMin, currentVal);
            self.average += currentVal;
            self.sigma += currentVal * currentVal;
        }
        self.average = self.average / [self length];
        self.sigma = sqrt(self.sigma / [self length] - self.average * self.average);
    }
}

//===================================================================================================================================
#pragma mark GraphViewData Protocol

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)xDataAtIndex:(NSUInteger)i {
    return [self timeDataAtIndex:i];
}
                        
//-----------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)yDataAtIndex:(NSUInteger)i {
    return [self valueDataAtIndex:i];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (GraphViewDataRange)xRange {
    GraphViewDataRange range = {self.timeMin, self.timeMax, self.timeMax - self.timeMin};
    return range;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (GraphViewDataRange)yRange {
    GraphViewDataRange range = {self.valueMin, self.valueMax, self.valueMax - self.valueMin};
    return range;
}

//-----------------------------------------------------------------------------------------------------------------------------------
-(NSInteger)length {
    return [self.valuePoints count];
}

//===================================================================================================================================
#pragma mark NSObject Methods

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
