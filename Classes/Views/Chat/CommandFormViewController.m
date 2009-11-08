//
//  CommandFormViewController.m
//  webgnosus
//
//  Created by Troy Stribling on 11/5/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "CommandFormViewController.h"
#import "CommandFormView.h"
#import "XMPPIQ.h"
#import "XMPPxData.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface CommandFormViewController (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation CommandFormViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize formScrollView;
@synthesize cancelButton;
@synthesize sendButton;
@synthesize formView;
@synthesize form;

//===================================================================================================================================
#pragma mark CommandFormViewController PrivateAPI

//===================================================================================================================================
#pragma mark CommandFormViewController

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)form:(XMPPIQ*)initForm inView:(UIView*)containedView {
    [[CommandFormViewController alloc] initWithNibName:@"CommandFormViewController" bundle:nil inView:containedView andForm:initForm];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (IBAction)cancelButtonPressed:(id)sender {
    [self.view removeFromSuperview];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (IBAction)sendButtonPressed:(id)sender {
    XMPPxData* fields = [self.formView fields];
}

//===================================================================================================================================
#pragma mark UIViewController

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithNibName:(NSString*)nibName bundle:(NSBundle*)nibBundle inView:(UIView*)parentView andForm:(XMPPIQ*)initForm { 
	if (self = [super initWithNibName:nibName bundle:nibBundle]) { 
        self.view.frame = parentView.frame;
        self.form = initForm;
        self.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        [parentView addSubview:self.view];
	} 
	return self; 
} 

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];	
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated {
    self.formView = [[CommandFormView alloc] initWithForm:self.form inParentView:self.formScrollView];
    [self.formScrollView addSubview:self.formView];
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
#pragma mark UITableViewController

//===================================================================================================================================
#pragma mark UITableViewDeligate

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end

