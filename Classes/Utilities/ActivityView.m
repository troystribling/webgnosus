//
//  ActivityView.m
//  webgnosus_client
//
//  Created by Troy Stribling on 2/16/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "ActivityView.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface UIActionSheet (PrivateAPI)

- (void) setNumberOfRows: (NSInteger) rows;
- (void) setMessage: (NSString *)message;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ActivityView (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ActivityView

//-----------------------------------------------------------------------------------------------------------------------------------

//===================================================================================================================================
#pragma mark ActivityView

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithTitle:(NSString*)title inView:(UIView*)view {
    if (self = [super initWithTitle:title delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil]) {
        UIActivityIndicatorView* activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
        self.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [self setNumberOfRows:1];
        [activityIndicator setCenter:CGPointMake(160.0f, 50.0f)];
        [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activityIndicator startAnimating];
        [self addSubview:activityIndicator];
        [activityIndicator release];
        [self showInView:view];
    }
    return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void) dismiss {
    [self dismissWithClickedButtonIndex:0 animated:YES]; 
}

//===================================================================================================================================
#pragma mark ActivityView PrivateAPI

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
