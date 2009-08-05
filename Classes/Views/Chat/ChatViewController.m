//
//  ChatViewController.m
//  webgnosus
//fullJID
//  Created by Troy Stribling on 2/28/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "ChatViewController.h"
#import "MessageViewController.h"
#import "MessageModel.h"
#import "UserModel.h"
#import "MessageCellFactory.h"
#import "AgentXmppViewController.h"
#import "AccountModel.h"

#import "XMPPClientManager.h"
#import "XMPPClient.h"
#import "XMPPMessage.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ChatViewController (PrivateAPI)

- (void)loadItems;
- (UIViewController*)getMessageViewControllerForAccount;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ChatViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize sendMessageButton;
@synthesize items;
@synthesize account;
@synthesize partner;

//===================================================================================================================================
#pragma mark ChatViewController

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)sendMessageButtonWasPressed:(id)sender {
	UIViewController* viewController = [self getMessageViewControllerForAccount]; 
	[self.navigationController pushViewController:viewController animated:YES]; 
	[viewController release]; 
}	

//===================================================================================================================================
#pragma mark ChatViewController PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (UIViewController*)getMessageViewControllerForAccount {
    [self.partner load];
    UIViewController* viewController;
    if ([self.partner.clientName isEqualToString:@"AgentXMPP"]) {
        viewController = [[AgentXmppViewController alloc] initWithNibName:@"AgentXmppViewController" bundle:nil];
    } else {
        viewController = [[MessageViewController alloc] initWithNibName:@"MessageViewController" bundle:nil];
    }
    [viewController setAccount:self.account];
    [viewController setPartner:self.partner];
    return viewController;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)loadItems {
	self.items = [MessageModel findAllByJid:[self.partner fullJID] andAccount:self.account withLimit:kMESSAGE_CACHE_SIZE];
    [self.tableView reloadData];
}

//===================================================================================================================================
#pragma mark XMPPClientDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient *)sender didReceiveMessage:(XMPPMessage *)message {
    if ([message hasBody]) {
        [self loadItems];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)sender didReceiveCommandResult:(XMPPIQ*)iq {
    [self loadItems];
}

//===================================================================================================================================
#pragma mark UIViewController

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithNibName:(NSString*)nibName bundle:(NSBundle*)nibBundle { 
	if (self = [super initWithNibName:nibName bundle:nibBundle]) { 
        self.sendMessageButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self 
                                   action:@selector(sendMessageButtonWasPressed:)];
        self.title = [self.partner fullJID];
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
    self.navigationItem.rightBarButtonItem = self.sendMessageButton;
    [super viewDidLoad];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated {
    [[XMPPClientManager instance] xmppClientForAccount:self.account andDelegateTo:self];
    [self loadItems];
	[super viewWillAppear:animated];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillDisappear:(BOOL)animated {
    [[XMPPClientManager instance] removeXMPPClientDelegate:self forAccount:self.account];
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
    return [MessageCellFactory tableView:tableView heightForRowWithMessage:[self.items objectAtIndex:indexPath.row]];
}

//===================================================================================================================================
#pragma mark UITableViewDataSource

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [MessageModel countByJid:[self.partner fullJID] andAccount:self.account withLimit:kMESSAGE_CACHE_SIZE];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {        
    return [MessageCellFactory tableView:tableView cellForRowAtIndexPath:indexPath forMessage:[self.items objectAtIndex:indexPath.row]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
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

