//
//  RosterSectionViewController.m
//  webgnosus_client
//
//  Created by Troy Stribling on 2/10/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "RosterSectionViewController.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface RosterSectionViewController (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation RosterSectionViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize nicknameLable;
@synthesize nickname;

//===================================================================================================================================
#pragma mark RosterSectionViewController

//===================================================================================================================================
#pragma mark RosterSectionViewController PrivateAPI

//===================================================================================================================================
#pragma mark UIViewController

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andLable:(NSString*)lable {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.nickname = lable;
    }
    return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    self.nicknameLable.text = self.nickname;
    [super viewDidLoad];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}


@end
