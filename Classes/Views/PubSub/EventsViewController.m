//
//  EventsViewController.m
//  webgnosus
//
//  Created by Troy Stribling on 9/7/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "EventsViewController.h"
#import "MessageModel.h"
#import "AccountModel.h"
#import "ServiceItemModel.h"
#import "MessageCellFactory.h"
#import "SectionViewController.h"
#import "SegmentedCycleList.h"
#import "EventMessageViewController.h"
#import "PubMessageCache.h"
#import "SubMessageCache.h"
#import "XMPPClientManager.h"
#import "XMPPClient.h"
#import "XMPPJID.h"
#import "XMPPGeoLoc.h"
#import "XMPPMessage.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface EventsViewController (PrivateAPI)

- (void)addEventButton;
- (void)addDelgate;
- (void)removeDelgate;
- (void)loadAccount;
- (void)loadMessages;
- (void)createSegementedController;
- (void)addMapView;
- (void)removeMapView;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation EventsViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize events;
@synthesize service;
@synthesize map;
@synthesize node;
@synthesize name;
@synthesize account;
@synthesize eventType;
@synthesize displayType;
@synthesize addEventButton;

//===================================================================================================================================
#pragma mark EventsViewController

//===================================================================================================================================
#pragma mark EventsViewController PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)createAddEventButton {
    if (self.eventType == kPUB_MODE) { 
        self.navigationItem.rightBarButtonItem = self.addEventButton;
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)sendEventButtonWasPressed:(id)sender {
    EventMessageViewController* viewController = [[EventMessageViewController alloc] initWithNibName:@"EventMessageViewController" bundle:nil];
    viewController.service = self.service;
    viewController.node = self.node;
	[self.navigationController pushViewController:viewController animated:YES]; 
}	

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addDelgates {
    if (self.account) {
        [[XMPPClientManager instance] delegateTo:self forAccount:self.account];
        [[GeoLocManager instance] addUpdateDelegate:self forAccount:self.account];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)removeDelgates {
    if (self.account) {
        [[XMPPClientManager instance] removeXMPPClientDelegate:self forAccount:self.account];
        [[GeoLocManager instance] removeUpdateDelegate:self forAccount:self.account];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)loadAccount {
    self.account = [AccountModel findFirstDisplayed];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)loadEvents {
    if (self.eventType == kPUB_MODE) { 
        self.events = [[PubMessageCache alloc] initWithNode:self.node andAccount:self.account];
    } else {
        self.events = [[SubMessageCache alloc] initWithNode:self.node andAccount:self.account];
    }
    [self.tableView reloadData];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)createSegementedController {
    if ([self.node isEqualToString:[self.account geoLocPubSubNode]]) {
        CGRect rect = CGRectMake(0.0f, 0.0f, 120.0f, 30.0f);
        self.displayType = kEVENTS_MODE;
        SegmentedCycleList* segmentControl = 
            [[SegmentedCycleList alloc] init:[NSMutableArray arrayWithObjects:@"Events", @"Map", nil] withValueAtIndex:kEVENTS_MODE andRect:rect];
        segmentControl.delegate = self;
        self.navigationItem.titleView = segmentControl;
        [segmentControl release];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addMapView {
    [self.view addSubview:self.map];
    MessageModel* geoLocMessage = [MessageModel findLatestGeoLocMessage];
    if (geoLocMessage) {
        XMPPGeoLoc* geoLoc = [geoLocMessage parseGeoLocMessage];
        MKCoordinateRegion newRegion;
        newRegion.center.latitude = [geoLoc lat];
        newRegion.center.longitude = [geoLoc lon];
        newRegion.span.latitudeDelta = 0.112872;
        newRegion.span.longitudeDelta = 0.109863;    
        [self.map setRegion:newRegion animated:YES];    
    }
}
     
//-----------------------------------------------------------------------------------------------------------------------------------
- (void)removeMapView {
    [self.map removeFromSuperview];
}

//===================================================================================================================================
#pragma mark XMPPClientDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceiveEvent:(XMPPMessage*)message {
    [self loadEvents];
}

//===================================================================================================================================
#pragma mark GeoLocUpdateDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)didFinishGeoLocManagerUpdate:(GeoLocManager*)geoLocMgr {
    if (self.eventType == kPUB_MODE) { 
        [self loadEvents];
    }
}

//===================================================================================================================================
#pragma mark UIViewController

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithNibName:(NSString*)nibName bundle:(NSBundle*)nibBundle  {
    if (self = [super initWithNibName:nibName bundle:nibBundle]) {
        self.addEventButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(sendEventButtonWasPressed:)];
        self.map = [[MKMapView alloc] initWithFrame:self.view.frame];
    }
    return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [self createAddEventButton];
    [super viewDidLoad];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated {
    [self loadAccount];
    [self createSegementedController];
    [self addDelgates];
    self.navigationItem.title = @"Events";
    [self loadEvents];
    [super viewWillAppear:animated];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillDisappear:(BOOL)animated {
    [self removeDelgates];
	[super viewWillDisappear:animated];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
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
#pragma mark SegmentedCycleList Delegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)selectedItemChanged:(SegmentedCycleList*)sender {
    self.displayType = sender.selectedItemIndex;
    if (self.displayType == kEVENTS_MODE) {
        [self removeMapView];
    } else {
        [self addMapView];
    }
}

//===================================================================================================================================
#pragma mark UITableViewController

//===================================================================================================================================
#pragma mark UITableViewDeligate

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    return [self.events tableView:tableView heightForRowAtIndexPath:indexPath];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* sectionView = nil;
    if (self.account) {
        sectionView = [SectionViewController viewWithLabel:[NSString stringWithFormat:@"%@/%@", [[UserModel nodeToJID:self.node] full], self.name]]; 
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.events count];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {  
    return [self.events tableView:tableView cellForRowAtIndexPath:indexPath];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.events tableView:tableView didSelectRowAtIndexPath:indexPath];
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

