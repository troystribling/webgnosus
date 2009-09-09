//
//  RoundedCornersView.m
//  webgnosus
//
//  Created by Troy Stribling on 8/29/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "RoundedCornersView.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface RoundedCornersView (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation RoundedCornersView

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize color;

//===================================================================================================================================
#pragma mark RoundedCornersView

//===================================================================================================================================
#pragma mark RoundedCornersView PrivateAPI

//===================================================================================================================================
#pragma mark UIView

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.color = [UIColor colorWithWhite:0.0f alpha:1.0f];
    }
    return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)drawRect:(CGRect)rect {
    float radius = 20.0f;    
    CGContextRef context = UIGraphicsGetCurrentContext();     
    CGContextBeginPath(context);
    CGContextSetFillColorWithColor(context, self.color.CGColor);
    CGContextMoveToPoint(context, CGRectGetMinX(rect) + radius, CGRectGetMinY(rect));
    CGContextAddArc(context, CGRectGetMaxX(rect) - radius, CGRectGetMinY(rect) + radius, radius, 3 * M_PI / 2, 0, 0);
    CGContextAddArc(context, CGRectGetMaxX(rect) - radius, CGRectGetMaxY(rect) - radius, radius, 0, M_PI / 2, 0);
    CGContextAddArc(context, CGRectGetMinX(rect) + radius, CGRectGetMaxY(rect) - radius, radius, M_PI / 2, M_PI, 0);
    CGContextAddArc(context, CGRectGetMinX(rect) + radius, CGRectGetMinY(rect) + radius, radius, M_PI, 3 * M_PI / 2, 0);    
    CGContextClosePath(context);
    CGContextFillPath(context);
    CGContextClipToRect(context, CGRectMake(0.0, 0.0, rect.size.width, rect.size.height));      
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
