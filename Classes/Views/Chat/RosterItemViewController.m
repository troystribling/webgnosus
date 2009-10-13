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
#import "SectionViewController.h"

#import "MessageModel.h"
#import "UserModel.h"
#import "RosterItemModel.h"
#import "ServiceItemModel.h"
#import "AccountModel.h"

#import "MessageCellFactory.h"
#import "RosterCell.h"
#import "ContactPubCell.h"

#import "XMPPClientManager.h"
#import "XMPPClient.h"
#import "XMPPMessage.h"
#import "XMPPJID.h"

#import "CellUtils.h"
#import "SegmentedCycleList.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface RosterItemViewController (PrivateAPI)

+ (UITableViewCell*)tableView:(UITableView*)tableView cellForResource:(RosterItemModel*)resource;
+ (UITableViewCell*)tableView:(UITableView*)tableView cellForContactPub:(ServiceItemModel*)item;
- (void)sendMessageButtonWasPressed:(id)sender;
- (void)createAddItemButton;
- (void)createSegementedController;
- (UIViewController*)getMessageViewControllerForAccount;
- (void)labelBackButton;
- (void)setModes;
- (NSInteger)selectedIndexFromMode;
- (void)selectedModeFromIndex:(NSInteger)index;
- (void)loadItems;
- (void)loadAccount;
- (void)addXMPPClientDelgate;
- (void)removeXMPPClientDelgate;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation RosterItemViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize rosterMode;
@synthesize selectedMode;
@synthesize modes;
@synthesize sendMessageButton;
@synthesize items;
@synthesize account;
@synthesize rosterItem;

//===================================================================================================================================
#pragma mark RosterItemViewController

