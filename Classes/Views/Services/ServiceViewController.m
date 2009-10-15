//
//  ServiceViewController.m
//  webgnosus
//
//  Created by Troy Stribling on 10/11/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "ServiceViewController.h"
#import "ServiceCell.h"
#import "ServiceSearchViewController.h"
#import "AccountManagerViewController.h"
#import "AlertViewManager.h"
#import "MessageCellFactory.h"
#import "CellUtils.h"
#import "SectionViewController.h"
#import "XMPPClientManager.h"
#import "XMPPClient.h"
#import "XMPPJID.h"
#import "XMPPMessage.h"
#import "XMPPDiscoItemsQuery.h"
#import "XMPPDiscoInfoQuery.h"
#import "XMPPDiscoItemsServiceResponseDelegate.h"
#import "XMPPDiscoInfoServiceResponseDelegate.h"
#import "AccountModel.h"
#import "ServiceItemModel.h"
#import "ServiceFeatureModel.h"


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ServiceViewController (PrivateAPI)

- (void)failureAlert;
- (void)changeServiceButtonWasPressed; 
- (void)editAccountButtonWasPressed;
- (void)initParentNode;
- (void)initRootServiceViewController;
- (void)discoInfo;
- (void)loadNextViewController;
- (void)loadServiceItems;
- (void)loadAccount;
- (void)reloadServiceItems;
- (void)addXMPPClientDelgate;
- (void)removeXMPPClientDelgate;
- (void)addXMPPAccountUpdateDelgate;
- (void)removeXMPPAccountUpdateDelgate;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ServiceViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize editAccountsButton;
@synthesize searchServiceButton;
@synthesize rootServiceViewController;
@synthesize serviceItems;
@synthesize node;
@synthesize service;
@synthesize account;
@synthesize selectedItem;

//===================================================================================================================================
#pragma mark ServiceViewController

