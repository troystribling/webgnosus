//
//  RosterItemViewController.m
//  webgnosus
//
//  Created by Troy Stribling on 2/28/09.
//  Copyright 2009 Plan-B Research. All rights reserved.fullJID
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "RosterItemViewController.h"
#import "MessageViewController.h"
#import "CommandViewController.h"
#import "MessageModel.h"
#import "UserModel.h"
#import "RosterItemModel.h"
#import "MessageCellFactory.h"
#import "RosterCell.h"
#import "AccountModel.h"
#import "CellUtils.h"
#import "RosterSectionViewController.h"
#import "SegmentedCycleList.h"
#import "XMPPClientManager.h"
#import "XMPPClient.h"
#import "XMPPMessage.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface RosterItemViewController (PrivateAPI)

- (void)loadItems;
- (void)createSegementedController;
- (void)addMessageButton;
- (void)loadAccount;
- (void)addXMPPClientDelgate;
- (void)removeXMPPClientDelgate;
- (UIViewController*)getMessageViewControllerForAccount;
- (void)sendMessageButtonWasPressed:(id)sender;
+ (UITableViewCell*)tableView:(UITableView*)tableView cellForResource:(RosterItemModel*)resource;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation RosterItemViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize selectedMode;
@synthesize sendMessageButton;
@synthesize items;
@synthesize account;
@synthesize rosterItem;

//===================================================================================================================================
#pragma mark RosterItemViewController

