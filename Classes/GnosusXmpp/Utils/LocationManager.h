//
//  LocationManager.h
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
@interface LocationManager : NSObject <CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    NSMutableArray *locationMeasurements;
    NSMutableDictionary *accountUpdates;
    CLLocation *location;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) NSMutableArray *locationMeasurements;
@property (nonatomic, retain) NSMutableDictionary *accountUpdates;
@property (nonatomic, retain) CLLocation *location;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (LocationManager*)instance;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)start;
- (void)stop;
- (void)addUpdateDelegate:(id)account forAccount:(AccountModel*)account;
- (void)removeUpdateDelegateForAccount:(AccountModel*)account;

@end

//===================================================================================================================================
#pragma mark -

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface NSObject (LocationManagerDelegate)

- (void)locationManager:(CLLocationManager*)manager didUpdateToLocation:(CLLocation*)newLocation fromLocation:(CLLocation*)oldLocation;

@end
