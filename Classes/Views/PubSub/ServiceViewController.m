//
//  ServiceViewController.m
//  webgnosus
//
//  Created by Troy Stribling on 10/11/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "ServiceViewController.h"
#import "ServiceCell.h"
#import "AccountManagerViewController.h"
#import "AccountModel.h"
#import "MessageCellFactory.h"
#import "RosterSectionViewController.h"
#import "CellUtils.h"

#import "XMPPClientManager.h"
#import "XMPPClient.h"
#import "XMPPMessage.h"


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ServiceViewController (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ServiceViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize editAccountsButton;
@synthesize services;
@synthesize account;

//===================================================================================================================================
#pragma mark ServiceViewController

//===================================================================================================================================
#pragma mark ServiceViewController PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)editAccountButtonWasPressed { 
    [AccountManagerViewController inView:self.view.window];
}	

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)loadServices {
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
- (void)loadAccount {
    self.account = [AccountModel findFirstDisplayed];
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
- (void)reloadMessages {
    [self loadAccount];
    [self removeXMPPClientDelgate];
    [self addXMPPClientDelgate];
    [self loadServices];
}

//===================================================================================================================================
#pragma mark XMPPClientManagerAccountUpdateDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)didAddAccount {
    [self reloadMessages];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)didRemoveAccount {
    [self reloadMessages];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)didUpdateAccount {
    [self reloadMessages];
}

//===================================================================================================================================
#pragma mark XMPPClientDelegate

//===================================================================================================================================
#pragma mark UIViewController

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithCoder:(NSCoder *)coder { 
	if (self = [super initWithCoder:coder]) { 
        self.editAccountsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(editAccountButtonWasPressed)];
	} 
	return self; 
} 

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad {    
    self.navigationItem.leftBarButtonItem = self.editAccountsButton;
    [super viewDidLoad];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated {
    [self loadAccount];
    [self addXMPPClientDelgate];
    [self addXMPPAccountUpdateDelgate];
    [self loadServices];
	[super viewWillAppear:animated];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillDisappear:(BOOL)animated {
    [self removeXMPPClientDelgate];
    [self addXMPPAccountUpdateDelgate];
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

//-----------------------------------------------------------------------------------------------------------------------------------
- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* rosterHeaderView = nil;
    if (self.account) {
        RosterSectionViewController* rosterHeader = [[RosterSectionViewController alloc] initWithNibName:@"RosterSectionViewController" bundle:nil andLable:[self.account jid]]; 
        rosterHeaderView = rosterHeader.view;
    }
	return rosterHeaderView; 
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    return kCELL_SECTION_TITLE_HEIGHT;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    return kSERVICE_CELL_HEIGHT;
}

//===================================================================================================================================
#pragma mark UITableViewDataSource

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.services count];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {        
    ServiceCell* cell = (ServiceCell*)[CellUtils createCell:[ServiceCell class] forTableView:tableView];
    return cell;        
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

