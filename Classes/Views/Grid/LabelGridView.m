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
+ (NSMutableArray*)buildViews:(NSMutableArray*)data {
    UIFont* labelFont = [UIFont fontWithName:[NSString stringWithUTF8String:kLABEL_GRID_FONT] size:kLABEL_GRID_FONT_SIZE];
    return [LabelGridView buildViews:data labelOffSet:kLABEL_OFFSET labelHeight:kLABEL_GRID_HEIGHT andFont:labelFont];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)buildViews:(NSMutableArray*)data labelOffSet:(CGFloat)labelOffSet labelHeight:(CGFloat)labelHeight andFont:(UIFont*)labelFont {
    NSMutableArray* labelViewArray = [NSMutableArray arrayWithCapacity:[data count]];
    for (int i = 0; i < [data count]; i++) {
        NSMutableArray* dataRow = [data objectAtIndex:i];
        NSMutableArray* labelViewRow = [NSMutableArray arrayWithCapacity:[dataRow count]];
        for (int j = 0; j < [dataRow count]; j++) {
            CGSize constraintSize = {kDISPLAY_WIDTH, labelHeight};
            NSString* labelText = [dataRow objectAtIndex:j];
            CGSize labelSize = [labelText sizeWithFont:labelFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeTailTruncation];
            UILabel* labelView = [[UILabel alloc] initWithFrame:CGRectMake(labelOffSet, labelOffSet, labelSize.width + labelOffSet, labelHeight + labelOffSet)];
            labelView.lineBreakMode = UILineBreakModeTailTruncation;
            labelView.text = labelText;
            labelView.font = labelFont;
            [labelViewRow addObject:labelView];
            [labelView release];
        }
        [labelViewArray addObject:labelViewRow];
    }
    return labelViewArray;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithLabelViews:(NSMutableArray*)labelViews {
    if (self = [self initWithLabelViews:labelViews borderWidth:kGRID_BORDER_WIDTH  maxWidth:kDISPLAY_WIDTH]) {
    }
    return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithLabelViews:(NSMutableArray*)labelViews borderWidth:(CGFloat)initBorderWidth maxWidth:(CGFloat)initMaxWidth {
    if (self = [super initWithViews:labelViews borderWidth:initBorderWidth  maxWidth:(CGFloat)initMaxWidth]) {
    }
    return self;
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
