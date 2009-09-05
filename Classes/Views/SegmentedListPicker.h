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
@interface SegmentedListPicker : UISegmentedControl {
    NSArray* items;
    NSInteger selectedItemIndex;
    UIFont* font;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) NSArray* items;
@property (nonatomic, assign) NSInteger selectedItemIndex;
@property (nonatomic, retain) UIFont* font;

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)init:(NSArray*)list withValueAtIndex:(NSInteger)index andRect:(CGRect)rect;
- (NSString*)selectedItem;

@end
