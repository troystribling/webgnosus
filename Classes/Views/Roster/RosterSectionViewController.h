//
//  RosterSectionViewController.h
//  webgnosus_client
//
//  Created by Troy Stribling on 2/10/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface RosterSectionViewController : UIViewController {
    IBOutlet UILabel* nicknameLable;
    NSString* nickname;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UILabel* nicknameLable;
@property (nonatomic, retain) NSString* nickname;

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andLable:(NSString*)lable;

@end
