//
//  SegmentedCycleList.h
//  webgnosus
//
//  Created by Troy Stribling on 9/27/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface SegmentedCycleList : UISegmentedControl {
    NSMutableArray* items;
    NSInteger selectedItemIndex;
    UIFont* font;
    UIColor* fontColor;
    id delegate;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) NSMutableArray* items;
@property (nonatomic, assign) NSInteger selectedItemIndex;
@property (nonatomic, retain) UIFont* font;
@property (nonatomic, retain) UIColor* fontColor;
@property (nonatomic, retain) id delegate;

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)init:(NSMutableArray*)list withValueAtIndex:(NSInteger)index rect:(CGRect)rect andColor:(UIColor*)initFontColor;
- (id)init:(NSMutableArray*)list withValueAtIndex:(NSInteger)index andRect:(CGRect)rect;
- (NSString*)selectedItem;
- (void)removeItem:(NSString*)item;
- (void)addItem:(NSString*)item;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface NSObject (SegmentedCycleList)

- (void)selectedItemChanged:(SegmentedCycleList*)list;

@end
