//
//  RosterViewController.m
//  webgnosus
//
//  Created by Troy Stribling on 1/19/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "RosterViewController.h"
#import "RosterSectionViewController.h"
#import "RosterCell.h"
#import "AddContactViewController.h"
#import "ChatViewController.h"
#import "ContactChatViewController.h"
#import "ActivityView.h"
#import "ContactModel.h"
#import "AccountModel.h"
#import "RosterItemModel.h"
#import "AgentXmppViewController.h"
#import "CellUtils.h"
#import "XMPPClient.h"
#import "XMPPClientManager.h"
#import "XMPPMessage.h"
#import "XMPPRosterItem.h"
#import "XMPPRosterQuery.h"
#import "XMPPJID.h"
#import "XMPPMessageDelegate.h"
#import "AlertViewManager.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface RosterViewController (PrivateAPI)

- (void)createSegementedController;
- (void)segmentControlSelectionChanged:(id)sender;
- (void)loadRoster;
- (void)rosterAddContactButton;
- (NSInteger)rosterCount;
- (ChatViewController*)getChatViewControllerForRowAtIndexPath:(NSIndexPath*)indexPath;
- (UIImage*)getImageForCellStatusAtSection:(NSInteger)section andRow:(NSInteger)row;
- (NSString*)getCellTextAtSection:(NSInteger)section andRow:(NSInteger)row;
- (void)addXMPPClientDelgate;
- (void)removeXMPPClientDelgate;
- (void)onXmppClientConnectionError:(XMPPClient*)sender;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation RosterViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize addContactButton;
@synthesize roster;
@synthesize accounts;
@synthesize selectedRoster;

//===================================================================================================================================
#pragma mark RosterViewController

