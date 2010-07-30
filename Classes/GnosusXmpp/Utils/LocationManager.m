//
//  LocationManager.m
//  webgnosus
//
//  Created by Troy Stribling on 7/29/10.
//  Copyright 2010 Plan-B Reserach. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "LocationManager.h"
#import "AlertViewManager.h"

//-----------------------------------------------------------------------------------------------------------------------------------
static LocationManager* thisLocationManager = nil;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface LocationManager (PrivateAPI)
@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation LocationManager

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize locationManager;
@synthesize locationMeasurements;
@synthesize accounts;
@synthesize location;

//===================================================================================================================================
#pragma mark LocationManager

//-----------------------------------------------------------------------------------------------------------------------------------
+ (LocationManager*)instance {	
    @synchronized(self) {
        if (thisLocationManager == nil) {
            [[self alloc] init]; 
            thisLocationManager.locationManager = [[[CLLocationManager alloc] init] autorelease];
            thisLocationManager.locationManager.delegate = thisLocationManager;
            thisLocationManager.locationManager.desiredAccuracy = kLOCATION_MANAGER_ACCURACY;
            thisLocationManager.locationManager.distanceFilter = kLOCATION_MANAGER_DISTANCE_FILTER;
        }
    }       
    return thisLocationManager;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)start {
    [self.locationManager startUpdatingLocation];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)stop {
    [self.locationManager stopUpdatingLocation];
}

//===================================================================================================================================
#pragma mark CLLocationManagerDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [self.locationMeasurements addObject:newLocation];
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0) return;
    if (newLocation.horizontalAccuracy < 0) return;
    if (self.location == nil || self.location.horizontalAccuracy > newLocation.horizontalAccuracy) {
        self.location = newLocation;
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([error code] != kCLErrorLocationUnknown) {
        [self stop];
        [AlertViewManager showAlert:@"Error Collecting Location Data"];
    }
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
