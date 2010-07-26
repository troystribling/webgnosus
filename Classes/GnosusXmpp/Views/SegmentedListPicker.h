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
    NSMutableArray* items;
    NSInteger selectedItemIndex;
    UIFont* font;
    id delegate;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) NSMutableArray* items;
@property (nonatomic, assign) NSInteger selectedItemIndex;
@property (nonatomic, retain) UIFont* font;
@property (nonatomic, retain) id delegate;

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)init:(NSArray*)list withValueAtIndex:(NSInteger)index andRect:(CGRect)rect;
- (NSString*)selectedItem;
- (void)removeItem:(NSString*)item;
- (void)addItem:(NSString*)item;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface NSObject (SegmentedListPicker)

- (void)selectedItemChanged:(SegmentedListPicker*)picker;

@end
