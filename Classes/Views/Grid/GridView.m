//
//  GridView.m
//  webgnosus
//
//  Created by Troy Stribling on 4/18/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "GridView.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface GridView (PrivateAPI)

+ (NSMutableArray*)trimViewWidth:(NSMutableArray*)viewWidthArray toGridMaxWidth:(CGFloat)gridMaxWidth;
+ (NSInteger)cellCountForRow:(NSMutableArray*)viewArray;
+ (NSMutableArray*)maxViewHeightByRow:(NSMutableArray*)viewArray usingNumberOfCells:(NSInteger)nCells;
+ (NSMutableArray*)maxViewWidthtByColumn:(NSMutableArray*)viewArray usingNumberOfCells:(NSInteger)nCells;

+ (CGRect)makeTableRectWithViewWidths:(NSMutableArray*)viewWidthArray viewHeights:(NSMutableArray*)viewHeightArray borderWidth:(CGFloat)borderWidth;
+ (CGRect)makeRowRectWithViewWidths:(NSMutableArray*)viewWidthArray viewHeight:(CGFloat)viewHeight andBorderWidth:(CGFloat)borderWidth;
+ (CGRect)makeCellRectWithViewWidth:(CGFloat)viewWidth rowHeight:(CGFloat)viewHeight andBorderWidth:(CGFloat)borderWidth;
+ (CGRect)makeBorderRectWithViewWidth:(CGFloat)viewWidth rowHeight:(CGFloat)viewHeight andBorderWidth:(CGFloat)borderWidth;

+ (void)addCellViews:(NSMutableArray*)viewArray toRow:(UIView*)row withBorderWidth:(CGFloat)borderWidth andViewWidths:(NSMutableArray*)viewWidthArray;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface GridView (TrimAPI)

+ (CGFloat)sumArray:(NSMutableArray*)array;
+ (CGFloat)maxArrayValue:(NSMutableArray*)array;
+ (NSMutableArray*)selectArrayElements:(NSMutableArray*)array lessThanValue:(CGFloat)value;
+ (NSMutableDictionary*)selectArrayElements:(NSMutableArray*)array equalToValue:(CGFloat)value;
+ (void)replaceArrayElements:(NSMutableArray*)array atIndexes:(NSArray*)indexArray withValue:(CGFloat)replaceValue;
+ (NSMutableArray*)adjustViewRects:(NSMutableArray*)viewArray toWidths:(NSMutableArray*)viewWidthArray usingNumberOfCells:(NSInteger)nCells;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation GridView

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize gridBorderWidth;
@synthesize gridMaxWidth;

