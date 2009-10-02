//
//  CommandViewController.m
//  webgnosus
//
//  Created by Troy Stribling on 3/23/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "CommandViewController.h"
#import "CommandCell.h"
#import "RosterSectionViewController.h"
#import "MessageModel.h"
#import "UserModel.h"
#import "AccountModel.h"
#import "ServiceItemModel.h"
#import "RosterItemModel.h"
#import "CellUtils.h"
#import "AlertViewManager.h"
#import "ActivityView.h"

#import "XMPPClientManager.h"
#import "XMPPClient.h"
#import "XMPPJID.h"
#import "XMPPCommand.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface CommandViewController (PrivateAPI)

- (void)failureAlert;
- (void)loadAccount;
- (void)loadCommands;
- (void)handleCommand:(NSIndexPath*)indexPath;
- (void)saveMessage:(NSString*)msg;

@end


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation CommandViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize account;
@synthesize rosterItem;
@synthesize commands;
@synthesize commandRequest;
@synthesize commandRequestIndicatorView;

//===================================================================================================================================
#pragma mark CommandViewController

//===================================================================================================================================
#pragma mark CommandViewController PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)failureAlert { 
    [AlertViewManager showAlert:@"Command Request Failed"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)loadAccount {
    self.account = [AccountModel findFirstDisplayed];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)loadCommands {
    self.commands = [ServiceItemModel findAllByParentNode:@"http://jabber.org/protocol/commands" andService:[self.rosterItem fullJID]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleCommand:(NSIndexPath*)indexPath {
    self.commandRequest = [self.commands objectAtIndex:indexPath.row];
    XMPPJID* toJID = [self.rosterItem toJID];
    XMPPClient* client = [[XMPPClientManager instance] xmppClientForAccount:self.account andDelegateTo:self];
    NSMutableArray* serviceItems = [ServiceItemModel findAllByParentNode:@"http://jabber.org/protocol/commands" node:self.commandRequest.node andService:[toJID full]];
    for(int i = 0; i < [serviceItems count]; i++) {
        ServiceItemModel* serviceItem = [serviceItems objectAtIndex:i];
        RosterItemModel* resourceModel = [RosterItemModel findByFullJid:serviceItem.service andAccount:self.account];
        if ([resourceModel isAvailable]) {
            [XMPPCommand set:client commandNode:self.commandRequest.node JID:[resourceModel toJID]];
        }
        self.commandRequestIndicatorView = [[ActivityView alloc] initWithTitle:@"Waiting" inView:self.view.window];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)saveMessage:(NSString*)msg {
    MessageModel* model = [[MessageModel alloc] init];
    model.messageText = msg;
    model.accountPk = self.account.pk;
    model.toJid = [self.rosterItem fullJID];
    model.fromJid = [self.account fullJID];
    model.createdAt = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    model.textType = MessageTextTypeCommand;
    [model insert];
    [model release];
}

//===================================================================================================================================
#pragma mark XMPPClientDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)sender didReceiveCommandError:(XMPPIQ*)iq {
    [self failureAlert];
    [self.commandRequestIndicatorView dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)sender didReceiveCommandResult:(XMPPIQ*)iq {
    [self.commandRequestIndicatorView dismiss];
    [self saveMessage:self.commandRequest.itemName];
    [self.navigationController popViewControllerAnimated:YES];
}

//===================================================================================================================================
#pragma mark UIViewController

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithNibName:(NSString*)nibName bundle:(NSBundle*)nibBundle { 
	if (self = [super initWithNibName:nibName bundle:nibBundle]) { 
        self.navigationItem.title = @"Select Command";
	} 
	return self; 
} 

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated {
    [self loadAccount];
    [self loadCommands];
    [super viewWillAppear:animated];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
 - (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {    
    RosterSectionViewController* rosterHeader = 
        [[RosterSectionViewController alloc] initWithNibName:@"RosterSectionViewController" bundle:nil andLable:[self.rosterItem fullJID]]; 
    return rosterHeader.view; 
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
    return 1;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.commands count];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {  
    ServiceItemModel* commandInfo = [self.commands objectAtIndex:indexPath.row];
    CommandCell* cell = (CommandCell*)[CellUtils createCell:[CommandCell class] forTableView:tableView];
    cell.commandLabel.text = commandInfo.itemName;
    return cell;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self handleCommand:indexPath];
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
