//
//  GeoLocManager.h
//  webgnosus
//
//  Created by Troy Stribling on 7/29/10.
//  Copyright 2010 Plan-B Reserach. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

//-----------------------------------------------------------------------------------------------------------------------------------
@class AccountModel;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface GeoLocManager : NSObject <CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    NSMutableArray *locationMeasurements;
    NSMutableDictionary *accountUpdates;
    CLLocation *location;
    BOOL running;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) NSMutableArray *locationMeasurements;
@property (nonatomic, retain) NSMutableDictionary *accountUpdates;
@property (nonatomic, retain) CLLocation *location;
@property (nonatomic, assign) BOOL running;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (GeoLocManager*)instance;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)start;
- (void)stop;
- (void)stopIfNotUpdating;
- (BOOL)accountUpdatesEnabled:(AccountModel*)account;
- (void)addUpdateDelegate:(id)updateDelegate forAccount:(AccountModel*)account;
- (void)removeUpdateDelegatesForAccount:(AccountModel*)account;
- (void)removeUpdateDelegate:(id)delegate forAccount:(AccountModel*)account;

@end

//===================================================================================================================================
#pragma mark -

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@protocol GeoLocUpdateDelegate

@optional

- (void)geoLocManager:(GeoLocManager*)geoLocMgr didAddAccount:(AccountModel*)account;
- (void)geoLocManager:(GeoLocManager*)geoLocMgr didRemoveDelegate:(id)delegate forAccount:(AccountModel*)account;
- (void)geoLocManager:(GeoLocManager*)geoLocMgr didRemoveAccount:(AccountModel*)account;
- (void)didStartGeoLocManager:(GeoLocManager*)geoLocMgr;
- (void)didStopGeoLocManager:(GeoLocManager*)geoLocMgr;
- (void)geoLocManager:(GeoLocManager*)geoLocMgr didUpdateToLocation:(CLLocation*)newLocation fromLocation:(CLLocation*)oldLocation;
- (void)didFinishGeoLocManagerUpdate:(GeoLocManager*)geoLocMgr;

@end
