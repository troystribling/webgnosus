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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface LocationManager : NSObject <CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    NSMutableArray *locationMeasurements;
    CLLocation *location;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) NSMutableArray *locationMeasurements;
@property (nonatomic, retain) CLLocation *location;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (LocationManager*)instance;

@end
