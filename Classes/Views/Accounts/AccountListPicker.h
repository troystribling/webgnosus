//
//  AccountListPicker.h
//  webgnosus
//
//  Created by Troy Stribling on 8/29/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface AccountListPicker : NSObject {
    UISegmentedControl* segmentedControl;
    NSMutableArray* accountJIDs;
    NSInteger currentAccountIndex;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UISegmentedControl* segmentedControl;
@property (nonatomic, retain) NSMutableArray* accountJIDs;
@property (nonatomic, assign) NSInteger currentAccountIndex;

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)init;

@end
