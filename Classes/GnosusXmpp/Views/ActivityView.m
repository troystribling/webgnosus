//
//  ActivityView.m
//  webgnosus
//
//  Created by Troy Stribling on 2/16/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "ActivityView.h"
#import "RoundedCornersView.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ActivityView (PrivateAPI)

- (RoundedCornersView*)createContentView:(UIView*)view withWidth:(CGFloat)width;
- (UIActivityIndicatorView*)createActivityIndicator:(UIView*)view withWidth:(CGFloat)width;
- (UILabel*)createTitle:(NSString*)title inView:(UIView*)view withWidth:(CGFloat)width;
- (CGFloat)titleWidth:(NSString*)title;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ActivityView

//-----------------------------------------------------------------------------------------------------------------------------------

//===================================================================================================================================
#pragma mark ActivityView

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithTitle:(NSString*)title inView:(UIView*)view {
    if (self = [super initWithFrame:view.frame]) {
        [view addSubview:self];
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];  
        CGFloat width = [self titleWidth:title];
        UIColor* contentColor = [UIColor colorWithWhite:0.0f alpha:1.0f];
        RoundedCornersView* contentView = [self createContentView:self withWidth:width];
        contentView.color = contentColor;
        [self createActivityIndicator:contentView withWidth:width];
        UILabel* titleLabel = [self createTitle:title inView:contentView withWidth:width];
        titleLabel.backgroundColor = contentColor;
        titleLabel.textColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
    }
    return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void) dismiss {
    [self removeFromSuperview];
}

//===================================================================================================================================
#pragma mark ActivityView PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (RoundedCornersView*)createContentView:(UIView*)view withWidth:(CGFloat)width  {
    RoundedCornersView* contentView = [[RoundedCornersView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width+20.0f , 80.0f)];
    CGFloat xcenter = view.frame.origin.x + view.frame.size.width/2.0f;
    CGFloat ycenter = view.frame.origin.y + view.frame.size.height/2.0f;
    [contentView setCenter:CGPointMake(xcenter, ycenter)];
    [self addSubview:contentView];
    return [contentView autorelease];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (UIActivityIndicatorView*)createActivityIndicator:(UIView*)view withWidth:(CGFloat)width {
    UIActivityIndicatorView* activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
    [activityIndicator setCenter:CGPointMake((width+20.0f)/2.0f, 30.0f)];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityIndicator startAnimating];
    [view addSubview:activityIndicator];
    return [activityIndicator autorelease];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (UILabel*)createTitle:(NSString*)title inView:(UIView*)view withWidth:(CGFloat)width {
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 50.0f, width, 20.0f)];
    titleLabel.text = title;
    titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
    [view addSubview:titleLabel];
    return [titleLabel autorelease];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)titleWidth:(NSString*)title {
    CGSize size = 
        [title sizeWithFont:[UIFont boldSystemFontOfSize:16.0f] constrainedToSize:CGSizeMake(self.frame.size.width, 20.0f) lineBreakMode:UILineBreakModeTailTruncation];
    return size.width;
}

//===================================================================================================================================
#pragma mark UIActionSheetDelegate

//===================================================================================================================================
#pragma mark UIView

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}


@end
