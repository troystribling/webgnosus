//
//  GridView.h
//  webgnosus
//
//  Created by Troy Stribling on 4/18/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface GridView : UIView {
    CGFloat gridBorderWidth;
    CGFloat xOffset;
    CGFloat yOffset;
    CGFloat gridMaxWidth;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, assign) CGFloat gridBorderWidth;
@property (nonatomic, assign) CGFloat xOffset;
@property (nonatomic, assign) CGFloat yOffset;
@property (nonatomic, assign) CGFloat gridMaxWidth;

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithViews:(NSMutableArray*)views borderWidth:(CGFloat)initBorderWidth maxWidth:(CGFloat)initMaxWidth xOffset:(CGFloat)initXOffset andYOffset:(CGFloat)initYOffset;
- (void)setBorderColor:(UIColor*)color;
- (void)setCellColor:(UIColor*)color;
- (void)setCellColor:(UIColor*)color forRow:(NSInteger)row;
- (void)setCellColor:(UIColor*)color forColumn:(NSInteger)column;
- (UIView*)viewForRow:(NSInteger)row andColumn:(NSInteger)column;

@end
