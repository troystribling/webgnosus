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
- (UIImage*)renderTextAsImage:(CGRect)rect;
- (void)shiftSelectedItem:(NSInteger)shift;
- (void)delegateSelectedItemChanged;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation SegmentedListPicker

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize items;
@synthesize selectedItemIndex;
@synthesize font;
@synthesize delegate;

//===================================================================================================================================
#pragma mark SegmentedListPicker

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)init:(NSMutableArray*)list withValueAtIndex:(NSInteger)index andRect:(CGRect)rect {
    self.items = list;
    self.selectedItemIndex = index;
    self.font = [UIFont boldSystemFontOfSize:17];
    if (self = [super initWithItems:[NSArray arrayWithObjects:[UIImage imageNamed:@"left-arrow.png"], [self renderTextAsImage:rect], 
                                     [UIImage imageNamed:@"right-arrow.png"], nil]]) {
        [self addTarget:self action:@selector(segmentControlSelectionChanged:) forControlEvents:UIControlEventValueChanged];
        self.frame = rect;
        self.momentary = YES;
        self.segmentedControlStyle = UISegmentedControlStyleBar;
        self.tintColor = [UIColor colorWithWhite:0.85f alpha:1.0f];
        [self setWidth:30.f forSegmentAtIndex:0];
        [self setWidth:30.f forSegmentAtIndex:2];
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
#pragma mark SegmentedListPicker PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)segmentControlSelectionChanged:(id)sender {
    NSInteger selectedSegment = [(UISegmentedControl*)sender selectedSegmentIndex];
    switch (selectedSegment) {
        case 0:
            [self shiftSelectedItem:-1];
            break;
        case 1:
            [self shiftSelectedItem:1];
            break;
        case 2:
            [self shiftSelectedItem:1];
            break;
    }
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
    [self setImage:[self renderTextAsImage:self.frame] forSegmentAtIndex:1];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (UIImage*)renderTextAsImage:(CGRect)rect {
    CGFloat width = rect.size.width-60.0f-4.0f;
    CGFloat height = rect.size.height;
    CGSize textSize = [[self selectedItem] sizeWithFont:self.font constrainedToSize:CGSizeMake(width, height) lineBreakMode:UILineBreakModeTailTruncation];
    CGFloat yoffset = (height-textSize.height)/2.0f;
	UIGraphicsBeginImageContext(CGSizeMake(width, height));
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
	CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
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
