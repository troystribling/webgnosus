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
- (void)createNavBarButtons;
- (void)addMapView;
- (void)removeMapView;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation EventsViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize events;
@synthesize service;
@synthesize geoLocMap;
@synthesize sectionViewController;
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
    if (self.displayType == kEVENTS_MODE) {
        if (self.eventType == kPUB_MODE) { 
            self.events = [[[PubMessageCache alloc] initWithNode:self.node andAccount:self.account] autorelease];
        } else {
            self.events = [[[SubMessageCache alloc] initWithNode:self.node andAccount:self.account] autorelease];
        }
        [self.tableView reloadData];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)createNavBarButtons {
    if ([self.node isEqualToString:[self.account geoLocPubSubNode]]) {
        CGRect rect = CGRectMake(0.0f, 0.0f, 120.0f, 30.0f);
        self.displayType = kEVENTS_MODE;
        SegmentedCycleList* segmentControl = 
            [[SegmentedCycleList alloc] init:[NSMutableArray arrayWithObjects:@"Events", @"Map", nil] withValueAtIndex:kEVENTS_MODE andRect:rect];
        segmentControl.delegate = self;
        self.navigationItem.titleView = segmentControl;
        [segmentControl release];
    } else {
        [self createAddEventButton];
        self.navigationItem.title = @"Events";
    }

}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addMapView {
    MessageModel* geoLocMessage = [MessageModel findLatestGeoLocMessage];
    if (geoLocMessage) {
        XMPPGeoLoc* geoLoc = [geoLocMessage parseGeoLocMessage];
        MKCoordinateRegion newRegion;
        double lat = [geoLoc lat];
        double lon = [geoLoc lon];
        double accuracy = [geoLoc accuracy];
        double meters_per_degree_lon = abs(kRADIANS_PER_DEGREE*kEARTHS_RADIUS_METERS*sin(kRADIANS_PER_DEGREE*lon));
        double display_scale = MAX(kGEOLOC_ACCURACY_SCALE*accuracy, kMAP_SCALE_MIN);
        double displayAspect = self.view.frame.size.width/self.view.frame.size.height;
        double lat_delta = display_scale/kMETERS_PER_DEGREE_LAT;
        double lon_delta = displayAspect*display_scale/meters_per_degree_lon;
        newRegion.center.latitude = lat;
        newRegion.center.longitude = lon;        
        newRegion.span.latitudeDelta = lat_delta;
        newRegion.span.longitudeDelta = lon_delta;    
        [self.geoLocMap setRegion:newRegion animated:NO];    
        self.geoLocMap.showsUserLocation = YES;
    }
    [self.view addSubview:self.geoLocMap];
}
     
//-----------------------------------------------------------------------------------------------------------------------------------
- (void)removeMapView {
    [self.geoLocMap removeFromSuperview];
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
        self.geoLocMap = [[MKMapView alloc] initWithFrame:self.view.frame];
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
    [self createNavBarButtons];
    [self addDelgates];
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
    if (self.displayType == kGEOLOC_MODE) {
        [self removeMapView];
    }        
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
        self.sectionViewController = [SectionViewController viewControllerWithLabel:[NSString stringWithFormat:@"%@/%@", [[UserModel nodeToJID:self.node] full], self.name]];
        sectionView = self.sectionViewController.view;
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
    [self.events release];
    [self.account release];
    [self.geoLocMap release];
    [self.sectionViewController release];
    [self.service release];
    [self.node release];
    [self.events release];
    [self.name release];
    [self.addEventButton release];
    [super dealloc];
}

@end

