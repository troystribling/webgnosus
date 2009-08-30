//
//  SegmentedListPicker.h
//  webgnosus
//
//  Created by Troy Stribling on 8/29/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface SegmentedListPicker : NSObject {
    UISegmentedControl* segmentedControl;
    NSArray* listValues;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UISegmentedControl* segmentedControl;
@property (nonatomic, retain) NSArray* listValues;

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithList:(NSArray*)list atValue:(NSString*)value;

@end
