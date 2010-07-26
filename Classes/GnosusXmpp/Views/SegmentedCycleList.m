//
//  SegmentedCycleList.m
//  webgnosus
//
//  Created by Troy Stribling on 9/27/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "SegmentedCycleList.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface SegmentedCycleList (PrivateAPI)

- (void)segmentControlSelectionChanged:(id)sender;
- (UIImage*)renderTextAsImage:(CGRect)rect;
- (void)shiftSelectedItem:(NSInteger)shift;
- (void)delegateSelectedItemChanged;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation SegmentedCycleList

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize items;
@synthesize selectedItemIndex;
@synthesize font;
@synthesize fontColor;
@synthesize delegate;

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)init:(NSMutableArray*)initList withValueAtIndex:(NSInteger)initIndex andRect:(CGRect)initRect {
    if (self = [self init:initList withValueAtIndex:initIndex rect:initRect andColor:[UIColor blackColor]]) {
    }
    return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)init:(NSMutableArray*)list withValueAtIndex:(NSInteger)index rect:(CGRect)rect andColor:(UIColor*)initFontColor {
    self.items = list;
    self.selectedItemIndex = index;
    self.font = [UIFont boldSystemFontOfSize:16];
    self.fontColor = initFontColor;
    if (self = [super initWithItems:[NSMutableArray arrayWithObjects:[self renderTextAsImage:rect], nil]]) {
        [self addTarget:self action:@selector(segmentControlSelectionChanged:) forControlEvents:UIControlEventValueChanged];
        self.frame = rect;
        self.momentary = YES;
        self.segmentedControlStyle = UISegmentedControlStyleBar;
        self.tintColor = [UIColor colorWithWhite:0.85f alpha:1.0f];
    }
    return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)selectedItem {
    return (NSString*)[self.items objectAtIndex:self.selectedItemIndex];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)removeItem:(NSString*)item {
    [items removeObject:item];
    if ([items count] > 0) {
        [self shiftSelectedItem:0];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addItem:(NSString*)item {
    [items addObject:item];
}

//===================================================================================================================================
#pragma mark SegmentedCycleList PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)segmentControlSelectionChanged:(id)sender {
    [self shiftSelectedItem:1];
    [self delegateSelectedItemChanged];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)shiftSelectedItem:(NSInteger)shift {
    NSInteger listLength = [items count];
    NSInteger newIndex = self.selectedItemIndex + shift;
    if (newIndex < 0) {
        newIndex = listLength - 1;
    }
    self.selectedItemIndex = newIndex % listLength;
    [self setImage:[self renderTextAsImage:self.frame] forSegmentAtIndex:0];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (UIImage*)renderTextAsImage:(CGRect)rect {
    CGFloat width = rect.size.width-4.0f;
    CGFloat height = rect.size.height;
    CGSize textSize = [[self selectedItem] sizeWithFont:self.font constrainedToSize:CGSizeMake(width, height) lineBreakMode:UILineBreakModeTailTruncation];
    CGFloat yoffset = (height-textSize.height)/2.0f;
	UIGraphicsBeginImageContext(CGSizeMake(width, height));
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context, [self.fontColor CGColor]);
	CGContextSetStrokeColorWithColor(context, [self.fontColor CGColor]);
	[[self selectedItem]  drawInRect:CGRectMake(0.0f, yoffset, width, height) withFont:self.font lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
	UIImage* textImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    return textImage;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)delegateSelectedItemChanged {
    if ([self.delegate respondsToSelector:@selector(selectedItemChanged:)]) {
        [self.delegate selectedItemChanged:self];
    }
} 


//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
