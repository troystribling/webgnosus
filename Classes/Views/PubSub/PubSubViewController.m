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
#import "SubscriptionModel.h"
#import "ServiceItemModel.h"
#import "PubCell.h"
#import "SubCell.h"
#import "CellUtils.h"
#import "RosterSectionViewController.h"
#import "AccountManagerViewController.h"
#import "AddSubscriptionViewController.h"
#import "AddPublicationViewController.h"
#import "AlertViewManager.h"
#import "XMPPJID.h"
#import "XMPPClientManager.h"
#import "XMPPPubSubOwner.h"
#import "XMPPPubSubSubscriptions.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface PubSubViewController (PrivateAPI)

- (void)failureAlert:(NSString*)message;
- (void)deleteItem:(id)item;
- (void)addPubSubItemWasPressed; 
- (void)editAccountButtonWasPressed; 
- (void)segmentControlSelectionChanged:(id)sender;
- (void)loadPubSubItems;
- (void)reloadPubSubItems;
- (void)addXMPPClientDelgate;
- (void)removeXMPPClientDelgate;
- (void)loadAccount;
- (void)addXMPPAccountUpdateDelgate;
- (void)removeXMPPAccountUpdateDelgate;
- (EventsViewController*)getEventsViewControllerForRowAtIndexPath:(NSIndexPath*)indexPath;
- (UITableViewCell*)tableView:(UITableView *)tableView createCellForRowAtIndexPath:(NSIndexPath *)indexPath;

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
@synthesize itemToDelete;

//===================================================================================================================================
#pragma mark PubSubViewController

//===================================================================================================================================
#pragma mark PubSubViewController PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addPubSubItemWasPressed { 
    if (self.account) {
        UIViewController* addItemController;
        if (self.selectedItem == kSUB_MODE) {
            addItemController = [[AddSubscriptionViewController alloc] initWithNibName:@"AddSubscriptionViewController" bundle:nil]; 
        } else {
            addItemController = [[AddPublicationViewController alloc] initWithNibName:@"AddPublicationViewController" bundle:nil]; 
        }
        [self.navigationController pushViewController:addItemController animated:YES]; 
        [addItemController release];     
    }
}	

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)editAccountButtonWasPressed { 
    [self.accountManagerViewController addAsSubview:self.view.window];	
}	

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)createSegementedController {
    UISegmentedControl* segmentControl = [[UISegmentedControl alloc] initWithItems:[[NSArray alloc] initWithObjects:[UIImage imageNamed:@"subscribe.png"], [UIImage imageNamed:@"publish.png"], nil]];
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
            self.pubSubItems = [SubscriptionModel findAllByAccount:self.account];
        } else {
            self.pubSubItems = [ServiceItemModel findAllByParentNode:[[self.account toJID] pubSubRoot]];
        }
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
- (void)reloadPubSubItems {
    [self loadAccount];
    [self removeXMPPClientDelgate];
    [self addXMPPClientDelgate];
    [self loadPubSubItems];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)loadAccount {
    self.account = [AccountModel findFirstDisplayed];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)deleteItem:(id)item{
    [item destroy];
    [self loadPubSubItems];
    [AlertViewManager dismissConnectionIndicator];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)failureAlert:(NSString*)message { 
    [AlertViewManager dismissConnectionIndicator];
    [AlertViewManager showAlert:@"Error" withMessage:message];
}

//===================================================================================================================================
#pragma mark XMPPClientManagerAccountUpdateDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)didAddAccount {
    [self reloadPubSubItems];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)didRemoveAccount {
    [self reloadPubSubItems];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)didUpdateAccount {
    [self reloadPubSubItems];
}

//===================================================================================================================================
#pragma mark XMPPClientDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceivePubSubDeleteError:(XMPPIQ*)iq {
    [self failureAlert:@"Publish Node Delete Failed"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceivePubSubDeleteResult:(XMPPIQ*)iq {
    ServiceItemModel* item = [self.pubSubItems objectAtIndex:self.itemToDelete];
    [self deleteItem:item];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceivePubSubUnsubscribeError:(XMPPIQ*)iq {
    [self failureAlert:@"Node Unsubscribe Failed"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceivePubSubUnsubscribeResult:(XMPPIQ*)iq {
    SubscriptionModel* item = [self.pubSubItems objectAtIndex:self.itemToDelete];
    [self deleteItem:item];
}

//===================================================================================================================================
#pragma mark UIViewController

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithCoder:(NSCoder *)coder { 
	if (self = [super initWithCoder:coder]) { 
        self.addPubSubItemButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPubSubItemWasPressed)];
        self.editAccountsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(editAccountButtonWasPressed)];
        self.pubSubItems = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [self createSegementedController];
    self.navigationItem.rightBarButtonItem = self.addPubSubItemButton;
    self.navigationItem.leftBarButtonItem = self.editAccountsButton;
    [super viewDidLoad];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated {
    [self loadAccount];
    [self addXMPPClientDelgate];
    [self addXMPPAccountUpdateDelgate];
    [self loadPubSubItems];
	[super viewWillAppear:animated];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillDisappear:(BOOL)animated {
    [self removeXMPPClientDelgate];
    [self removeXMPPAccountUpdateDelgate];
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    if (self.selectedItem == kSUB_MODE) {
        return kSUB_CELL_HEIGHT;
    } else {
        return kPUB_CELL_HEIGHT;
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* rosterHeaderView = nil;
    if (self.account) {
        RosterSectionViewController* rosterHeader = 
            [[RosterSectionViewController alloc] initWithNibName:@"RosterSectionViewController" bundle:nil andLable:[self.account bareJID]]; 
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

//===================================================================================================================================
#pragma mark UITableViewDataSource

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.account) {
        return 1;
    } else {
        return 0;
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell*)tableView:(UITableView *)tableView createCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedItem == kSUB_MODE) {
        SubCell* cell = (SubCell*)[CellUtils createCell:[SubCell class] forTableView:tableView];
        SubscriptionModel* item = [self.pubSubItems objectAtIndex:indexPath.row];
        cell.itemLabel.text = [[item.node componentsSeparatedByString:@"/"] lastObject];
        cell.jidLabel.text = [[item nodeToJID] full];
        return cell;
    } else {
        PubCell* cell = (PubCell*)[CellUtils createCell:[PubCell class] forTableView:tableView];
        ServiceItemModel* item = [self.pubSubItems objectAtIndex:indexPath.row];
        cell.itemLabel.text = item.itemName;
        return cell;
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.pubSubItems count];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    return [self tableView:tableView createCellForRowAtIndexPath:indexPath];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {    
	if (editingStyle == UITableViewCellEditingStyleDelete) { 
        XMPPClient* client = [[XMPPClientManager instance] xmppClientForAccount:self.account];
        self.itemToDelete = indexPath.row;
        if (self.selectedItem == kSUB_MODE) {
            SubscriptionModel* item = [self.pubSubItems objectAtIndex:indexPath.row];
            [XMPPPubSubSubscriptions unsubscribe:client JID:[self.account pubSubService] node:item.node];
        } else {
            ServiceItemModel* item = [self.pubSubItems objectAtIndex:indexPath.row];
            [XMPPPubSubOwner delete:client JID:[XMPPJID jidWithString:item.service] node:item.node];
        }
        [AlertViewManager showConnectingIndicatorInView:self.view];
	} 
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController* viewController = [[EventsViewController alloc] initWithNibName:@"EventsViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end

