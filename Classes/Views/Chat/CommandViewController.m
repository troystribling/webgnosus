//
//  CommandViewController.m
//  webgnosus
//
//  Created by Troy Stribling on 3/23/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "CommandViewController.h"
#import "SectionViewController.h"
#import "CommandFormViewController.h"
#import "CommandCell.h"
#import "MessageModel.h"
#import "UserModel.h"
#import "AccountModel.h"
#import "ServiceItemModel.h"
#import "RosterItemModel.h"
#import "CellUtils.h"
#import "AlertViewManager.h"
#import "XMPPClientManager.h"
#import "XMPPClient.h"
#import "XMPPJID.h"
#import "XMPPDiscoItemsQuery.h"
#import "XMPPCommand.h"
#import "XMPPError.h"
#import "XMPPIQ.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface CommandViewController (PrivateAPI)

- (void)loadAccount;
- (void)loadCommands;
- (void)handleCommand:(NSIndexPath*)indexPath;
- (void)saveMessage:(NSString*)msg;
- (NSString*)commandRootPath:(NSString*)cmd;
- (NSString*)commandName:(NSString*)cmd;
- (NSArray*)sectionNameArray;
- (ServiceItemModel*)commandInfoForSection:(NSString*)sectionName atRow:(NSInteger)row;

@end


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation CommandViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize account;
@synthesize rosterItem;
@synthesize commands;
@synthesize commandRequest;
@synthesize sectionViewControllers;
@synthesize formDisplayed;

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
    NSArray* commandInfoArray = [ServiceItemModel findAllByService:[self.rosterItem fullJID] andParentNode:@"http://jabber.org/protocol/commands"];
    for (int i=0; i < [commandInfoArray count]; i++) {
        ServiceItemModel* commandInfo = [commandInfoArray objectAtIndex:i];
        NSString* key = [self commandRootPath:commandInfo.itemName];
        NSMutableArray* commandArray = [self.commands valueForKey:key];
        if (commandArray) {
            [commandArray addObject:commandInfo];
        } else {
            commandArray = [NSMutableArray arrayWithObject:commandInfo];
            [self.commands setValue:commandArray forKey:key];
        }
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleCommand:(NSIndexPath*)indexPath {
    NSString* sectionName = [[self sectionNameArray] objectAtIndex:indexPath.section];
    self.commandRequest = [self commandInfoForSection:sectionName atRow:indexPath.row];
    XMPPJID* toJID = [self.rosterItem toJID];
    XMPPClient* client = [[XMPPClientManager instance] xmppClientForAccount:self.account];
    NSMutableArray* serviceItems = [ServiceItemModel findAllByService:[toJID full] parentNode:@"http://jabber.org/protocol/commands" andNode:self.commandRequest.node];
    for(int i = 0; i < [serviceItems count]; i++) {
        ServiceItemModel* serviceItem = [serviceItems objectAtIndex:i];
        RosterItemModel* resourceModel = [RosterItemModel findByFullJid:serviceItem.service andAccount:self.account];
        if ([resourceModel isAvailable]) {
            [XMPPCommand set:client commandNode:self.commandRequest.node JID:[resourceModel toJID]];
            [self saveMessage:self.commandRequest.itemName];
        }
        [AlertViewManager showActivityIndicatorInView:self.view.window withTitle:@"Waiting for Response"];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)saveMessage:(NSString*)msg {
    MessageModel* model = [[MessageModel alloc] init];
    model.messageText = msg;
    model.accountPk = self.account.pk;
    model.toJid = [self.rosterItem fullJID];
    model.fromJid = [self.account fullJID];
    model.createdAt = [NSDate dateWithTimeIntervalSinceNow:0];
    model.textType = MessageTextTypeCommandText;
    model.itemId = @"-1";
    model.messageRead = YES;
    [model insert];
    [model release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)commandName:(NSString*)cmd {
    NSMutableArray* cmdComp = [NSMutableArray arrayWithCapacity:10];
    [cmdComp addObjectsFromArray:[cmd componentsSeparatedByString:@"/"]];
    if ([[cmdComp objectAtIndex:0] isEqualToString:@""] && [cmdComp count] > 2) {
        [cmdComp removeObjectAtIndex:0];
        [cmdComp removeObjectAtIndex:0];
    } else if ([cmdComp count] > 1) {
        [cmdComp removeObjectAtIndex:0];
    }
    return [cmdComp componentsJoinedByString:@"/"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)commandRootPath:(NSString*)cmd {
    NSString* rootPath = [self.rosterItem fullJID];
    NSArray* cmdComp = [cmd componentsSeparatedByString:@"/"];
    if ([[cmdComp objectAtIndex:0] isEqualToString:@""] && [cmdComp count] > 2) {
        rootPath = [cmdComp objectAtIndex:1];
    } else if (![[cmdComp objectAtIndex:0] isEqualToString:@""] && [cmdComp count] > 1) {
        rootPath = [cmdComp objectAtIndex:0];
    }
    return rootPath;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSArray*)sectionNameArray {
    return [[self.commands allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (ServiceItemModel*)commandInfoForSection:(NSString*)sectionName atRow:(NSInteger)row {
    return [[self.commands valueForKey:sectionName] objectAtIndex:row];
}

//===================================================================================================================================
#pragma mark XMPPClientDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)sender didReceiveCommandError:(XMPPIQ*)iq {
    if (!self.formDisplayed) {
        [AlertViewManager dismissActivityIndicator];
        XMPPError* error = [iq error];
        NSString* msg = @"";
        if (error) {
            msg = [error text];
        } 
        [AlertViewManager showAlert:@"Command Error" withMessage:msg];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)sender didReceiveCommandResult:(XMPPIQ*)iq {
    [AlertViewManager dismissActivityIndicator];
    [self.navigationController popViewControllerAnimated:YES];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)sender didReceiveCommandForm:(XMPPIQ*)iq {
    self.formDisplayed = YES;
    [AlertViewManager dismissActivityIndicator];
    [CommandFormViewController form:iq inView:self.view.window forAccount:self.account];
}

//===================================================================================================================================
#pragma mark UIViewController

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithNibName:(NSString*)nibName bundle:(NSBundle*)nibBundle { 
	if (self = [super initWithNibName:nibName bundle:nibBundle]) { 
        self.navigationItem.title = @"Select Command";
        self.formDisplayed = NO;
        self.commands = [NSMutableDictionary dictionaryWithCapacity:100];
        self.sectionViewControllers = [NSMutableArray arrayWithCapacity:10];
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
    [[XMPPClientManager instance] delegateTo:self forAccount:self.account];
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
     SectionViewController* sectionVewController = [SectionViewController viewControllerWithLabel:[[self sectionNameArray] objectAtIndex:section]];
     [self.sectionViewControllers addObject:sectionVewController];
     return sectionVewController.view; 
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
    return [[self.commands allKeys] count];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray* commandInfoArray = [self.commands valueForKey:[[self sectionNameArray] objectAtIndex:section]];    
    NSInteger count = [commandInfoArray count];
    return count;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {  
    NSString* sectionName = [[self sectionNameArray] objectAtIndex:indexPath.section];
    ServiceItemModel* commandInfo = [self commandInfoForSection:sectionName atRow:indexPath.row];
    CommandCell* cell = (CommandCell*)[CellUtils createCell:[CommandCell class] forTableView:tableView];
    cell.commandLabel.text = [self commandName:commandInfo.itemName];
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
    [account release];
    [rosterItem release];
    [commands release];
    [commandRequest release];
    [sectionViewControllers release];
    [super dealloc];
}

@end

