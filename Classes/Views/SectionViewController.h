//
//  SectionViewController.h
//  webgnosus
//
//  Created by Troy Stribling on 2/10/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface SectionViewController : UIViewController {
    IBOutlet UILabel* nicknameLabel;
    NSString* nickname;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UILabel* nicknameLabel;
@property (nonatomic, retain) NSString* nickname;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (SectionViewController*)viewControllerWithLabel:(NSString*)label;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andLabel:(NSString*)label;

@end
