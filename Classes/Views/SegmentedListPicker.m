//
//  SegmentedListPicker.m
//  webgnosus
//
//  Created by Troy Stribling on 8/29/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "SegmentedListPicker.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface SegmentedListPicker (PrivateAPI)

- (void)segmentControlSelectionChanged:(id)sender;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation SegmentedListPicker

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize segmentedControl;
@synthesize listValues;

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithList:(NSMutableArray*)list atValue:(NSString*)value {
    if (self = [super init]) {
        self.segmentedControl= [[UISegmentedControl alloc] initWithItems:[[NSArray alloc] initWithObjects:@"Left", value, @"Right", nil]];
        [self.segmentedControl addTarget:self action:@selector(segmentControlSelectionChanged:) forControlEvents:UIControlEventValueChanged];
        self.listValues = list;
    }
    return self;
}

//===================================================================================================================================
#pragma mark SegmentedListPicker

//===================================================================================================================================
#pragma mark SegmentedListPicker PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void) segmentControlSelectionChanged:(id)sender {
    NSInteger selectedSegment = [(UISegmentedControl*)sender selectedSegmentIndex];
}

//===================================================================================================================================
#pragma mark NSObject
@end
