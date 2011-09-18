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
#import "ServiceMessageViewController.h"
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
#import "XMPPPubSub.h"
#import "TouchImageView.h"
#import "AccountModel.h"
#import "ServiceModel.h"
#import "ServiceItemModel.h"
#import "ServiceFeatureModel.h"
#import "SubscriptionModel.h"
#import "MessageModel.h"


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ServiceViewController (PrivateAPI)

- (void)failureAlert;
- (void)changeServiceButtonWasPressed; 
- (void)editAccountButtonWasPressed;
- (void)initParentNode;
- (void)initRootServiceViewController;
- (void)discoInfo;
- (NSString*)serviceName:(ServiceModel*)itemService forItem:(ServiceItemModel*)item;
- (UIImage*)serviceImage:(ServiceModel*)itemService;
- (UIImage*)pubSubNodeImage:(ServiceModel*)itemService;
- (UIImage*)pubSubNodeImage:(ServiceModel*)itemService;
- (BOOL)enableImageTouch:(ServiceModel*)itemService;
- (void)loadNextViewController;
- (void)loadTextViewController:(MessageModel*)message;
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
@synthesize parentService;
@synthesize sectionViewControllers;

//===================================================================================================================================
#pragma mark ServiceViewController

//===================================================================================================================================
#pragma mark ServiceViewController PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setService:(NSString*)initService andNode:(NSString*)initNode {
    self.service = initService;
    self.node = initNode;
    self.parentService = [ServiceModel findByJID:initService andNode:initNode];
}

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
        [self setService:self.service andNode:nil];
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
    XMPPClient* client = [[XMPPClientManager instance] xmppClientForAccount:self.account];
    NSString* serviceType = @"unknown";
    if (self.parentService) {
        serviceType = self.parentService.type;
    }
    if (![serviceType isEqualToString:@"leaf"]) {
        for (int i = 0; i < [self.serviceItems count]; i++) {
            ServiceItemModel* item = [self.serviceItems objectAtIndex:i]; 
            NSInteger count = [ServiceFeatureModel countByService:item.jid andNode:item.node];
            if (count == 0) {
                [XMPPDiscoInfoQuery get:client JID:[XMPPJID jidWithString:item.jid] node:item.node andDelegateResponse:[[XMPPDiscoInfoServiceResponseDelegate alloc] init]];
            }
        }
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)serviceName:(ServiceModel*)itemService forItem:(ServiceItemModel*)item {
    NSString* name;
    if (itemService.name) {
        name = itemService.name;
    } else if (item.itemName) {
        name = item.itemName;
    } else if (item.node) {
        name = item.node;
    } else {
        name = item.jid;
    }
    return name;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (UIImage*)serviceImage:(ServiceModel*)itemService {
    UIImage* image;
    NSString* serviceType = @"unknown";
    if (self.parentService) {
        serviceType = self.parentService.type;
    }
    if ([itemService.category isEqualToString:@"pubsub"] && [itemService.type isEqualToString:@"service"]) {
        image = [UIImage imageNamed:@"service-pubsub.png"];
    } else if ([itemService.category isEqualToString:@"pubsub"] && [itemService.type isEqualToString:@"collection"]) {
        image = [UIImage imageNamed:@"service-pubsub-folder.png"];
    } else if ([itemService.category isEqualToString:@"pubsub"] && [itemService.type isEqualToString:@"leaf"] && [[itemService.node pathComponents] count] <= 4) {
        image = [UIImage imageNamed:@"service-pubsub-folder.png"];
    } else if ([itemService.category isEqualToString:@"pubsub"] && [itemService.type isEqualToString:@"leaf"] && [itemService.node hasPrefix:@"/home"] && [[itemService.node pathComponents] count] > 4) {
        image = [self pubSubNodeImage:itemService];
    } else if ([itemService.category isEqualToString:@"conference"] && [itemService.type isEqualToString:@"text"]) {
        image = [UIImage imageNamed:@"service-chat.png"];
    } else if ([itemService.category isEqualToString:@"conference"] && [itemService.type isEqualToString:@"irc"]) {
        image = [UIImage imageNamed:@"service-chat.png"];
    } else if ([itemService.category isEqualToString:@"directory"] && [itemService.type isEqualToString:@"user"]) {
        image = [UIImage imageNamed:@"service-directory.png"];
    } else if ([itemService.category isEqualToString:@"proxy"] && [itemService.type isEqualToString:@"bytestreams"]) {
        image = [UIImage imageNamed:@"service-socket.png"];
    } else if ([serviceType isEqualToString:@"leaf"]) {
        image = [UIImage imageNamed:@"service-document.png"];
    } else {
        image = [UIImage imageNamed:@"service.png"];
    }
    return image;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (UIImage*)pubSubNodeImage:(ServiceModel*)itemService {
    UIImage* image;
    if ([[self.account pubSubRoot] isEqualToString:self.node]){
        image = [UIImage imageNamed:@"service-pubsub-node-blue.png"];
    } else if ([[SubscriptionModel findAllByAccount:self.account andNode:itemService.node] count] > 0) {
        image = [UIImage imageNamed:@"service-pubsub-node-green.png"];
    } else {
        image = [UIImage imageNamed:@"service-pubsub-node-grey.png"];
    }
    return image;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)enableImageTouch:(ServiceModel*)itemService {
    BOOL enable = NO;
    if ([itemService.category isEqualToString:@"pubsub"] && 
        [itemService.type isEqualToString:@"leaf"] && 
        [itemService.node hasPrefix:@"/home"] &&
        [[itemService.node pathComponents] count] > 4){
        enable = YES;
    } 
    return enable;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)editAccountButtonWasPressed { 
    [AccountManagerViewController inView:self.view.window];
}	

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)loadNextViewController {
    ServiceViewController* viewController = [[ServiceViewController alloc] initWithNibName:@"ServiceViewController" bundle:nil];
    [viewController setService:self.selectedItem.jid andNode:self.selectedItem.node];
    viewController.rootServiceViewController = self.rootServiceViewController;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)loadTextViewController:(MessageModel*)message {
    ServiceMessageViewController* messageController = [[ServiceMessageViewController alloc] initWithNibName:@"ServiceMessageViewController" bundle:nil]; 
    messageController.message = message;
    messageController.node = self.node;
    [self.navigationController pushViewController:messageController animated:YES]; 
    [messageController release];     
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
        [[XMPPClientManager instance] delegateTo:self forAccount:self.account];
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
    [self.tableView reloadData];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceiveDiscoInfoServiceError:(XMPPIQ*)iq {
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceivePubSubDeleteError:(XMPPIQ*)iq {
    [self reloadServiceItems];
    [AlertViewManager dismissActivityIndicator];
    [AlertViewManager showAlert:@"Node Delete Failed"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceivePubSubDeleteResult:(XMPPIQ*)iq {
    [self reloadServiceItems];
    [AlertViewManager dismissActivityIndicator];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceivePubSubItemError:(XMPPIQ*)iq {
    [AlertViewManager dismissActivityIndicator];
    [AlertViewManager showAlert:@"Item Retrieval Failed"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceivePubSubItemResult:(XMPPIQ*)iq {
    [AlertViewManager dismissActivityIndicator];
    MessageModel* message = [MessageModel findEventByNode:self.parentService.node andItemId:self.selectedItem.itemName andAccount:self.account];
    [self loadTextViewController:message];
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
        SectionViewController* sectionViewController = [SectionViewController viewControllerWithLabel:parentNode]; 
        [self.sectionViewControllers addObject:sectionViewController];
        sectionView = sectionViewController.view;
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
    ServiceModel* itemService = [ServiceModel findByJID:item.jid andNode:item.node];
    cell.itemLabel.text = [self serviceName:itemService forItem:item];
    cell.itemImage.image = [self serviceImage:itemService];
    cell.account = self.account;
    cell.service = itemService;
    cell.enableImageTouch = [self enableImageTouch:itemService];
    return cell;        
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ServiceItemModel* item = [self.serviceItems objectAtIndex:indexPath.row];
    self.selectedItem = item;
    XMPPClient* client = [[XMPPClientManager instance] xmppClientForAccount:self.account];
    if ([self.parentService.category isEqualToString:@"pubsub"] && [self.parentService.type isEqualToString:@"leaf"]) {
        MessageModel* message = [MessageModel findEventByNode:self.parentService.node andItemId:item.itemName andAccount:self.account];
        if (message) {
            [self loadTextViewController:message];
        } else {
            [XMPPPubSub get:client JID:[XMPPJID jidWithString:item.jid] node:self.parentService.node withId:item.itemName];
        }
    } else {
        [XMPPDiscoItemsQuery get:client JID:[XMPPJID jidWithString:item.jid] node:item.node andDelegateResponse:[[XMPPDiscoItemsServiceResponseDelegate alloc] init]];
        [AlertViewManager showActivityIndicatorInView:self.view.window withTitle:@"Service Disco"];
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
    [self.editAccountsButton release];
    [self.searchServiceButton release];
    [self.rootServiceViewController release];
    [self.serviceItems release];
    [self.node release];
    [self.service release];
    [self.account release];
    [self.selectedItem release];
    [self.parentService release];
    [self.sectionViewControllers release];
    [super dealloc];
}

@end

