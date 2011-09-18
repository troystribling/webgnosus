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
#import "EventsViewController.h"
#import "MessageModel.h"
#import "UserModel.h"
#import "RosterItemModel.h"
#import "ServiceItemModel.h"
#import "SubscriptionModel.h"
#import "AccountModel.h"
#import "ServiceModel.h"
#import "ChatMessageCache.h"
#import "CommandResponseMessageCache.h"
#import "MessageCellFactory.h"
#import "RosterCell.h"
#import "ContactPubCell.h"
#import "XMPPClientManager.h"
#import "XMPPDiscoItemsQuery.h"
#import "XMPPDiscoInfoQuery.h"
#import "XMPPClient.h"
#import "XMPPMessage.h"
#import "XMPPJID.h"
#import "CellUtils.h"
#import "SegmentedCycleList.h"
#import "AlertViewManager.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface RosterItemViewController (PrivateAPI)

- (UITableViewCell*)tableView:(UITableView*)tableView cellForResource:(RosterItemModel*)resource;
- (UITableViewCell*)tableView:(UITableView*)tableView cellForContactPub:(ServiceItemModel*)item;
- (void)resourceViewControllerForRowAtIndexPath:(NSIndexPath*)indexPath;
- (UIViewController*)eventViewControllerForRowAtIndexPath:(NSIndexPath*)indexPath;
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
@synthesize pendingRequests;
@synthesize modes;
@synthesize sendMessageButton;
@synthesize items;
@synthesize account;
@synthesize rosterItem;
@synthesize rosterHeader;

//===================================================================================================================================
#pragma mark RosterItemViewController