//===================================================================================================================================
#pragma mark RosterItemViewController PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)sendMessageButtonWasPressed:(id)sender {
	UIViewController* viewController = [self getMessageViewControllerForAccount]; 
	[self.navigationController pushViewController:viewController animated:YES]; 
}	

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)loadItems {
    if (self.selectedMode == kCHAT_MODE) {
        self.items = [MessageModel findAllByJid:[self.rosterItem fullJID] account:self.account andTextType:MessageTextTypeBody withLimit:kMESSAGE_CACHE_SIZE];
    } else if (self.selectedMode == kCOMMAND_MODE) {
        self.items = [MessageModel findAllByJid:[self.rosterItem fullJID] account:self.account andTextType:MessageTextTypeCommand withLimit:kMESSAGE_CACHE_SIZE];
    } else if (self.selectedMode == kPUBLICATIONS_MODE) {
    } else if (self.selectedMode == kRESOURCE_MODE) {
        self.items = [RosterItemModel findAllByJid:[self.rosterItem fullJID] andAccount:self.account];
    }
    [self.tableView reloadData];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)itemCount {
    NSInteger count;
    if (self.selectedMode == kCHAT_MODE) {
        count = [MessageModel countByJid:[self.rosterItem fullJID] account:self.account andTextType:MessageTextTypeBody withLimit:kMESSAGE_CACHE_SIZE];;
    } else if (self.selectedMode == kCOMMAND_MODE) {
        count = [MessageModel countByJid:[self.rosterItem fullJID] account:self.account andTextType:MessageTextTypeCommand withLimit:kMESSAGE_CACHE_SIZE];;
    } else if (self.selectedMode == kPUBLICATIONS_MODE) {
    } else if (self.selectedMode == kRESOURCE_MODE) {
        count = [RosterItemModel countByJid:[self.rosterItem bareJID] andAccount:self.account];
    }
    return count;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addMessageButton {
    if (self.selectedMode == kCHAT_MODE && [RosterItemModel isJidAvailable:[self.rosterItem bareJID]]) { 
        self.navigationItem.rightBarButtonItem = self.sendMessageButton;
    } else if (self.selectedMode == kCOMMAND_MODE && [RosterItemModel isJidAvailable:[self.rosterItem bareJID]]) {
        self.navigationItem.rightBarButtonItem = self.sendMessageButton;
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)createSegementedController {
    CGRect rect = CGRectMake(0.0f, 0.0f, 150.0f, 30.0f);
    self.selectedMode = kCHAT_MODE;
    SegmentedCycleList* segmentControl = 
        [[SegmentedCycleList alloc] init:[NSMutableArray arrayWithObjects:@"Chat", @"Resources", @"Commands", @"Publications", nil] withValueAtIndex:kCHAT_MODE rect:rect andColor:[UIColor whiteColor]];
    segmentControl.tintColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0];
    segmentControl.delegate = self;
    self.navigationItem.titleView = segmentControl;
    [segmentControl release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UITableViewCell*)tableView:(UITableView*)tableView cellForResource:(RosterItemModel*)resource {
    RosterCell* cell = (RosterCell*)[CellUtils createCell:[RosterCell class] forTableView:tableView];
    cell.jidLabel.text = resource.resource;
    cell.activeImage.image = [RosterCell rosterItemImage:resource];
    return cell;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (UIViewController*)getMessageViewControllerForAccount {
    [self.rosterItem load];
    if (self.selectedMode == kCHAT_MODE) {
        MessageViewController* viewController = [[MessageViewController alloc] initWithNibName:@"MessageViewController" bundle:nil];
        [viewController setAccount:self.account];
        [viewController setPartner:self.rosterItem];
        return [viewController autorelease];
    } else if (self.selectedMode == kCOMMAND_MODE) {
        CommandViewController* viewController = [[CommandViewController alloc] initWithNibName:@"CommandViewController" bundle:nil];
        viewController.account = self.account;
        viewController.rosterItem =  self.rosterItem;
        return [viewController autorelease];
    } 
    return nil;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)loadAccount {
    self.account = [AccountModel findFirstDisplayed];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addXMPPClientDelgate {
    [[XMPPClientManager instance] xmppClientForAccount:self.account andDelegateTo:self];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)removeXMPPClientDelgate {
    [[XMPPClientManager instance] removeXMPPClientDelegate:self forAccount:self.account];
}

//===================================================================================================================================
#pragma mark XMPPClientDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)sender didReceivePresence:(XMPPPresence*)presence {
    if (self.selectedMode == kCHAT_MODE) {
        [self.rosterItem load];
        [self addMessageButton];
        [self.tableView reloadData];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient *)sender didReceiveMessage:(XMPPMessage *)message {
    if ([message hasBody] && self.selectedMode == kCHAT_MODE) {
        [self loadItems];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)sender didReceiveCommandError:(XMPPIQ*)iq {
    if (self.selectedMode == kCOMMAND_MODE) {
        [self loadItems];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)sender didReceiveCommandResult:(XMPPIQ*)iq {
    if (self.selectedMode == kCOMMAND_MODE) {
        [self loadItems];
    }
}

//===================================================================================================================================
#pragma mark SegmentedCycleList Delegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)selectedItemChanged:(SegmentedCycleList*)sender {
    self.selectedMode = sender.selectedItemIndex;
    [self addMessageButton];
    [self loadItems];
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
- (id)initWithNibName:(NSString*)nibName bundle:(NSBundle*)nibBundle andTitle:(NSString*)viewTitle { 
	if (self = [self initWithNibName:nibName bundle:nibBundle]) { 
        self.title = viewTitle;
	} 
	return self; 
} 

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [self addMessageButton];
    [self createSegementedController];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated {
    [self addXMPPClientDelgate];
    [self loadAccount];
    [self loadItems];
	[super viewWillAppear:animated];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; 
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillDisappear:(BOOL)animated {
    [self removeXMPPClientDelgate];
	[super viewWillDisappear:animated];
}

//===================================================================================================================================
#pragma mark UITableViewController

//===================================================================================================================================
#pragma mark UITableViewDeligate

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    CGFloat cellHeight;
    if (self.selectedMode == kCHAT_MODE) {
        cellHeight = [MessageCellFactory tableView:tableView heightForRowWithMessage:[self.items objectAtIndex:indexPath.row]];
    } else if (self.selectedMode == kCOMMAND_MODE) {
        cellHeight = [MessageCellFactory tableView:tableView heightForRowWithMessage:[self.items objectAtIndex:indexPath.row]];
    } else if (self.selectedMode == kPUBLICATIONS_MODE) {
        cellHeight = kPUB_CELL_HEIGHT;
    } else if (self.selectedMode == kRESOURCE_MODE) {
        cellHeight = kROSTER_CELL_HEIGHT;
    }
    return cellHeight;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* rosterHeaderView = nil;
    RosterSectionViewController* rosterHeader = 
        [[RosterSectionViewController alloc] initWithNibName:@"RosterSectionViewController" bundle:nil andLable:[self.rosterItem fullJID]]; 
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
    if (self.selectedMode == kCHAT_MODE) {
        cell = [MessageCellFactory tableView:tableView cellForRowAtIndexPath:indexPath forMessage:[self.items objectAtIndex:indexPath.row]];
    } else if (self.selectedMode == kCOMMAND_MODE) {
        cell = [MessageCellFactory tableView:tableView cellForRowAtIndexPath:indexPath forMessage:[self.items objectAtIndex:indexPath.row]];
    } else if (self.selectedMode == kPUBLICATIONS_MODE) {
    } else if (self.selectedMode == kRESOURCE_MODE) {
        cell = [RosterItemViewController tableView:tableView cellForResource:[self.items objectAtIndex:indexPath.row]];
    }
    return cell;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    if (self.selectedMode == kRESOURCE_MODE) {
        UserModel* user = [self.items objectAtIndex:indexPath.row];
        RosterItemViewController* chatViewController = [[RosterItemViewController alloc] initWithNibName:@"RosterItemViewController" bundle:nil andTitle:[user resource]];
        [chatViewController setAccount:self.account];
        chatViewController.rosterItem = user;
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

