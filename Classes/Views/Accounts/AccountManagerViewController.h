//
//  AccountManagerViewController.h
//  webgnosus
//
//  Created by Troy Stribling on 1/1/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

//-----------------------------------------------------------------------------------------------------------------------------------
@class RoundedCornersView;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface AccountManagerViewController : UIViewController {
    UIView* contentView;
    UIView* contentViewBorder;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UIView* contentView;
@property (nonatomic, retain) UIView* contentViewBorder;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addAsSubview:(UIView*)parent;

@end
