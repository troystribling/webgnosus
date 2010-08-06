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

- (void)applyUpdate:(void (^)(id updateInterface))updateBlock;

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
        [self applyUpdate:^(id updateInterface) {
            if ([updateInterface respondsToSelector:@selector(didStopGeoLocManager:)]) {
                [updateInterface didStopGeoLocManager:self];
            } 
        }];
        NSLog(@"Geoloc Started");
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)stop {
    if (self.running) {
        self.running = NO;
        [self.locationManager stopUpdatingLocation];
        [self applyUpdate:^(id updateInterface) {
            if ([updateInterface respondsToSelector:@selector(didStartGeoLocManager:)]) {
                [updateInterface didStartGeoLocManager:self];
            } 
        }];
        NSLog(@"Geoloc Stopped");
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)stopIfNotUpdating {
    if ([self.accountUpdates count] == 0) {
        [self stop];
    } 
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)accountUpdatesEnabled:(AccountModel*)account {
    if ([self.accountUpdates valueForKey:[account fullJID]]) {
        return self.running;
    } else {
        return NO;
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addUpdateDelegate:(id<GeoLocUpdateDelegate>)updateDelegate forAccount:(AccountModel*)account {
    NSMutableArray* updateDelegates = [self.accountUpdates valueForKey:[account fullJID]];
    if (!updateDelegates) {
        updateDelegates = [NSMutableArray arrayWithCapacity:10];
        [self.accountUpdates setObject:updateDelegates forKey:[account fullJID]];
    }
    [updateDelegates addObject:updateDelegate];
    for (int i = 0; i < [updateDelegates count]; i++) {
        id update = [updateDelegates objectAtIndex:i];
        if ([update respondsToSelector:@selector(geoLocManager:didAddAccount:)]) {
            [update geoLocManager:self didAddAccount:account];
        } 
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)removeUpdateDelegatesForAccount:(AccountModel*)account {
    NSArray* updateDelegates = [self.accountUpdates valueForKey:[account fullJID]];
	if (updateDelegates) {
        for (int i = 0; i < [updateDelegates count]; i++) {
            id update = [updateDelegates objectAtIndex:i];
            if ([update respondsToSelector:@selector(geoLocManager:didRemoveAccount:)]) {
                [update geoLocManager:self didRemoveAccount:account];
            } 
        }
        [self.accountUpdates removeObjectForKey:[account fullJID]];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)removeUpdateDelegate:(id)delegate forAccount:(AccountModel*)account {
    NSMutableArray* updateDelegates = [self.accountUpdates valueForKey:[account fullJID]];
	if (updateDelegates) {
        for (int i = 0; i < [updateDelegates count]; i++) {
            id update = [updateDelegates objectAtIndex:i];
            if (update == delegate) {
                if ([update respondsToSelector:@selector(geoLocManager:didRemoveDelegate:forAccount:)]) {
                    [update geoLocManager:self didRemoveDelegate:(id)delegate forAccount:account];
                } 
                [updateDelegates removeObjectAtIndex:i];
                break;
            }
        }
    }
}

//===================================================================================================================================
#pragma mark GeoLocManager PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)applyUpdate:(void (^)(id updateInterface))updateBlock {
    NSArray* updateArrays = [self.accountUpdates allValues];
    for (int i = 0; i < [updateArrays count]; i++) {
        NSArray* updateArray = [updateArrays objectAtIndex:i];
        for (int j = 0; j < [updateArray count]; j++) {
            id update = [updateArray objectAtIndex:j];
            updateBlock(update);
        }
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
    [self applyUpdate:^(id updateInterface) {
        if ([updateInterface respondsToSelector:@selector(geoLocManager:didUpdateToLocation:fromLocation:)]) {
            [updateInterface geoLocManager:self didUpdateToLocation:newLocation fromLocation:oldLocation];
        } 
    }];
    [self applyUpdate:^(id updateInterface) {
        if ([updateInterface respondsToSelector:@selector(didFinishGeoLocManagerUpdate:)]) {
            [updateInterface didFinishGeoLocManagerUpdate:self];
        } 
    }];
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
