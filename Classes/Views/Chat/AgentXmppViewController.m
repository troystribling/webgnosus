//
//  AgentXmppViewController.m
//  webgnosus
//
//  Created by Troy Stribling on 3/23/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "AgentXmppViewController.h"
#import "AgentXmppCommandCell.h"
#import "RosterSectionViewController.h"
#import "MessageModel.h"
#import "UserModel.h"
#import "AccountModel.h"
#import "RosterItemModel.h"

#import "XMPPClientManager.h"
#import "XMPPClient.h"
#import "XMPPJID.h"
#import "XMPPCommand.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface AgentXmppViewController (PrivateAPI)

- (NSInteger)sectionCount:(NSInteger)section;
- (NSMutableArray*)sectionCommands:(NSInteger)section;
- (NSDictionary*)commandAtIndexPath:(NSIndexPath*)indexPath;
- (NSString*)sectionLable:(NSInteger)section;
- (void)handleCommand:(NSIndexPath*)indexPath;
- (void)sendDeviceCommand:(NSIndexPath*)indexPath toJID:(XMPPJID*)toJID;
- (void)saveMessage:(NSString*)msg;

@end


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation AgentXmppViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize account;
@synthesize partner;

//===================================================================================================================================
#pragma mark AgentXmppViewController

//===================================================================================================================================
#pragma mark AgentXmppViewController PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)sectionCount:(NSInteger)section {
    NSInteger count = [[self sectionCommands:section] count];
    return count;
}
     
//-----------------------------------------------------------------------------------------------------------------------------------
- (NSMutableArray*)sectionCommands:(NSInteger)section {
    return nil;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSDictionary*)commandAtIndexPath:(NSIndexPath*)indexPath {
    return [[self sectionCommands:indexPath.section] objectAtIndex:indexPath.row];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)sectionLable:(NSInteger)section {
    NSString* sectionLable;
    if (section == 0) {
        sectionLable = @"Current Status"; 
    } else if (section == 1) {
        sectionLable = @"CPU Performance History"; 
    } else if (section == 2) {
        sectionLable = @"Memory Performance History"; 
    } else if (section == 3) {
        sectionLable = @"Storage Performance History"; 
    } else if (section == 4) {
        sectionLable = @"Network Performance History"; 
    }
    return sectionLable;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleCommand:(NSIndexPath*)indexPath {
    XMPPJID* partnerJID = [XMPPJID jidWithString:[self.partner fullJID]];
    if ([[partnerJID bare] isEqualToString:[partnerJID full]]) {
        NSMutableArray* resourceList = [RosterItemModel findAllByJid:[partnerJID bare] andAccount:self.account];
        for(int i = 0; i < [resourceList count]; i++) {
            RosterItemModel* resourceModel =[resourceList objectAtIndex:i];
            if ([resourceModel isAvailable]) {
                [self sendDeviceCommand:indexPath toJID:[XMPPJID jidWithString:[resourceModel fullJID]]];
            }
        }
    } else {
        [self sendDeviceCommand:indexPath toJID:partnerJID];
    }
    [self saveMessage:[[self commandAtIndexPath:indexPath] objectForKey:@"description"]];
    [self.navigationController popViewControllerAnimated:YES];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)sendDeviceCommand:(NSIndexPath*)indexPath toJID:(XMPPJID*)toJID {
    NSDictionary* commandInfo = [self commandAtIndexPath:indexPath];
    XMPPClient* xmppClient = [[XMPPClientManager instance] xmppClientForAccount:self.account];
    [XMPPCommand set:xmppClient commandNode:[commandInfo objectForKey:@"method"] JID:toJID];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)saveMessage:(NSString*)msg {
    MessageModel* model = [[MessageModel alloc] init];
    model.messageText = msg;
    model.accountPk = self.account.pk;
    model.toJid = [self.partner fullJID];
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
        [[RosterSectionViewController alloc] initWithNibName:@"RosterSectionViewController" bundle:nil andLable:[self sectionLable:section]]; 
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
    return 5;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self sectionCount:section];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {  
    NSDictionary* commandInfo = [self commandAtIndexPath:indexPath];
    return [AgentXmppCommandCell tableView:tableView cellWithText:[commandInfo objectForKey:@"description"]];
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

