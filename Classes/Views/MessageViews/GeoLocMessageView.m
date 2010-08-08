//
//  GeoLocMessageView.m
//  webgnosus
//
//  Created by Troy Stribling on 10/24/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "GeoLocMessageView.h"
#import "LabelGridView.h"
#import "MessageModel.h"
#import "XMPPGeoLoc.h"
#import "XMPPxData.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface GeoLocMessageView (PrivateAPI)

+ (NSMutableArray*)buildGridArray:(XMPPGeoLoc*)data;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation GeoLocMessageView

//-----------------------------------------------------------------------------------------------------------------------------------

//===================================================================================================================================
#pragma mark GeoLocMessageView

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UIView*)viewForMessage:(MessageModel*)message {
    XMPPGeoLoc* data = [message parseGeoLocMessage];
    NSMutableArray* gridArray = [self buildGridArray:data];
    NSMutableArray* labelArray = [LabelGridView buildViews:gridArray];
    LabelGridView* labelGridView = [[LabelGridView alloc] initWithLabelViews:labelArray];
    [labelGridView setCellColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]];
    [labelGridView setBorderColor:[UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:1.0f]]; 
    [labelGridView setCellColor:[UIColor colorWithRed:0.8f green:0.8f blue:0.8f alpha:1.0f] forColumn:0];
    return labelGridView;
}

//===================================================================================================================================
#pragma mark GeoLocMessageView PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)buildGridArray:(XMPPGeoLoc*)data {
    NSMutableArray* dataArrays = [data toArrays];
    NSMutableArray* gridArray = [NSMutableArray arrayWithCapacity:[dataArrays count]];
    for(int j = 0; j < [dataArrays count]; j++) {
        NSMutableArray* attrs = [dataArrays objectAtIndex:j];
        NSString* attr = [attrs objectAtIndex:0];
        NSString* val = [attrs lastObject];
        [gridArray addObject:[NSMutableArray arrayWithObjects:attr, val, nil]];
    }
    return gridArray;
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
