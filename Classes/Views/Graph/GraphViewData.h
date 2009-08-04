//
//  GraphViewData.h
//  webgnosus_client
//
//  Created by Troy Stribling on 5/13/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
typedef struct {
    CGFloat min;
    CGFloat max;
    CGFloat interval;
} GraphViewDataRange;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@protocol GraphViewData

@required

- (UIColor*)lineColor;
- (CGFloat)lineWidth;
- (CGFloat)xDataAtIndex:(NSUInteger)i;
- (CGFloat)yDataAtIndex:(NSUInteger)i;
- (GraphViewDataRange)xRange;
- (GraphViewDataRange)yRange;
- (NSInteger)length;

@end

