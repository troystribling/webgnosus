//
//  AccountManagerViewController.m
//  webgnosus
//
//  Created by Troy Stribling on 1/1/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "AccountManagerViewController.h"
#import "EditAccountViewController.h"
#import "AddAccountViewController.h"
#import "AccountModel.h"
#import "SegmentedListPicker.h"
#import "NSObjectiPhoneAdditions.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface AccountManagerViewController (PrivateAPI)

- (UIView*)createView:(Class)viewClass;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation AccountManagerViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize addAccountViewController;
@synthesize editAccountViewController;
@synthesize contentView;
@synthesize contentViewBorder;
@synthesize currentView;

//===================================================================================================================================
#pragma mark AccountManagerViewController

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addAsSubview:(UIView*)parent {
    [parent addSubview:self.view];
    [parent addSubview:self.contentViewBorder];
    [parent addSubview:self.contentView];
    self.addAccountViewController.managerView = self;        
    self.editAccountViewController.managerView = self;        
    if ([AccountModel count] > 0) {
        [self showEditAccountView];
    } else {
        [self showAddAccountView];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dismiss {
    [self.view removeFromSuperview];
    [self.contentViewBorder removeFromSuperview];
    [self.contentView removeFromSuperview];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)showEditAccountView {
    [self.contentView addSubview:self.editAccountViewController.view];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)showAddAccountView {
    [self.contentView addSubview:self.addAccountViewController.view];
}

//===================================================================================================================================
#pragma mark AccountManagerViewController PrivateApi

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)createContentView {
    CGRect mainRect = self.view.frame;
    CGFloat scaleFactor = 0.85f;
    CGFloat boarderWideth = 2.0f;
    CGFloat xoffset = mainRect.origin.x + (1.0f-scaleFactor)*mainRect.size.width/2.0f;
    CGFloat yoffset = mainRect.origin.y + (1.0f-scaleFactor)*mainRect.size.height/2.0f;
    self.contentView = [[UIView alloc] initWithFrame:CGRectInset(mainRect, xoffset, yoffset)];
    self.contentViewBorder = [[UIView alloc] initWithFrame:CGRectInset(mainRect, xoffset-boarderWideth, yoffset-boarderWideth)];
    self.contentView.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"dotted_tile.png"]];
    self.contentViewBorder.backgroundColor = [UIColor blackColor];
}

//===================================================================================================================================
#pragma mark UIViewController

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithCoder:(NSCoder *)coder { 
	if (self = [super initWithCoder:coder]) { 
        [self createContentView];
	} 
	return self; 
} 

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];	
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated {
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