//===================================================================================================================================
#pragma mark RosterViewController PrivateApi

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addContactButtonWasPressed { 
	AddContactViewController* addContactViewController = [[AddContactViewController alloc] initWithNibName:@"AddContactViewController" bundle:nil]; 
	[self.navigationController pushViewController:addContactViewController animated:YES]; 
	[addContactViewController release]; 
}	

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)createSegementedController {
    UISegmentedControl* segmentControl = [[UISegmentedControl alloc] initWithItems:[[NSArray alloc] initWithObjects:@"Contacts", @"Resources", nil]];
    segmentControl.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentControl.tintColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0];
    [segmentControl addTarget:self action:@selector(segmentControlSelectionChanged:) forControlEvents:UIControlEventValueChanged];
    segmentControl.selectedSegmentIndex = kCONTACTS_MODE;
    self.selectedRoster = kCONTACTS_MODE;
    self.navigationItem.titleView = segmentControl;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void) segmentControlSelectionChanged:(id)sender {
    self.selectedRoster = [(UISegmentedControl*)sender selectedSegmentIndex];
    [self loadRoster];
    [self rosterAddContactButton];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)loadRoster {
    self.roster = [[NSMutableArray alloc] init];
    for (int i =0; i < [self.accounts count]; i++) {
        AccountModel* account = [self.accounts objectAtIndex:i];
        NSMutableArray* rosterForAccount;
        if (self.selectedRoster == kCONTACTS_MODE) {
            rosterForAccount = [ContactModel findAllByAccount:account];
        } else {
            rosterForAccount = [RosterItemModel findAllResourcesByAccount:account];
        }
        [self.roster addObject:rosterForAccount];
        [rosterForAccount release];
    }
    [self.tableView reloadData];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)rosterCount {
    NSInteger count;
    if (self.selectedRoster == kCONTACTS_MODE) {
        count = [ContactModel count];
    } else {
       count =  [RosterItemModel count];
    }
    return count;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)rosterAddContactButton {
    if (self.selectedRoster == kCONTACTS_MODE) {
        self.navigationItem.rightBarButtonItem = self.addContactButton;
        self.navigationItem.leftBarButtonItem = self.editButtonItem;
    } else {
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = nil;
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (ChatViewController*)getChatViewControllerForRowAtIndexPath:(NSIndexPath*)indexPath  {
    ChatViewController* chatViewController;
    UserModel* user = [[self.roster objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (self.selectedRoster == kCONTACTS_MODE) {
        chatViewController = [[ContactChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
    } else {
        chatViewController = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil andTitle:[user resource]];
    }
    [chatViewController setAccount:[self.accounts objectAtIndex:indexPath.section]];
    [chatViewController setPartner:user];
    return chatViewController;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)getCellTextAtSection:(NSInteger)section andRow:(NSInteger)row {
    NSString* cellTitle;
    NSMutableArray* rosterForAccount = [self.roster objectAtIndex:section];
    if (self.selectedRoster == kCONTACTS_MODE) {
        ContactModel*  cellItem = [rosterForAccount objectAtIndex:row]; 
        cellTitle = cellItem.nickname;
    } else {
        RosterItemModel*  cellItem = [rosterForAccount objectAtIndex:row]; 
         cellTitle = cellItem.resource;
    }
    return cellTitle;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (UIImage*)getImageForCellStatusAtSection:(NSInteger)section andRow:(NSInteger)row {
    NSMutableArray* rosterForAccount = [self.roster objectAtIndex:section];
    if (self.selectedRoster == kCONTACTS_MODE) {
        return [RosterCell contactImage:(ContactModel*)[rosterForAccount objectAtIndex:row]];
    }
    return [RosterCell rosterItemImage:(RosterItemModel*)[rosterForAccount objectAtIndex:row]];
}
            
//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addXMPPClientDelgate {
	NSMutableArray* activatedAccounts = [AccountModel findAllActivated]; 
    for (int i = 0; i < [activatedAccounts count]; i++) {
        AccountModel* account = [activatedAccounts objectAtIndex:i];
        [[XMPPClientManager instance] xmppClientForAccount:account andDelegateTo:self];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)removeXMPPClientDelgate {
	NSMutableArray* activatedAccounts = [AccountModel findAllActivated]; 
    for (int i = 0; i < [activatedAccounts count]; i++) {
        AccountModel* account = [activatedAccounts objectAtIndex:i];
        [[XMPPClientManager instance] removeXMPPClientDelegate:self forAccount:account];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)onXmppClientConnectionError:(XMPPClient*)sender {
    AccountModel* account = [XMPPMessageDelegate accountForXMPPClient:sender];
    self.accounts = [AccountModel findAllReady];
    [[XMPPClientManager instance] removeXMPPClientForAccount:account];
    [AlertViewManager onStartDismissConnectionIndicatorAndShowErrors];
    [self loadRoster];
}

//===================================================================================================================================
#pragma mark XMPPClientDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClientDidConnect:(XMPPClient*)sender {
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClientDidAuthenticate:(XMPPClient*)sender {
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)sender didFinishReceivingRosterItems:(XMPPIQ *)iq {
    self.accounts = [AccountModel findAllReady];
    [AlertViewManager onStartDismissConnectionIndicatorAndShowErrors];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClientDidNotConnect:(XMPPClient*)sender {
    [self onXmppClientConnectionError:sender];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient *)sender didNotAuthenticate:(NSXMLElement*)error {
    [self onXmppClientConnectionError:sender];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)sender didReceivePresence:(XMPPPresence*)presence {
    [self loadRoster];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)sender didReceiveErrorPresence:(XMPPPresence*)presence {
    [self loadRoster];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)sender didRemoveFromRoster:(XMPPRosterItem*)item {
    [AlertViewManager dismissConnectionIndicator];
    [self loadRoster];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)sender didAddToRoster:(XMPPRosterItem*)item {
    [self loadRoster];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)sender didRejectBuddyRequest:(XMPPJID*)buddyJid {
    [self loadRoster];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)sender didAcceptBuddyRequest:(XMPPJID*)buddyJid {
    [self loadRoster];
}

//===================================================================================================================================
#pragma mark UIViewController

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithCoder:(NSCoder *)coder { 
	if (self = [super initWithCoder:coder]) { 
        self.addContactButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addContactButtonWasPressed)];
	} 
	return self; 
} 

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    self.accounts = [AccountModel findAllReady];
    [self rosterAddContactButton];
    [self createSegementedController];
    [AlertViewManager onStartshowConnectingIndicatorInView:self.view];
    [AlertViewManager onStartDismissConnectionIndicatorAndShowErrors];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated {
    self.accounts = [AccountModel findAllReady];
    [self addXMPPClientDelgate];
    [self loadRoster];
	[super viewWillAppear:animated];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillDisappear:(BOOL)animated {
    [self removeXMPPClientDelgate];
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
#pragma mark UITableViewDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* rosterHeaderView = nil;
    if ([self.accounts count] > 0) {
        RosterSectionViewController* rosterHeader = 
            [[RosterSectionViewController alloc] initWithNibName:@"RosterSectionViewController" bundle:nil andLable:[[self.accounts objectAtIndex:section] nickname]]; 
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
    NSInteger count = [self.accounts count];
    if (count < 1) {
        count = 1;
    }
    return count;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger count = 0;
    if ([self.roster count] > section) {
        count = [[self.roster objectAtIndex:section] count];
    }
    return count;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    RosterCell* cell = (RosterCell*)[CellUtils createCell:[RosterCell class] forTableView:tableView];
    cell.jidLabel.text = [self getCellTextAtSection:[indexPath section] andRow:[indexPath row]];
    cell.activeImage.image = [self getImageForCellStatusAtSection:[indexPath section] andRow:[indexPath row]];
    return cell;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {    
	if (editingStyle == UITableViewCellEditingStyleDelete) { 
        AccountModel* account = [self.accounts objectAtIndex:indexPath.section];
        NSMutableArray* accountRoster = [self.roster objectAtIndex:indexPath.section];
        ContactModel* contact = [accountRoster objectAtIndex:indexPath.row]; 
        XMPPClient* xmppClient = [[XMPPClientManager instance] xmppClientForAccount:account];
		XMPPJID* contactJID = [XMPPJID jidWithString:contact.jid];
        [XMPPRosterQuery remove:xmppClient JID:contactJID];
        [AlertViewManager showConnectingIndicatorInView:self.view];
	} 
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    ChatViewController* chatViewController = [self getChatViewControllerForRowAtIndexPath:indexPath];
    [self.navigationController pushViewController:chatViewController animated:YES];
    [chatViewController release];
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end

