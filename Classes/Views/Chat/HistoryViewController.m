//
//  HistoryViewController.m
//  webgnosus_client
//
//  Created by Troy Stribling on 1/11/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "HistoryViewController.h"
#import "MessageModel.h"
#import "AccountModel.h"
#import "MessageCellFactory.h"

#import "XMPPClientManager.h"
#import "XMPPClient.h"
#import "XMPPMessage.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface HistoryViewController (PrivateAPI)

- (void)loadMessages;
- (void)addXMPPClientDelgate;
- (void)removeXMPPClientDelgate;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation HistoryViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize messages;
@synthesize accounts;

//===================================================================================================================================
#pragma mark HistoryViewController

//===================================================================================================================================
#pragma mark HistoryViewController PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)loadMessages {
	self.messages = [MessageModel findAllWithLimit:kMESSAGE_CACHE_SIZE];
    [self.tableView reloadData];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addXMPPClientDelgate {
	NSEnumerator *accountsEnumerator = [self.accounts objectEnumerator]; 
	AccountModel* account = nil; 
	while ((account = [accountsEnumerator nextObject]) != nil) { 
        [[XMPPClientManager instance] xmppClientForAccount:account andDelegateTo:self];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)removeXMPPClientDelgate {
	NSEnumerator *accountsEnumerator = [self.accounts objectEnumerator]; 
	AccountModel* account = nil; 
	while ((account = [accountsEnumerator nextObject]) != nil) { 
        [[XMPPClientManager instance] removeXMPPClientDelegate:self forAccount:account];
    }
}

//===================================================================================================================================
#pragma mark XMPPClientDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient *)sender didReceiveMessage:(XMPPMessage *)message {
    if ([message hasBody]) {
        [self loadMessages];
    }
}

//===================================================================================================================================
#pragma mark UIViewController

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad {    
    [super viewDidLoad];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated {
    self.accounts = [AccountModel findAllActivated];
    [self addXMPPClientDelgate];
    [self loadMessages];
	[super viewWillAppear:animated];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillDisappear:(BOOL)animated {
    [self removeXMPPClientDelgate];
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
    return [MessageCellFactory tableView:tableView heightForRowWithMessage:[self.messages objectAtIndex:indexPath.row]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [MessageModel countWithLimit:kMESSAGE_CACHE_SIZE];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {        
    return [MessageCellFactory tableView:tableView cellForRowAtIndexPath:indexPath forMessage:[self.messages objectAtIndex:indexPath.row]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end

