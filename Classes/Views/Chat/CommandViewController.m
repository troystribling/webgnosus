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

#import "XMPPClientManager.h"
#import "XMPPClient.h"
#import "XMPPJID.h"
#import "XMPPCommand.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface CommandViewController (PrivateAPI)

- (void)loadCommands;
- (void)handleCommand:(NSIndexPath*)indexPath;
- (void)sendDeviceCommand:(ServiceItemModel*)commandInfo toJID:(XMPPJID*)toJID;
- (void)saveMessage:(NSString*)msg;

@end


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation CommandViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize account;
@synthesize rosterItem;
@synthesize commands;

//===================================================================================================================================
#pragma mark CommandViewController

//===================================================================================================================================
#pragma mark CommandViewController PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)loadAccount {
    self.account = [AccountModel findFirstDisplayed];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)loadCommands {
    self.commands = [ServiceItemModel findAllByParentNode:@"http://jabber.org/protocol/commands" andService:[self.account fullJID]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleCommand:(NSIndexPath*)indexPath {
    ServiceItemModel* commandInfo = [self.commands objectAtIndex:indexPath.row];
    XMPPJID* toJID = [self.rosterItem toJID];
    if ([[self.rosterItem bareJID] isEqualToString:[toJID full]]) {
        NSMutableArray* resourceList = [RosterItemModel findAllByJid:[self.rosterItem bareJID] andAccount:self.account];
        for(int i = 0; i < [resourceList count]; i++) {
            RosterItemModel* resourceModel =[resourceList objectAtIndex:i];
            if ([resourceModel isAvailable]) {
                [self sendDeviceCommand:commandInfo toJID:[XMPPJID jidWithString:[resourceModel fullJID]]];
            }
        }
    } else {
        [self sendDeviceCommand:commandInfo toJID:toJID];
    }
    [self saveMessage:commandInfo.itemName];
    [self.navigationController popViewControllerAnimated:YES];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)sendDeviceCommand:(ServiceItemModel*)commandInfo toJID:(XMPPJID*)toJID {
    XMPPClient* xmppClient = [[XMPPClientManager instance] xmppClientForAccount:self.account];
    [XMPPCommand set:xmppClient commandNode:commandInfo.node JID:toJID];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)saveMessage:(NSString*)msg {
    MessageModel* model = [[MessageModel alloc] init];
    model.messageText = msg;
    model.accountPk = self.account.pk;
    model.toJid = [self.rosterItem fullJID];
    model.fromJid = [self.account fullJID];
    model.createdAt = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    [model insert];
    [model release];
}

//===================================================================================================================================
#pragma mark UIViewController

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithNibName:(NSString*)nibName bundle:(NSBundle*)nibBundle { 
	if (self = [super initWithNibName:nibName bundle:nibBundle]) { 
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

