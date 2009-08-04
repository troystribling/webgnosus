//
//  TimeSeries.h
//  webgnosus_client
//
//  Created by Troy Stribling on 5/10/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "GraphViewData.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@class MessageModel;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface TimeSeries : NSObject <GraphViewData> {
    CGFloat valueMax;
    CGFloat valueMin;
    CGFloat timeMax;
    CGFloat timeMin;
    CGFloat sigma;
    CGFloat average;
    NSMutableArray* valuePoints;
    NSMutableArray* timePoints;
    CGFloat lineWidth;
    UIColor* lineColor;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, assign) CGFloat valueMax;
@property (nonatomic, assign) CGFloat valueMin;
@property (nonatomic, assign) CGFloat timeMax;
@property (nonatomic, assign) CGFloat timeMin;
@property (nonatomic, assign) CGFloat sigma;
@property (nonatomic, assign) CGFloat average;
@property (nonatomic, retain) NSMutableArray* valuePoints;
@property (nonatomic, retain) NSMutableArray* timePoints;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, retain) UIColor* lineColor;

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithMessage:(MessageModel*)message width:(CGFloat)width andColor:(UIColor*)color;
- (id)initWithMessage:(MessageModel*)message andColor:(UIColor*)color;
- (id)initWithMessage:(MessageModel*)message;
- (CGFloat)valueDataAtIndex:(NSUInteger)i;
- (CGFloat)timeDataAtIndex:(NSUInteger)i; 

@end
