//
//  PubSubViewController.m
//  webgnosus
//
//  Created by Troy Stribling on 9/7/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "PubSubViewController.h"
#import "EventsViewController.h"
#import "AccountModel.h"
#import "AccountManagerViewController.h"
#import "XMPPClientManager.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface PubSubViewController (PrivateAPI)

- (void)addPubSubItemWasPressed; 
- (void)editAccountButtonWasPressed; 
- (void)segmentControlSelectionChanged:(id)sender;
- (void)loadPubSubItems;
- (EventsViewController*)getEventsViewControllerForRowAtIndexPath:(NSIndexPath*)indexPath;
- (void)addXMPPClientDelgate;
- (void)removeXMPPClientDelgate;
- (void)loadAccount;
- (void)addXMPPAccountUpdateDelgate;
- (void)removeXMPPAccountUpdateDelgate;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation PubSubViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize addPubSubItemButton;
@synthesize editAccountsButton;
@synthesize accountManagerViewController;
@synthesize pubSubItems;
@synthesize account;
@synthesize selectedItem;

//===================================================================================================================================
#pragma mark PubSubViewController

//===================================================================================================================================
#pragma mark PubSubViewController PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addPubSubItemWasPressed { 
}	

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)editAccountButtonWasPressed { 
    [self.accountManagerViewController addAsSubview:self.view.window];	
}	

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)createSegementedController {
    UISegmentedControl* segmentControl = [[UISegmentedControl alloc] initWithItems:[[NSArray alloc] initWithObjects:@"Subscriptions", @"Publications", nil]];
    segmentControl.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentControl.tintColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0];
    [segmentControl addTarget:self action:@selector(segmentControlSelectionChanged:) forControlEvents:UIControlEventValueChanged];
    segmentControl.selectedSegmentIndex = kSUB_MODE;
    self.selectedItem = kSUB_MODE;
    self.navigationItem.titleView = segmentControl;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void) segmentControlSelectionChanged:(id)sender {
    self.selectedItem = [(UISegmentedControl*)sender selectedSegmentIndex];
    [self loadPubSubItems];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)loadPubSubItems {
    if (self.account) {
        if (self.selectedItem == kSUB_MODE) {
            self.pubSubItems = [[NSMutableArray alloc] initWithCapacity:0];
        } else {
            self.pubSubItems = [[NSMutableArray alloc] initWithCapacity:0];
        }
    } else {
        self.pubSubItems = [[NSMutableArray alloc] initWithCapacity:0];
    }
    [self.tableView reloadData];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addXMPPClientDelgate {
    if (self.account) {
        [[XMPPClientManager instance] xmppClientForAccount:self.account andDelegateTo:self];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)removeXMPPClientDelgate {
    if (self.account) {
        [[XMPPClientManager instance] removeXMPPClientDelegate:self forAccount:self.account];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addXMPPAccountUpdateDelgate {
    [[XMPPClientManager instance] addAccountUpdateDelegate:self];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)removeXMPPAccountUpdateDelgate {
    [[XMPPClientManager instance] removeAccountUpdateDelegate:self];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)loadAccount {
    self.account = [AccountModel findFirstDisplayed];
}

//===================================================================================================================================
#pragma mark UIViewController

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
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
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
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

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end

