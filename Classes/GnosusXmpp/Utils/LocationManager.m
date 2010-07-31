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
#import "AccountModel.h"

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
@synthesize accountUpdates;
@synthesize location;

//===================================================================================================================================
#pragma mark LocationManager

//-----------------------------------------------------------------------------------------------------------------------------------
+ (LocationManager*)instance {	
    @synchronized(self) {
        if (thisLocationManager == nil) {
            thisLocationManager = [[self alloc] init]; 
        }
    }       
    return thisLocationManager;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kLOCATION_MANAGER_ACCURACY;
    self.locationManager.distanceFilter = kLOCATION_MANAGER_DISTANCE_FILTER;
    self.accountUpdates = [NSMutableDictionary dictionaryWithCapacity:10];
    return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)start {
    [self.locationManager startUpdatingLocation];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)stop {
    [self.locationManager stopUpdatingLocation];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addUpdateDelegate:(id)updateDelegate forAccount:(AccountModel*)account {
    [self.accountUpdates setObject:updateDelegate forKey:[account fullJID]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)removeUpdateDelegateForAccount:(AccountModel*)account {
    id updateDelegate = [self.accountUpdates valueForKey:[account fullJID]];
	if (updateDelegate) {
        [self.accountUpdates removeObjectForKey:[account fullJID]];
    }
}

//===================================================================================================================================
#pragma mark CLLocationManagerDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)locationManager:(CLLocationManager*)manager didUpdateToLocation:(CLLocation*)newLocation fromLocation:(CLLocation*)oldLocation {
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