//===================================================================================================================================
#pragma mark ServiceViewController PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)failureAlert { 
    [AlertViewManager showAlert:@"Disco Error"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)serachServiceButtonWasPressed { 
    if (self.account) {
        ServiceSearchViewController* searchController = [[ServiceSearchViewController alloc] initWithNibName:@"ServiceSearchViewController" bundle:nil]; 
        searchController.rootServiceController = self.rootServiceViewController;
        [self.navigationController pushViewController:searchController animated:YES]; 
        [searchController release];     
    }
}	

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)initParentNode {
    if (!self.service) {
        self.service = [[self.account toJID] domain];
        self.node = nil;
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)initRootServiceViewController {
    if (!self.rootServiceViewController) {
        self.rootServiceViewController = self;
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)discoInfo {
    XMPPClient* client = [[XMPPClientManager instance] xmppClientForAccount:self.account andDelegateTo:self];
    for (int i = 0; i < [self.serviceItems count]; i++) {
        ServiceItemModel* item = [self.serviceItems objectAtIndex:i]; 
        NSInteger count = [ServiceFeatureModel countByService:item.jid andParentNode:item.node];
        if (count == 0) {
            [XMPPDiscoInfoQuery get:client JID:[XMPPJID jidWithString:item.jid] node:item.node andDelegateResponse:[[XMPPDiscoInfoServiceResponseDelegate alloc] init]];
        }
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)editAccountButtonWasPressed { 
    [AccountManagerViewController inView:self.view.window];
}	

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)loadNextViewController {
    ServiceViewController* viewController = [[ServiceViewController alloc] initWithNibName:@"ServiceViewController" bundle:nil];
    viewController.service = self.selectedItem.jid;
    viewController.node = self.selectedItem.node;
    viewController.rootServiceViewController = self.rootServiceViewController;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}
    
//-----------------------------------------------------------------------------------------------------------------------------------
- (void)loadServiceItems {
    self.serviceItems = [ServiceItemModel findAllByService:self.service andParentNode:self.node];
    [self.tableView reloadData];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)loadAccount {
    self.account = [AccountModel findFirstDisplayed];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)reloadServiceItems {
    [self loadAccount];
    [self removeXMPPClientDelgate];
    [self addXMPPClientDelgate];
    [self loadServiceItems];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addXMPPClientDelgate {
    if (self.account) {
        [[XMPPClientManager instance] xmppClientForAccount:self.account andDelegateTo:self];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)removeXMPPClientDelgate {
    if (self.account) {
        [[XMPPClientManager instance] removeXMPPClientDelegate:self forAccount:self.account];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addXMPPAccountUpdateDelgate {
    [[XMPPClientManager instance] addAccountUpdateDelegate:self];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)removeXMPPAccountUpdateDelgate {
    [[XMPPClientManager instance] removeAccountUpdateDelegate:self];
}

//===================================================================================================================================
#pragma mark XMPPClientManagerAccountUpdateDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)didAddAccount {
    [self reloadServiceItems];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)didRemoveAccount {
    [self reloadServiceItems];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)didUpdateAccount {
    [self reloadServiceItems];
}

//===================================================================================================================================
#pragma mark XMPPClientDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceiveDiscoItemsServiceResult:(XMPPIQ*)iq {
    [AlertViewManager dismissActivityIndicator];
    [self loadNextViewController];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceiveDiscoItemsServiceError:(XMPPIQ*)iq {
    [AlertViewManager dismissActivityIndicator];
    [self failureAlert];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceiveDiscoInfoServiceResult:(XMPPIQ*)iq {
//    [self loadServiceItems];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceiveDiscoInfoServiceError:(XMPPIQ*)iq {
}

//===================================================================================================================================
#pragma mark UIViewController

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithCoder:(NSCoder *)coder { 
	if (self = [super initWithCoder:coder]) { 
        self.editAccountsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(editAccountButtonWasPressed)];
        self.navigationItem.leftBarButtonItem = self.editAccountsButton;
	} 
	return self; 
} 

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad {    
    self.searchServiceButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(serachServiceButtonWasPressed)];
    self.navigationItem.rightBarButtonItem = self.searchServiceButton;
	self.title = @"Services";
    UIBarButtonItem* temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"Back";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    [temporaryBarButtonItem release];      
    [super viewDidLoad];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated {
    [self loadAccount];
    [self initParentNode];
    [self initRootServiceViewController];
    [self addXMPPClientDelgate];
    [self addXMPPAccountUpdateDelgate];
    [self loadServiceItems];
    [self discoInfo];
	[super viewWillAppear:animated];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillDisappear:(BOOL)animated {
    [self removeXMPPClientDelgate];
    [self removeXMPPAccountUpdateDelgate];
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
    UIView* sectionView = nil;
    if (self.account) {
        NSString* parentNode;
        if (self.node) {
            parentNode = [NSString stringWithFormat:@"%@%@", self.service, self.node];
        } else {
            parentNode = self.service; 
        }
        sectionView = [SectionViewController viewWithLabel:parentNode]; 
    }
    return sectionView; 
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    return kCELL_SECTION_TITLE_HEIGHT;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    return kSERVICE_CELL_HEIGHT;
}

//===================================================================================================================================
#pragma mark UITableViewDataSource

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.serviceItems count];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {        
    ServiceCell* cell = (ServiceCell*)[CellUtils createCell:[ServiceCell class] forTableView:tableView];
    ServiceItemModel* item = [self.serviceItems objectAtIndex:indexPath.row];
    NSString* name;
    if (item.itemName) {
        name = item.itemName;
    } else if (item.node) {
        name = item.node;
    } else {
        name = item.jid;
    }
    cell.itemLabel.text = name;
    return cell;        
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ServiceItemModel* item = [self.serviceItems objectAtIndex:indexPath.row];
    NSInteger count = [ServiceItemModel countByService:item.jid andParentNode:item.node];
    self.selectedItem = item;
    if (count == 0) {
        [self removeXMPPClientDelgate];
        [self removeXMPPAccountUpdateDelgate];
        XMPPClient* client = [[XMPPClientManager instance] xmppClientForAccount:self.account andDelegateTo:self];
        [XMPPDiscoItemsQuery get:client JID:[XMPPJID jidWithString:item.jid] node:item.node andDelegateResponse:[[XMPPDiscoItemsServiceResponseDelegate alloc] init]];
        [AlertViewManager showActivityIndicatorInView:self.view.window withTitle:@"Service Disco"];
    } else {
        [self loadNextViewController];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end

