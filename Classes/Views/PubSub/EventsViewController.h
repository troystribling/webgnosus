//
//  EventsViewController.h
//  webgnosus
//
//  Created by Troy Stribling on 9/7/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "GeoLocManager.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@class AccountModel;
@class UserModel;
@class MessageCache;
@class SectionViewController;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface EventsViewController : UITableViewController <GeoLocUpdateDelegate> {
    MessageCache* events;
    AccountModel* account;
    MKMapView* geoLocMap;
    SectionViewController* sectionViewController;
    NSString* service;
    NSString* node;
    NSString* name;
    NSInteger eventType;
    NSInteger displayType;
	UIBarButtonItem* addEventButton;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) MessageCache* events;
@property (nonatomic, retain) AccountModel* account;
@property (nonatomic, retain) MKMapView* geoLocMap;
@property (nonatomic, retain) SectionViewController* sectionViewController;
@property (nonatomic, retain) NSString* service;
@property (nonatomic, retain) NSString* node;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, assign) NSInteger eventType;
@property (nonatomic, assign) NSInteger displayType;
@property (nonatomic, retain) UIBarButtonItem* addEventButton;

//-----------------------------------------------------------------------------------------------------------------------------------

@end
