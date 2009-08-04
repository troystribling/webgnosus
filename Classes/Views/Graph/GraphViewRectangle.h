//
//  GraphViewRectangle.h
//  webgnosus_client
//
//  Created by Troy Stribling on 5/22/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "GraphViewData.h"

//-----------------------------------------------------------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface GraphViewRectangle : NSObject {
    GraphViewDataRange xRange;
    GraphViewDataRange yRange;
    UIColor* rectColor;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, assign) GraphViewDataRange xRange;
@property (nonatomic, assign) GraphViewDataRange yRange;
@property (nonatomic, retain) UIColor* rectColor;

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithXRange:(GraphViewDataRange)initXRange andYRange:(GraphViewDataRange)initYRange;

@end
