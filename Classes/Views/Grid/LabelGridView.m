//
//  LabelGridView.m
//  webgnosus
//
//  Created by Troy Stribling on 4/18/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "LabelGridView.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface LabelGridView (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation LabelGridView

//-----------------------------------------------------------------------------------------------------------------------------------

//===================================================================================================================================
#pragma mark LabelGridView

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithLabelViews:(NSMutableArray*)lableViews borderWidth:(CGFloat)initBorderWidth maxWidth:(CGFloat)initMaxWidth gridXOffset:(CGFloat)initXOffset andGridYOffset:(CGFloat)initYOffset {
    if (self = [super initWithViews:lableViews borderWidth:initBorderWidth  maxWidth:(CGFloat)initMaxWidth xOffset:initXOffset andYOffset:initYOffset]) {
    }
    return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setHeaderColor:(UIColor*)color {
    [self setCellColor:color forRow:0];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setTextAlignment:(UITextAlignment)textAlignment forColumn:(NSUInteger)column {
    NSArray* rowViews = [self subviews];
    for(int i = 0; i < [rowViews count]; i++) {
        NSArray* cellViews = [[rowViews objectAtIndex:i] subviews];
        UIView* cellView = [cellViews objectAtIndex:column];
        UIView* borderView = [[cellView subviews] lastObject];
        UILabel* view = [[borderView subviews] lastObject];
        view.textAlignment = textAlignment;
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setLineBreakMode:(UILineBreakMode)lineBreakMode forColumn:(NSUInteger)column {
    NSArray* rowViews = [self subviews];
    for(int i = 0; i < [rowViews count]; i++) {
        NSArray* cellViews = [[rowViews objectAtIndex:i] subviews];
        UIView* cellView = [cellViews objectAtIndex:column];
        UIView* borderView = [[cellView subviews] lastObject];
        UILabel* view = [[borderView subviews] lastObject];
        view.lineBreakMode = lineBreakMode;
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)buildViews:(NSMutableArray*)data labelOffSet:(CGFloat)labelOffSet labelHeight:(CGFloat)labelHeight andFont:(UIFont*)labelFont {
    NSMutableArray* labelViewArray = [NSMutableArray arrayWithCapacity:[data count]];
    for (int i = 0; i < [data count]; i++) {
        NSMutableArray* dataRow = [data objectAtIndex:i];
        NSMutableArray* labelViewRow = [NSMutableArray arrayWithCapacity:[dataRow count]];
        for (int j = 0; j < [dataRow count]; j++) {
            CGSize constraintSize = {2000.0f, labelHeight};
            CGSize labelSize = [[dataRow objectAtIndex:j] sizeWithFont:labelFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
            UILabel* labelView = [[UILabel alloc] initWithFrame:CGRectMake(labelOffSet, labelOffSet, labelSize.width + labelOffSet, labelHeight + labelOffSet)];
            labelView.text = [dataRow objectAtIndex:j];
            labelView.font = labelFont;
            [labelViewRow addObject:labelView];
        }
        [labelViewArray addObject:labelViewRow];
    }
    return labelViewArray;
}

//===================================================================================================================================
#pragma mark LabelTableView PrivateAPI

//===================================================================================================================================
#pragma mark UIView

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
