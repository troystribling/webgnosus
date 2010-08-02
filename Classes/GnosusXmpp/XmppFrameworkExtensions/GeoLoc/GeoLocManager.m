//
//  GeoLocManager.m
//  webgnosus
//
//  Created by Troy Stribling on 7/29/10.
//  Copyright 2010 Plan-B Reserach. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "GeoLocManager.h"
#import "AlertViewManager.h"
#import "AccountModel.h"

//-----------------------------------------------------------------------------------------------------------------------------------
static GeoLocManager* thisLocationManager = nil;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface GeoLocManager (PrivateAPI)
@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation GeoLocManager

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize locationManager;
@synthesize locationMeasurements;
@synthesize accountUpdates;
@synthesize location;
@synthesize running;

//===================================================================================================================================
#pragma mark GeoLocManager

//-----------------------------------------------------------------------------------------------------------------------------------
+ (GeoLocManager*)instance {	
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
    self.running = NO;
    return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)start {
    if (!self.running) {
        self.running = YES;
        [self.locationManager startUpdatingLocation];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)stop {
    if (self.running) {
        self.running = NO;
        [self.locationManager stopUpdatingLocation];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)accountUpdatesEnabled:(AccountModel*)account {
    if ([self.accountUpdates valueForKey:[account fullJID]]) {
        return YES;
    } else {
        return NO;
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addUpdateDelegate:(id<GeoLocUpdateDelegate>)updateDelegate forAccount:(AccountModel*)account {
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
    self.location = newLocation;
    NSArray* updates = [self.accountUpdates allValues];
    for (int i=0; i < [updates count]; i++) {
        id update = [updates objectAtIndex:i];
        if ([update respondsToSelector:@selector(locationManager:didUpdateToLocation:fromLocation:)]) {
            [update locationManager:manager didUpdateToLocation:newLocation fromLocation:oldLocation];
        } 
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