//===================================================================================================================================
#pragma mark GridView

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithViews:(NSMutableArray*)viewArray borderWidth:(CGFloat)initBorderWidth maxWidth:(CGFloat)initMaxWidth {
    NSInteger nCells = [GridView cellCountForRow:viewArray];
    NSMutableArray* viewWidthArray = [GridView maxViewWidthtByColumn:viewArray usingNumberOfCells:nCells];
    viewWidthArray = [GridView trimViewWidth:viewWidthArray toGridMaxWidth:initMaxWidth];
    viewArray = [GridView adjustViewRects:viewArray toWidths:viewWidthArray usingNumberOfCells:nCells];
    NSMutableArray* viewHeightArray = [GridView maxViewHeightByRow:viewArray usingNumberOfCells:nCells];
    CGRect tableRect = [GridView makeTableRectWithViewWidths:viewWidthArray viewHeights:viewHeightArray borderWidth:initBorderWidth];
    if (self = [super initWithFrame:tableRect]) {
        self.gridBorderWidth = initBorderWidth;
        self.gridMaxWidth = initMaxWidth;
        CGFloat rowOriginY = 0.0f;
        for(int i = 0; i < [viewArray count]; i++) {
            CGFloat viewHeight = [[viewHeightArray objectAtIndex:i] floatValue];
            CGRect rowRect = [GridView makeRowRectWithViewWidths:viewWidthArray viewHeight:viewHeight andBorderWidth:initBorderWidth];
            UIView* row = [[UIView alloc] initWithFrame:CGRectMake(rowRect.origin.x, rowOriginY, rowRect.size.width, rowRect.size.height)];
            [GridView addCellViews:[viewArray objectAtIndex:i] toRow:row withBorderWidth:initBorderWidth andViewWidths:viewWidthArray];
            [self addSubview:row];
            [row release];
            rowOriginY += rowRect.size.height - initBorderWidth;
        }
    }
    return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setBorderColor:(UIColor*)color {
    NSArray* rowViews = [self subviews];
    for(int i = 0; i < [rowViews count]; i++) {
        NSArray* cellViews = [[rowViews objectAtIndex:i] subviews];
        for(int j = 0; j < [cellViews count]; j++) {
            UIView* cellView = [cellViews objectAtIndex:j];
            cellView.backgroundColor = color;
        }
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setCellColor:(UIColor*)color {
    NSArray* rowViews = [self subviews];
    for(int i = 0; i < [rowViews count]; i++) {
        NSArray* cellViews = [[rowViews objectAtIndex:i] subviews];
        for(int j = 0; j < [cellViews count]; j++) {
            UIView* cellView = [cellViews objectAtIndex:j];
            UIView* borderView = [[cellView subviews] lastObject];
            UIView* view = [[borderView subviews] lastObject];
            borderView.backgroundColor = color;
            view.backgroundColor = color;
        }
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setCellColor:(UIColor*)color forRow:(NSInteger)row {
    NSArray* rowViews = [self subviews];
    NSArray* cellViews = [[rowViews objectAtIndex:row] subviews];
    for(int j = 0; j < [cellViews count]; j++) {
        UIView* cellView = [cellViews objectAtIndex:j];
        UIView* borderView = [[cellView subviews] lastObject];
        UIView* view = [[borderView subviews] lastObject];
        borderView.backgroundColor = color;
        view.backgroundColor = color;
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setCellColor:(UIColor*)color forColumn:(NSInteger)column {
    NSArray* rowViews = [self subviews];
    for(int j = 0; j < [rowViews count]; j++) {
        NSArray* cellViews = [[rowViews objectAtIndex:j] subviews];
        UIView* cellView = [cellViews objectAtIndex:column];
        UIView* borderView = [[cellView subviews] lastObject];
        UIView* view = [[borderView subviews] lastObject];
        borderView.backgroundColor = color;
        view.backgroundColor = color;
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (UIView*)viewForRow:(NSInteger)row andColumn:(NSInteger)column {
    NSArray* rowViews = [self subviews];
    NSArray* cellViews = [[rowViews objectAtIndex:row] subviews];
    UIView* cellView = [cellViews objectAtIndex:column];
    UIView* borderView = [[cellView subviews] lastObject];
    return [[borderView subviews] lastObject];
}

//===================================================================================================================================
#pragma mark GridView PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)trimViewWidth:(NSMutableArray*)viewWidthArray toGridMaxWidth:(CGFloat)gridMaxWidth {
    CGFloat deltaWidth = [GridView sumArray:viewWidthArray] - gridMaxWidth;
    if (deltaWidth > 0.0f) {
        CGFloat maxWidth = [GridView maxArrayValue:viewWidthArray];
        NSMutableDictionary* maxWidthDictionary = [GridView selectArrayElements:viewWidthArray equalToValue:maxWidth];
        NSMutableArray* lesserWidthArray = [GridView selectArrayElements:viewWidthArray lessThanValue:maxWidth];
        CGFloat maxWidthCount = [maxWidthDictionary count];
        CGFloat secondLargestWidth = [GridView maxArrayValue:lesserWidthArray];
        CGFloat deltaByElement = maxWidth - secondLargestWidth;
        CGFloat trimmedMaxWidth = maxWidth - deltaWidth / maxWidthCount;
        if (maxWidthCount * deltaByElement < deltaWidth) {
            trimmedMaxWidth = maxWidth - deltaByElement / maxWidthCount;
        } 
        [GridView replaceArrayElements:viewWidthArray atIndexes:[maxWidthDictionary allKeys] withValue:trimmedMaxWidth];
        if (maxWidthCount * deltaByElement < deltaWidth) {
            [self trimViewWidth:viewWidthArray toGridMaxWidth:gridMaxWidth];
        }
    }
    return viewWidthArray;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)cellCountForRow:(NSMutableArray*)viewArray {
    NSInteger nCells = 0;
    id lastObject = [viewArray lastObject];
    if (lastObject) {
        nCells = [lastObject count];
        for(int i = 0; i < [viewArray count]; i++) {
            nCells = MIN(nCells, [[viewArray objectAtIndex:i] count]);
        }
    }
    return nCells;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)maxViewHeightByRow:(NSMutableArray*)viewArray usingNumberOfCells:(NSInteger)nCells {
    NSMutableArray* viewHeightArray = [NSMutableArray arrayWithCapacity:[viewArray count]];
    for(int i = 0; i < [viewArray count]; i++) {
        CGFloat viewHeight = 0.0f;
        NSMutableArray* rowViews = [viewArray objectAtIndex:i];
        for(int j = 0; j < nCells; j++) {   
            CGRect viewRect = [[rowViews objectAtIndex:j] frame];
            viewHeight = MAX(viewRect.size.height + viewRect.origin.y, viewHeight);
        }
        [viewHeightArray addObject:[NSNumber numberWithFloat:viewHeight]];
    }
    return viewHeightArray;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)maxViewWidthtByColumn:(NSMutableArray*)viewArray usingNumberOfCells:(NSInteger)nCells {
    NSMutableArray* viewWidthArray = [NSMutableArray arrayWithCapacity:nCells];
    for(int j = 0; j < nCells; j++) {
        CGFloat viewWidth = 0.0f;
        for(int i = 0; i < [viewArray count]; i++) {   
            CGRect viewRect = [[[viewArray objectAtIndex:i] objectAtIndex:j] frame];
            viewWidth = MAX(viewRect.size.width + viewRect.origin.x, viewWidth);
        }
        [viewWidthArray addObject:[NSNumber numberWithFloat:viewWidth]];
    }
    return viewWidthArray;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (CGRect)makeTableRectWithViewWidths:(NSMutableArray*)viewWidthArray viewHeights:(NSMutableArray*)viewHeightArray borderWidth:(CGFloat)borderWidth {
    CGFloat tableHeight = borderWidth;
    CGFloat tableWidth = borderWidth;
    for(int i = 0; i < [viewHeightArray count]; i++) {
        tableHeight += [[viewHeightArray objectAtIndex:i] floatValue] + borderWidth;
    }
    for(int i = 0; i < [viewWidthArray count]; i++) {   
        tableWidth += [[viewWidthArray objectAtIndex:i] floatValue] + borderWidth;
    }
    return CGRectMake(0.0f, 0.0f, tableWidth, tableHeight);
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (CGRect)makeRowRectWithViewWidths:(NSMutableArray*)viewWidthArray viewHeight:(CGFloat)viewHeight andBorderWidth:(CGFloat)borderWidth {
    CGFloat rowWidth = borderWidth;
    for(int i = 0; i < [viewWidthArray count]; i++) {   
        rowWidth += [[viewWidthArray objectAtIndex:i] floatValue] + borderWidth;
    }
    return CGRectMake(0.0f, 0.0f, rowWidth, viewHeight + 2 * borderWidth);
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (CGRect)makeCellRectWithViewWidth:(CGFloat)viewWidth rowHeight:(CGFloat)rowHeight andBorderWidth:(CGFloat)borderWidth {
    return CGRectMake(0.0f, 0.0f, viewWidth + 2 * borderWidth, rowHeight);
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (CGRect)makeBorderRectWithViewWidth:(CGFloat)viewWidth rowHeight:(CGFloat)rowHeight andBorderWidth:(CGFloat)borderWidth {
    return CGRectMake(borderWidth, borderWidth, viewWidth, rowHeight - 2 * borderWidth);
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)addCellViews:(NSMutableArray*)viewArray toRow:(UIView*)rowView withBorderWidth:(CGFloat)borderWidth andViewWidths:(NSMutableArray*)viewWidthArray {
    CGFloat cellOriginX = 0.0f;
    CGRect rowRect = [rowView frame];
    for(int i = 0; i < [viewArray count]; i++) {  
        UIView* view = [viewArray objectAtIndex:i];
        CGFloat viewWidth = [[viewWidthArray objectAtIndex:i] floatValue];
        CGRect borderRect = [self makeBorderRectWithViewWidth:viewWidth rowHeight:rowRect.size.height andBorderWidth:borderWidth];
        CGRect cellRect = [self makeCellRectWithViewWidth:viewWidth rowHeight:rowRect.size.height andBorderWidth:borderWidth];
        UIView* borderView = [[UIView alloc] initWithFrame:borderRect];
        UIView* cellView = [[UIView alloc] initWithFrame:CGRectMake(cellOriginX, cellRect.origin.y, cellRect.size.width, cellRect.size.height)];
        [borderView addSubview:view];
        [cellView addSubview:borderView];
        [rowView addSubview:cellView];
        cellOriginX += (cellRect.size.width - borderWidth);
    }
}

//===================================================================================================================================
#pragma mark GridView TrimAPI

//-----------------------------------------------------------------------------------------------------------------------------------
+ (CGFloat)sumArray:(NSMutableArray*)array {
    CGFloat total = 0.0;
    for (int i = 0; i < [array count]; i++) {
        total += [[array objectAtIndex:i] floatValue];
    }
    return total;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (CGFloat)maxArrayValue:(NSMutableArray*)array {
    CGFloat maxValue =[[array lastObject] floatValue];
    for (int i = 0; i < [array count]; i++) {
        maxValue = MAX([[array objectAtIndex:i] floatValue], maxValue);
    }
    return maxValue;
}
                
//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)selectArrayElements:(NSMutableArray*)array lessThanValue:(CGFloat)value {
    NSMutableArray* selectedElements = [NSMutableArray arrayWithCapacity:[array count]];
    for (int i = 0; i < [array count]; i++) {
        CGFloat testValue = [[array objectAtIndex:i] floatValue];
        if (value > testValue) {
            [selectedElements addObject:[NSNumber numberWithFloat:testValue]];
        }
    }
    return selectedElements;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableDictionary*)selectArrayElements:(NSMutableArray*)array equalToValue:(CGFloat)value {
    NSMutableDictionary* selectedElements = [NSMutableDictionary dictionaryWithCapacity:[array count]];
    for (int i = 0; i < [array count]; i++) {
        if (value == [[array objectAtIndex:i] floatValue]) {
            [selectedElements setObject:[NSNumber numberWithFloat:value] forKey:[NSNumber numberWithInt:i]];
        }
    }
    return selectedElements;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)replaceArrayElements:(NSMutableArray*)array atIndexes:(NSArray*)indexArray withValue:(CGFloat)replaceValue {
    for (int i = 0; i < [indexArray count]; i++) {
        [array replaceObjectAtIndex:[[indexArray objectAtIndex:i] intValue] withObject:[NSNumber numberWithFloat:replaceValue]];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)adjustViewRects:(NSMutableArray*)viewArray toWidths:(NSMutableArray*)viewWidthArray usingNumberOfCells:(NSInteger)nCells {
    for(int i = 0; i < [viewArray count]; i++) {
        NSMutableArray* rows = [viewArray objectAtIndex:i];
        for(int j = 0; j < nCells; j++) {
            UIView* view = [rows objectAtIndex:j];
            CGRect viewRect = [view frame];
            CGFloat adjustedViewWidth = [[viewWidthArray objectAtIndex:j] floatValue];
            view.frame = CGRectMake(viewRect.origin.x, viewRect.origin.y, adjustedViewWidth - viewRect.origin.x, viewRect.size.height);
        }
    }
    return viewArray;
}

//===================================================================================================================================
#pragma mark UIView

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
