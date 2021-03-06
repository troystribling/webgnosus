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
#import "NSObjectWebgnosus.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface AccountManagerViewController (PrivateAPI)

- (UIView*)createView:(Class)viewClass;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation AccountManagerViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize addAccountViewController;
@synthesize editAccountViewController;
@synthesize parentView;
@synthesize contentView;
@synthesize contentViewBorder;
@synthesize currentView;

//===================================================================================================================================
#pragma mark AccountManagerViewController

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)inView:(UIView*)containedView {
    [[[AccountManagerViewController alloc] initWithNibName:@"AccountManagerViewController" bundle:nil inView:containedView] autorelease];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addAsSubview:(UIView*)parent {
    self.parentView = parent;
    [parent addSubview:self.view];
    [parent addSubview:self.contentViewBorder];
    [parent addSubview:self.contentView];
    self.addAccountViewController.managerView = self;        
    self.editAccountViewController.managerView = self;    
    [self showView];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dismiss {
    [self.view removeFromSuperview];
    [self.contentViewBorder removeFromSuperview];
    [self.contentView removeFromSuperview];
    self.parentView = nil;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)showView {
    if ([AccountModel count] > 0) {
        [self showEditAccountView];
    } else {
        [self showAddAccountView];
    }
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
    self.contentView = [[[UIView alloc] initWithFrame:CGRectInset(mainRect, xoffset, yoffset)] autorelease];
    self.contentViewBorder = [[[UIView alloc] initWithFrame:CGRectInset(mainRect, xoffset-boarderWideth, yoffset-boarderWideth)] autorelease];
    self.contentView.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"dotted_tile.png"]];
    self.contentViewBorder.backgroundColor = [UIColor blackColor];
}

//===================================================================================================================================
#pragma mark UIViewController

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithNibName:(NSString*)nibName bundle:(NSBundle*)nibBundle inView:(UIView*)containerView { 
	if (self = [super initWithNibName:nibName bundle:nibBundle]) { 
        [self createContentView];
        self.view.frame = containerView.frame;
        [self addAsSubview:containerView];
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

