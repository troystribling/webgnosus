//
//  ContactChatViewController.m
//  webgnosus
//
//  Created by Troy Stribling on 2/28/09.
//  Copyright 2009 Plan-B Research. All rights reserved.fullJID
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "ContactChatViewController.h"
#import "MessageViewController.h"
#import "MessageModel.h"
#import "UserModel.h"
#import "RosterItemModel.h"
#import "MessageCellFactory.h"
#import "RosterCell.h"
#import "AccountModel.h"
#import "CellUtils.h"
#import "AgentXmppViewController.h"
#import "RosterSectionViewController.h"
#import "XMPPClientManager.h"
#import "XMPPClient.h"
#import "XMPPMessage.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ContactChatViewController (PrivateAPI)

- (UIViewController*)getMessageViewControllerForAccount;
- (void)createSegementedController;
- (void)segmentControlSelectionChanged:(id)sender;
- (void)addMessageButton;
+ (UITableViewCell*)tableView:(UITableView*)tableView cellForResource:(RosterItemModel*)resource;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ContactChatViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize selectedMode;

//===================================================================================================================================
#pragma mark ContactChatViewController

//===================================================================================================================================
#pragma mark ContactChatViewController PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)loadItems {
    if (self.selectedMode == kMESSAGE_MODE) {
        self.items = [MessageModel findAllByJid:[self.partner fullJID] andAccount:self.account withLimit:kMESSAGE_CACHE_SIZE];
    } else {
        self.items = [RosterItemModel findAllByJid:[self.partner fullJID] andAccount:self.account];
    }
    [self.tableView reloadData];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)itemCount {
    NSInteger count;
    if (self.selectedMode == kMESSAGE_MODE) {
        count = [MessageModel countByJid:[self.partner fullJID] andAccount:self.account withLimit:kMESSAGE_CACHE_SIZE];;
    } else {
        count = [RosterItemModel countByJid:[self.partner jid] andAccount:self.account];
    }
    return count;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addMessageButton {
    if (self.selectedMode == kMESSAGE_MODE && [RosterItemModel isJidAvailable:self.partner.jid]) { 
        self.navigationItem.rightBarButtonItem = self.sendMessageButton;
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)createSegementedController {
    UISegmentedControl* segmentControl = [[UISegmentedControl alloc] initWithItems:[[NSArray alloc] initWithObjects:@"Messages", @"Resources", nil]];
    segmentControl.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentControl.tintColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0];
    [segmentControl addTarget:self action:@selector(segmentControlSelectionChanged:) forControlEvents:UIControlEventValueChanged];
    segmentControl.selectedSegmentIndex = kMESSAGE_MODE;
    self.selectedMode = kMESSAGE_MODE;
    self.navigationItem.titleView = segmentControl;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)segmentControlSelectionChanged:(id)sender {
    self.selectedMode = [(UISegmentedControl*)sender selectedSegmentIndex];
    [self addMessageButton];
    [self loadItems];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UITableViewCell*)tableView:(UITableView*)tableView cellForResource:(RosterItemModel*)resource {
    RosterCell* cell = (RosterCell*)[CellUtils createCell:[RosterCell class] forTableView:tableView];
    cell.jidLabel.text = resource.resource;
    cell.activeImage.image = [RosterCell rosterItemImage:resource];
    return cell;
}

//===================================================================================================================================
#pragma mark XMPPClientDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)sender didReceivePresence:(XMPPPresence*)presence {
    if (self.selectedMode == kMESSAGE_MODE) {
        [self.partner load];
        [self addMessageButton];
        [self.tableView reloadData];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient *)sender didReceiveMessage:(XMPPMessage *)message {
    if ([message hasBody] && self.selectedMode == kMESSAGE_MODE) {
        [self loadItems];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)sender didReceiveCommandResult:(XMPPIQ*)iq {
    if (self.selectedMode == kMESSAGE_MODE) {
        [self loadItems];
    }
}

//===================================================================================================================================
#pragma mark UIViewController

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithNibName:(NSString*)nibName bundle:(NSBundle*)nibBundle { 
	if (self = [super initWithNibName:nibName bundle:nibBundle]) { 
        self.sendMessageButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self 
                                   action:@selector(sendMessageButtonWasPressed:)];
	} 
	return self; 
} 

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [self addMessageButton];
    [self createSegementedController];
}

//===================================================================================================================================
#pragma mark UITableViewController

//===================================================================================================================================
#pragma mark UITableViewDeligate

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    CGFloat cellHeight;
    if (self.selectedMode == kMESSAGE_MODE) {
        cellHeight = [MessageCellFactory tableView:tableView heightForRowWithMessage:[self.items objectAtIndex:indexPath.row]];
    } else {
        cellHeight = kROSTER_CELL_HEIGHT;
    }
    return cellHeight;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* rosterHeaderView = nil;
    RosterSectionViewController* rosterHeader = 
        [[RosterSectionViewController alloc] initWithNibName:@"RosterSectionViewController" bundle:nil andLable:[self.partner fullJID]]; 
    rosterHeaderView = rosterHeader.view;
	return rosterHeaderView; 
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

//===================================================================================================================================
#pragma mark UITableViewDataSource

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = [self itemCount];
    return count;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {   
    UITableViewCell* cell;
    if (self.selectedMode == kMESSAGE_MODE) {
        cell = [MessageCellFactory tableView:tableView cellForRowAtIndexPath:indexPath forMessage:[self.items objectAtIndex:indexPath.row]];
    } else {
        RosterItemModel* resource = [self.items objectAtIndex:indexPath.row]; 
        cell = [ContactChatViewController tableView:tableView cellForResource:resource];
    }
    return cell;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    if (self.selectedMode == kRESOURCE_MODE) {
        UserModel* user = [self.items objectAtIndex:indexPath.row];
        ChatViewController* chatViewController = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil andTitle:[user resource]];
        [chatViewController setAccount:self.account];
        [chatViewController setPartner:user];
        [self.navigationController pushViewController:chatViewController animated:YES];
        [chatViewController release];
    }
}

//===================================================================================================================================
#pragma mark UITextViewDelegate

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end

