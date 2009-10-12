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
    IBOutlet UILabel* nicknameLable;
    NSString* nickname;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UILabel* nicknameLable;
@property (nonatomic, retain) NSString* nickname;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UIView*)viewWithLabel:(NSString*)viewLable;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andLable:(NSString*)lable;

@end