//===================================================================================================================================
#pragma mark RosterItemViewController PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell*)tableView:(UITableView*)tableView cellForResource:(RosterItemModel*)resource {
    RosterCell* cell = (RosterCell*)[CellUtils createCell:[RosterCell class] forTableView:tableView];
    cell.resourceLabel.text = resource.resource;
    cell.activeImage.image = [RosterCell rosterItemImage:resource];
    return cell;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell*)tableView:(UITableView*)tableView cellForContactPub:(ServiceItemModel*)item {
    ContactPubCell* cell = (ContactPubCell*)[CellUtils createCell:[ContactPubCell class] forTableView:tableView];
    cell.itemLabel.text = item.itemName;
    cell.serviceItem = item;
    cell.account = self.account;
    return cell;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)resourceViewControllerForRowAtIndexPath:(NSIndexPath*)indexPath {
    UserModel* user = [self.items objectAtIndex:indexPath.row];
    RosterItemViewController* chatViewController = [[RosterItemViewController alloc] initWithNibName:@"RosterItemViewController" bundle:nil andTitle:[user resource]];
    [chatViewController setAccount:self.account];
    chatViewController.rosterItem = user;
    [self.navigationController pushViewController:chatViewController animated:YES];
    [chatViewController release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (UIViewController*)eventViewControllerForRowAtIndexPath:(NSIndexPath*)indexPath {
    EventsViewController* viewController = nil;
    ServiceItemModel* item = [self.items objectAtIndex:indexPath.row];
    if ([[SubscriptionModel findAllByAccount:self.account andNode:item.node] count] > 0) {
        viewController = [[[EventsViewController alloc] initWithNibName:@"EventsViewController" bundle:nil] autorelease];
        viewController.service = item.service;
        viewController.node = item.node;
        viewController.name = item.itemName;
        viewController.eventType = kPUB_MODE;
    }
    return viewController;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)sendMessageButtonWasPressed:(id)sender {
	UIViewController* viewController = [self getMessageViewControllerForAccount]; 
	[self.navigationController pushViewController:viewController animated:YES]; 
}	

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)createAddItemButton {
    if ([self.selectedMode isEqualToString:@"Chat"] || [self.selectedMode isEqualToString:@"Commands"]) { 
        self.navigationItem.rightBarButtonItem = self.sendMessageButton;
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)createSegementedController {
    CGRect rect = CGRectMake(0.0f, 0.0f, 120.0f, 30.0f);
    SegmentedCycleList* segmentControl = [[SegmentedCycleList alloc] init:self.modes withValueAtIndex:[self selectedIndexFromMode] andRect:rect];
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
        if ([RosterItemModel isJidAvailable:[self.rosterItem bareJID]]) {
            self.modes = [NSMutableArray arrayWithObjects:@"Chat", @"Commands", @"Resources", @"Publications", nil];
        } else {
            self.modes = [NSMutableArray arrayWithObjects:@"Chat", @"Publications", nil];
        }
    } else {
        self.modes = [NSMutableArray arrayWithObjects:@"Chat", @"Commands", nil];
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
        self.items = [[[ChatMessageCache alloc] initWithJid:[self.rosterItem fullJID] andAccount:self.account] autorelease];
    } else if ([self.selectedMode isEqualToString:@"Commands"]) {
        self.items = [[[CommandResponseMessageCache alloc] initWithJid:[self.rosterItem fullJID] andAccount:self.account] autorelease];
    } else if ([self.selectedMode isEqualToString:@"Publications"]) {
        XMPPJID* itemJID = [self.rosterItem toJID];
        self.items = [ServiceItemModel findAllByParentNode:[itemJID pubSubRoot]];
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
    [[XMPPClientManager instance] delegateTo:self forAccount:self.account];
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

//----------------------------------------------------------------------------------------------------------------------------------
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

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didDiscoverAllUserPubSubNodes:(XMPPJID*)targetJID {
    [AlertViewManager dismissActivityIndicator];
    [self loadItems];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didFailToDiscoverUserPubSubNode:(XMPPIQ*)iq {
    [AlertViewManager dismissActivityIndicator];
    [AlertViewManager showAlert:@"PubSub Disco Error"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceiveDiscoItemsResult:(XMPPIQ*)iq {
    XMPPDiscoItemsQuery* query = (XMPPDiscoItemsQuery*)[iq query];
	NSString* parentNode = [query node];
    NSString* fromJID = [[iq fromJID] full];
    if ([parentNode isEqualToString:@"http://jabber.org/protocol/commands"]) {
        RosterItemModel* item = [RosterItemModel findByFullJid:fromJID andAccount:self.account];
        for (int i = 0; i < [self.pendingRequests count]; i++) {
            RosterItemModel* pendingReq = [self.pendingRequests objectAtIndex:i];
            if ([[pendingReq fullJID] isEqualToString:[item fullJID]]) {
                [self.pendingRequests removeObjectAtIndex:i];
                break;
            }
        }
        if ([self.pendingRequests count] == 0) {
            [AlertViewManager dismissActivityIndicator];
        }
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceiveDiscoItemsError:(XMPPIQ*)iq {
    [AlertViewManager dismissActivityIndicator];
    [AlertViewManager showAlert:@"Disco Error"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceiveDiscoInfoError:(XMPPIQ*)iq {
    [AlertViewManager dismissActivityIndicator];
    [AlertViewManager showAlert:@"Disco Error"];
}

//===================================================================================================================================
#pragma mark XMPPClientManagerMessageCountUpdateDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)messageCountDidChange {
    if ([self.selectedMode isEqualToString:@"Publications"]) {
        [self.tableView reloadData];
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
    XMPPJID* itemJID = [self.rosterItem toJID];
    XMPPClient* client = [[XMPPClientManager instance] xmppClientForAccount:self.account];
    if ([self.selectedMode isEqualToString:@"Publications"]) {
        XMPPJID* serverJID = [XMPPJID jidWithString:[itemJID domain]];
        [ServiceItemModel destroyAllByService:[serverJID full]];
        [AlertViewManager showActivityIndicatorInView:self.view.window withTitle:@"PubSub Disco"];
        [XMPPDiscoItemsQuery get:client JID:serverJID forTarget:itemJID];
        [XMPPDiscoInfoQuery get:client JID:serverJID forTarget:itemJID];
    }  else if ([self.selectedMode isEqualToString:@"Commands"]) {
        [ServiceItemModel destroyAllByService:[itemJID full] andParentNode:@"http://jabber.org/protocol/commands"];
        self.pendingRequests = [RosterItemModel findAllByFullJid:[itemJID full] andAccount: self.account];
        for (int i = 0; i < [self.pendingRequests count]; i++) {
            RosterItemModel* item = [self.pendingRequests objectAtIndex:i];
            [XMPPDiscoItemsQuery get:client JID:[item toJID] andNode:@"http://jabber.org/protocol/commands"];        
        }
        [AlertViewManager showActivityIndicatorInView:self.view.window withTitle:@"Command Disco"];
    }
}

//===================================================================================================================================
#pragma mark UIViewController

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithNibName:(NSString*)nibName bundle:(NSBundle*)nibBundle { 
	if (self = [super initWithNibName:nibName bundle:nibBundle]) { 
        self.sendMessageButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self 
                                   action:@selector(sendMessageButtonWasPressed:)] autorelease];
        self.pendingRequests = [NSMutableArray arrayWithCapacity:10];
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
    CGFloat cellHeight = kROSTER_CELL_HEIGHT;
    if ([self.selectedMode isEqualToString:@"Chat"] || [self.selectedMode isEqualToString:@"Commands"]) {
        cellHeight = [self.items tableView:tableView heightForRowAtIndexPath:indexPath];
    } else if ([self.selectedMode isEqualToString:@"Publications"]) {
        cellHeight = kPUB_CELL_HEIGHT;
    }
    return cellHeight;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    self.rosterHeader = [SectionViewController viewControllerWithLabel:[self.rosterItem fullJID]]; 
	return self.rosterHeader.view; 
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
    UITableViewCell* cell = nil;
    if ([self.selectedMode isEqualToString:@"Chat"] || [self.selectedMode isEqualToString:@"Commands"]) {
        cell = [self.items tableView:tableView cellForRowAtIndexPath:indexPath];
    } else if ([self.selectedMode isEqualToString:@"Publications"]) {
        ServiceItemModel* item = [self.items objectAtIndex:indexPath.row];
        cell = [self tableView:tableView cellForContactPub:item];
    } else if ([self.selectedMode isEqualToString:@"Resources"]) {
        cell = [self tableView:tableView cellForResource:[self.items objectAtIndex:indexPath.row]];
    }
    return cell;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    if ([self.selectedMode isEqualToString:@"Chat"] || [self.selectedMode isEqualToString:@"Commands"]) {
        [self.items tableView:tableView didSelectRowAtIndexPath:indexPath];
    } else if ([self.selectedMode isEqualToString:@"Resources"]) {
        [self resourceViewControllerForRowAtIndexPath:indexPath];
    }
}

//===================================================================================================================================
#pragma mark UITextViewDelegate

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [self.selectedMode release];
    [self.modes release];
    [self.pendingRequests release];
    [self.sendMessageButton release];
    [self.rosterHeader release];
    [self.items release];
    [self.account release];
    [self.rosterItem release];
    [super dealloc];
}

@end

