//
//  AccountsViewController.m
//  webgnosus
//
//  Created by Troy Stribling on 1/1/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "AccountsViewController.h"
#import "AddAccountViewController.h"
#import "EditAccountViewController.h"
#import "AccountModel.h"
#import "RosterItemModel.h"
#import "ContactModel.h"
#import "AccountCell.h"
#import "CellUtils.h"

#import "XMPPClientManager.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface AccountsViewController (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation AccountsViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize addAccountButton;
@synthesize accounts;

//===================================================================================================================================
#pragma mark AccountsViewController

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addAccountButtonWasPressed { 
	AddAccountViewController* addAccountViewController = [[AddAccountViewController alloc] initWithNibName:@"AddAccountViewController" bundle:nil]; 
	[self.navigationController pushViewController:addAccountViewController animated:YES]; 
	[addAccountViewController release]; 
}	

//-----------------------------------------------------------------------------------------------------------------------------------
- (AccountCell*) createAccountCellFromNib { 
	NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"AccountCell" owner:self options:nil]; 
	NSEnumerator *nibEnumerator = [nibContents objectEnumerator]; 
	AccountCell* cell = nil; 
	NSObject* nibItem = nil; 
	while ((nibItem = [nibEnumerator nextObject]) != nil) { 
		if ([nibItem isKindOfClass:[AccountCell class]]) { 
			cell = (AccountCell*) nibItem; 
			if ([cell.reuseIdentifier isEqualToString: @"Account"]) 
				break; 
			else 
				cell = nil; 
		} 
	} 
	return cell; 
} 

//===================================================================================================================================
#pragma mark AccountsViewController PrivateApi

//===================================================================================================================================
#pragma mark UIViewController

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithCoder:(NSCoder *)coder { 
	if (self = [super initWithCoder:coder]) { 
        self.addAccountButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAccountButtonWasPressed)];
	} 
	return self; 
} 

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];	
    self.navigationItem.rightBarButtonItem = self.addAccountButton;
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated {
	self.accounts = [AccountModel findAll];
	[self.tableView reloadData];
	[super viewWillAppear:animated];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillDisappear:(BOOL)animated {
	[self.accounts release];
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
#pragma mark UITableViewDataSource

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger count = [AccountModel count];
    return count;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {   
    AccountModel* account = [self.accounts objectAtIndex:indexPath.row];
    AccountCell* cell = (AccountCell*)[CellUtils createCell:[AccountCell class] forTableView:tableView];
    cell.jidLabel.text = [[NSString alloc] initWithString:account.nickname];
    if ([account isReady]) {
        cell.connectedImage.image = [UIImage imageNamed:@"account-on-led.jpg"];
    } else if([account hasError]) {
        cell.connectedImage.image = [UIImage imageNamed:@"account-error-led.jpg"];
    } else {
        cell.connectedImage.image = [UIImage imageNamed:@"account-off-led.jpg"];
    }
    cell.accountsViewController = self;
    return cell;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath { 
	[tableView beginUpdates]; 
	if (editingStyle == UITableViewCellEditingStyleDelete) { 
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade]; 
		AccountModel*  account = [self.accounts objectAtIndex:indexPath.row]; 
		[[XMPPClientManager instance] removeXMPPClientForAccount:account];
		[account destroy];
		[self.accounts removeObjectAtIndex:indexPath.row]; 
	} 
    [tableView endUpdates];	
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    AccountModel*  account = [self.accounts objectAtIndex:indexPath.row]; 
	EditAccountViewController* editAccountViewController = [[EditAccountViewController alloc] initWithNibName:@"EditAccountViewController" bundle:nil]; 
	editAccountViewController.accountsViewController = self; 
    editAccountViewController.account = account;
	[self.navigationController pushViewController:editAccountViewController animated:YES]; 
	[editAccountViewController release];
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
	[addAccountButton release];
	[accounts release];
    [super dealloc];
}

@end