//===================================================================================================================================
#pragma mark RosterItemViewController PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UITableViewCell*)tableView:(UITableView*)tableView cellForResource:(RosterItemModel*)resource {
    RosterCell* cell = (RosterCell*)[CellUtils createCell:[RosterCell class] forTableView:tableView];
    cell.jidLabel.text = resource.resource;
    cell.activeImage.image = [RosterCell rosterItemImage:resource];
    return cell;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UITableViewCell*)tableView:(UITableView*)tableView cellForContactPub:(ServiceItemModel*)item {
    ContactPubCell* cell = (ContactPubCell*)[CellUtils createCell:[ContactPubCell class] forTableView:tableView];
    cell.itemLabel.text = item.itemName;
    return cell;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)sendMessageButtonWasPressed:(id)sender {
	UIViewController* viewController = [self getMessageViewControllerForAccount]; 
	[self.navigationController pushViewController:viewController animated:YES]; 
}	

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)createAddItemButton {
    if ([self.selectedMode isEqualToString:@"Chat"] && [RosterItemModel isJidAvailable:[self.rosterItem bareJID]]) { 
        self.navigationItem.rightBarButtonItem = self.sendMessageButton;
    } else if ([self.selectedMode isEqualToString:@"Commands"] && [RosterItemModel isJidAvailable:[self.rosterItem bareJID]]) {
        self.navigationItem.rightBarButtonItem = self.sendMessageButton;
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)createSegementedController {
    CGRect rect = CGRectMake(0.0f, 0.0f, 120.0f, 30.0f);
    SegmentedCycleList* segmentControl = [[SegmentedCycleList alloc] init:self.modes withValueAtIndex:[self selectedIndexFromMode] rect:rect andColor:[UIColor whiteColor]];
    segmentControl.tintColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0];
    segmentControl.delegate = self;
    self.navigationItem.titleView = segmentControl;
    [segmentControl release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (UIViewController*)getMessageViewControllerForAccount {
    [self.rosterItem load];
    if ([self.selectedMode isEqualToString:@"Chat"]) {
        MessageViewController* viewController = [[MessageViewController alloc] initWithNibName:@"MessageViewController" bundle:nil];
        viewController.rosterItem = self.rosterItem;
        return [viewController autorelease];
    } else if ([self.selectedMode isEqualToString:@"Commands"]) {
        CommandViewController* viewController = [[CommandViewController alloc] initWithNibName:@"CommandViewController" bundle:nil];
        viewController.rosterItem =  self.rosterItem;
        return [viewController autorelease];
    } 
    return nil;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)labelBackButton {
    UIBarButtonItem* temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    if ([self.selectedMode isEqualToString:@"Chat"]) {
        temporaryBarButtonItem.title = @"Chat";
    } else if ([self.selectedMode isEqualToString:@"Commands"]) {
        temporaryBarButtonItem.title = @"Commands";
    } else if ([self.selectedMode isEqualToString:@"Publications"]) {
        temporaryBarButtonItem.title = @"Publications";
    } else if ([self.selectedMode isEqualToString:@"Resources"]) {
        temporaryBarButtonItem.title = @"Resources";
    }
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    [temporaryBarButtonItem release];  
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setModes {
    self.selectedMode = @"Chat";
    if (self.rosterMode == kCONTACTS_MODE) {
        self.modes = [NSMutableArray arrayWithObjects:@"Chat", @"Commands", @"Resources", @"Publications", nil];
    } else {
        self.modes = [NSMutableArray arrayWithObjects:@"Chat", @"Commands", @"Publications", nil];
    } 
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)selectedIndexFromMode {
    return [self.modes indexOfObject:self.selectedMode];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)selectedModeFromIndex:(NSInteger)index {
    self.selectedMode = [self.modes objectAtIndex:index];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)loadItems {
    if ([self.selectedMode isEqualToString:@"Chat"]) {
        self.items = [MessageModel findAllByJid:[self.rosterItem fullJID] account:self.account andTextType:MessageTextTypeBody withLimit:kMESSAGE_CACHE_SIZE];
    } else if ([self.selectedMode isEqualToString:@"Commands"]) {
        self.items = [MessageModel findAllCommandsByJid:[self.rosterItem fullJID] andAccount:self.account withLimit:kMESSAGE_CACHE_SIZE];
    } else if ([self.selectedMode isEqualToString:@"Publications"]) {
        self.items = [ServiceItemModel findAllByParentNode:[[self.rosterItem toJID] pubSubRoot]];
    } else if ([self.selectedMode isEqualToString:@"Resources"]) {
        self.items = [RosterItemModel findAllByJid:[self.rosterItem fullJID] andAccount:self.account];
    }
    [self.tableView reloadData];
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
    if ([self.selectedMode isEqualToString:@"Chat"]) {
        [self.rosterItem load];
        [self createAddItemButton];
        [self.tableView reloadData];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient *)sender didReceiveMessage:(XMPPMessage *)message {
    if ([self.selectedMode isEqualToString:@"Chat"]) {
        [self loadItems];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)sender didReceiveCommandError:(XMPPIQ*)iq {
    if ([self.selectedMode isEqualToString:@"Commands"]) {
        [self loadItems];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)sender didReceiveCommandResult:(XMPPIQ*)iq {
    if ([self.selectedMode isEqualToString:@"Commands"]) {
        [self loadItems];
    }
}

//===================================================================================================================================
#pragma mark SegmentedCycleList Delegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)selectedItemChanged:(SegmentedCycleList*)sender {
    [self selectedModeFromIndex:sender.selectedItemIndex];
    [self createAddItemButton];
    [self labelBackButton];
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
    [self setModes];
    [self createAddItemButton];
    [self labelBackButton];
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
    if ([self.selectedMode isEqualToString:@"Chat"]) {
        cellHeight = [MessageCellFactory tableView:tableView heightForRowWithMessage:[self.items objectAtIndex:indexPath.row]];
    } else if ([self.selectedMode isEqualToString:@"Commands"]) {
        cellHeight = [MessageCellFactory tableView:tableView heightForRowWithMessage:[self.items objectAtIndex:indexPath.row]];
    } else if ([self.selectedMode isEqualToString:@"Publications"]) {
        cellHeight = kPUB_CELL_HEIGHT;
    } else if ([self.selectedMode isEqualToString:@"Resources"]) {
        cellHeight = kROSTER_CELL_HEIGHT;
    }
    return cellHeight;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* rosterHeaderView = nil;
    SectionViewController* rosterHeader = 
        [[SectionViewController alloc] initWithNibName:@"SectionViewController" bundle:nil andLable:[self.rosterItem fullJID]]; 
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
    return [self.items count];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {   
    UITableViewCell* cell;
    if ([self.selectedMode isEqualToString:@"Chat"]) {
        cell = [MessageCellFactory tableView:tableView cellForRowAtIndexPath:indexPath forMessage:[self.items objectAtIndex:indexPath.row]];
    } else if ([self.selectedMode isEqualToString:@"Commands"]) {
        cell = [MessageCellFactory tableView:tableView cellForRowAtIndexPath:indexPath forMessage:[self.items objectAtIndex:indexPath.row]];
    } else if ([self.selectedMode isEqualToString:@"Publications"]) {
        cell = [RosterItemViewController tableView:tableView cellForContactPub:[self.items objectAtIndex:indexPath.row]];
    } else if ([self.selectedMode isEqualToString:@"Resources"]) {
        cell = [RosterItemViewController tableView:tableView cellForResource:[self.items objectAtIndex:indexPath.row]];
    }
    return cell;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    if ([self.selectedMode isEqualToString:@"Resources"]) {
        UserModel* user = [self.items objectAtIndex:indexPath.row];
        RosterItemViewController* chatViewController = [[RosterItemViewController alloc] initWithNibName:@"RosterItemViewController" bundle:nil andTitle:[user resource]];
        [chatViewController setAccount:self.account];
        chatViewController.rosterItem = user;
        [self.navigationController pushViewController:chatViewController animated:YES];
        [chatViewController release];
    }  else if ([self.selectedMode isEqualToString:@"Publications"]) {
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

