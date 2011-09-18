//
//  RosterViewController.m
//  webgnosus
//
//  Created by Troy Stribling on 1/19/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "RosterViewController.h"
#import "SectionViewController.h"
#import "AccountManagerViewController.h"
#import "RosterCell.h"
#import "ResourceCell.h"
#import "AddContactViewController.h"
#import "RosterItemViewController.h"
#import "ContactModel.h"
#import "AccountModel.h"
#import "RosterItemModel.h"
#import "MessageModel.h"

#import "CellUtils.h"
#import "AlertViewManager.h"
#import "SegmentedCycleList.h"

#import "XMPPClient.h"
#import "XMPPClientManager.h"
#import "XMPPMessage.h"
#import "XMPPRosterItem.h"
#import "XMPPRosterQuery.h"
#import "XMPPJID.h"
#import "XMPPMessageDelegate.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface RosterViewController (PrivateAPI)

- (void)addContactButtonWasPressed; 
- (void)editAccountButtonWasPressed; 
- (void)createSegementedController;
- (void)labelBackButton;
- (void)rosterAddContactButton;
- (RosterItemViewController*)getChatViewControllerForRowAtIndexPath:(NSIndexPath*)indexPath;
- (void)onXmppClientConnectionError:(XMPPClient*)sender;
- (void)loadRoster;
- (void)loadAccount;
- (void)reloadRoster;
- (void)addXMPPClientDelgate;
- (void)removeXMPPClientDelgate;
- (void)addXMPPAccountUpdateDelgate;
- (void)removeXMPPAccountUpdateDelgate;
- (void)addMessageCountUpdateDelgate;
- (void)removeMessageCountUpdateDelgate;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation RosterViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize addContactButton;
@synthesize editAccountsButton;
@synthesize sectionViewController;
@synthesize roster;
@synthesize account;
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
- (void)editAccountButtonWasPressed { 
    [AccountManagerViewController inView:self.view.window];
}	

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)createSegementedController {
    CGRect rect = CGRectMake(0.0f, 0.0f, 120.0f, 30.0f);
    self.selectedRoster = kCONTACTS_MODE;
    SegmentedCycleList* segmentControl = 
        [[SegmentedCycleList alloc] init:[NSMutableArray arrayWithObjects:@"Contacts", @"Resources", nil] withValueAtIndex:kCONTACTS_MODE andRect:rect];
    segmentControl.delegate = self;
    self.navigationItem.titleView = segmentControl;
    [segmentControl release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)labelBackButton {
    UIBarButtonItem* temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    if (self.selectedRoster == kCONTACTS_MODE) {
        temporaryBarButtonItem.title = @"Contacts";
    } else {
        temporaryBarButtonItem.title = @"Resources";
    } 
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    [temporaryBarButtonItem release];  
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)rosterAddContactButton {
    if (self.selectedRoster == kCONTACTS_MODE) {
        self.navigationItem.rightBarButtonItem = self.addContactButton;
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
    self.navigationItem.leftBarButtonItem = self.editAccountsButton;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (RosterItemViewController*)getChatViewControllerForRowAtIndexPath:(NSIndexPath*)indexPath  {
    RosterItemViewController* chatViewController = nil;
    UserModel* user = [self.roster objectAtIndex:indexPath.row];
    if (self.selectedRoster == kCONTACTS_MODE) {
        chatViewController = [RosterItemViewController viewWithNibName:@"RosterItemViewController" bundle:nil];
    } else {
        chatViewController = [RosterItemViewController viewWithNibName:@"RosterItemViewController" bundle:nil andTitle:[user resource]];
    }
    chatViewController.rosterMode = self.selectedRoster;
    chatViewController.account = self.account;
    chatViewController.rosterItem = user;
    return chatViewController;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)onXmppClientConnectionError:(XMPPClient*)sender {
    AccountModel* errAccount = [XMPPMessageDelegate accountForXMPPClient:sender];
    [[XMPPClientManager instance] removeXMPPClientForAccount:errAccount];
    [AlertViewManager onStartDismissConnectionIndicatorAndShowErrors];
    [self loadAccount];
    [self loadRoster];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)loadRoster {
    if (self.account) {
        if (self.selectedRoster == kCONTACTS_MODE) {
            self.roster = [ContactModel findAllByAccount:self.account];
        } else {
            self.roster = [RosterItemModel findAllResourcesByAccount:self.account];
        }
    } 
    [self.tableView reloadData];
}


//-----------------------------------------------------------------------------------------------------------------------------------
- (void)loadAccount {
    self.account = [AccountModel findFirstDisplayed];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)reloadRoster {
    [self loadAccount];
    [self removeXMPPClientDelgate];
    [self addXMPPClientDelgate];
    [self loadRoster];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addXMPPClientDelgate {
    if (self.account) {
        [[XMPPClientManager instance] delegateTo:self forAccount:self.account];
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
- (void)addMessageCountUpdateDelgate {
    [[XMPPClientManager instance] addMessageCountUpdateDelegate:self];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)removeMessageCountUpdateDelgate {
    [[XMPPClientManager instance] removeMessageCountUpdateDelegate:self];
}

//===================================================================================================================================
#pragma mark XMPPClientManagerAccountUpdateDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)didAddAccount {
    [self reloadRoster];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)didRemoveAccount {
    [self reloadRoster];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)didUpdateAccount {
    [self reloadRoster];
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
- (void)xmppClient:(XMPPClient*)sender didReceiveAllRosterItems:(XMPPIQ *)iq {
    [self loadAccount];
    [self loadRoster];
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
    [AlertViewManager dismissActivityIndicator];
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
#pragma mark XMPPClientManagerMessageCountUpdateDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)messageCountDidChange {
    [self.tableView reloadData];
}

//===================================================================================================================================
#pragma mark SegmentedCycleList Delegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)selectedItemChanged:(SegmentedCycleList*)sender {
    self.selectedRoster = sender.selectedItemIndex;
    [self loadAccount];
    [self loadRoster];
    [self rosterAddContactButton];
}

//===================================================================================================================================
#pragma mark UIViewController

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithCoder:(NSCoder *)coder { 
	if (self = [super initWithCoder:coder]) { 
        self.addContactButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addContactButtonWasPressed)] autorelease];
        self.editAccountsButton = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(editAccountButtonWasPressed)] autorelease];
	} 
	return self; 
} 

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadAccount];
    [self rosterAddContactButton];
    [self createSegementedController];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated {
    [self loadAccount];
    [self addXMPPClientDelgate];
    [self addXMPPAccountUpdateDelgate];
    [self addMessageCountUpdateDelgate];
    [self loadRoster];
	[super viewWillAppear:animated];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillDisappear:(BOOL)animated {
    [self removeXMPPClientDelgate];
    [self removeXMPPAccountUpdateDelgate];
    [self removeMessageCountUpdateDelgate];
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
    UIView* sectionView = nil;
    if (self.account) {
        self.sectionViewController = [SectionViewController viewControllerWithLabel:[self.account jid]];
        sectionView = self.sectionViewController.view;
    }
	return sectionView; 
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.roster count];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    if (self.selectedRoster == kCONTACTS_MODE) {
        RosterCell* cell = (RosterCell*)[CellUtils createCell:[RosterCell class] forTableView:tableView];
        ContactModel*  cellItem = [self.roster objectAtIndex:indexPath.row]; 
        cell.resourceLabel.text = cellItem.jid;
        cell.activeImage.image = [RosterCell contactImage:[self.roster objectAtIndex:indexPath.row]];
        cell.jid = [cellItem toJID];
        [cell setUnreadMessageCount:self.account];
        return cell;
    } else {
        ResourceCell* cell = (ResourceCell*)[CellUtils createCell:[ResourceCell class] forTableView:tableView];
        RosterItemModel*  cellItem = [self.roster objectAtIndex:indexPath.row]; 
        cell.resourceLabel.text = cellItem.resource;
        cell.jid = [cellItem toJID];
        [cell setUnreadMessageCount:self.account];
        return cell;
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {    
	if (editingStyle == UITableViewCellEditingStyleDelete) { 
        ContactModel* contact = [self.roster objectAtIndex:indexPath.row]; 
        XMPPClient* xmppClient = [[XMPPClientManager instance] xmppClientForAccount:account];
		XMPPJID* contactJID = [XMPPJID jidWithString:[contact bareJID]];
        [XMPPRosterQuery remove:xmppClient JID:contactJID];
        [AlertViewManager showActivityIndicatorInView:self.view.window withTitle:@"Deleting"];
	} 
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    RosterItemViewController* chatViewController = [self getChatViewControllerForRowAtIndexPath:indexPath];
    if (chatViewController) {
        [self labelBackButton];
        [self.navigationController pushViewController:chatViewController animated:YES];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL canEdit = NO;
    if (self.selectedRoster == kCONTACTS_MODE) {
        canEdit = YES;
    }
    return canEdit;
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [addContactButton release];
    [editAccountsButton release];
    [sectionViewController release];
    [roster release];
    [account release];
    [super dealloc];
}

@end

