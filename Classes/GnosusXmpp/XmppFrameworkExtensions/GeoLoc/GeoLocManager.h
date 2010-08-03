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
- (void)removeUpdateDelegateForAccount:(AccountModel*)account;

@end

//===================================================================================================================================
#pragma mark -

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@protocol GeoLocUpdateDelegate

- (void)locationManager:(CLLocationManager*)manager didUpdateToLocation:(CLLocation*)newLocation fromLocation:(CLLocation*)oldLocation;

@end
