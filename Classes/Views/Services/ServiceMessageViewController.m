//
//  ServiceMessageViewController.m
//  webgnosus
//
//  Created by Troy Stribling on 10/23/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "ServiceMessageViewController.h"
#import "MessageViewFactory.h"
#import "MessageModel.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ServiceMessageViewController (PrivateAPI)

- (void)failureAlert:(NSString*)message;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ServiceMessageViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize nodeLabel;
@synthesize node;
@synthesize message;

//===================================================================================================================================
#pragma mark ServiceMessageViewController

//===================================================================================================================================
#pragma mark ServiceMessageViewController PrivateAPI

//===================================================================================================================================
#pragma mark UIViewController

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    }
    return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	self.title = @"Services";
    [super viewDidLoad];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated {
    self.nodeLabel.text = self.node;
    UIView* msgView = [MessageViewFactory viewForMessage:self.message];
    CGRect msgRect = [msgView frame];
    UIView* container = [[[UIView alloc] initWithFrame:CGRectMake(kXDATA_SERVICE_MESSAGE_X_OFFSET, kXDATA_SERVICE_MESSAGE_Y_OFFSET, msgRect.size.width,  msgRect.size.width)] autorelease];
    [container addSubview:msgView];
    [self.view addSubview:container];
	[super viewWillAppear:animated];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
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

