//
//  LocationGetter.m
//  CoreLocationExample
//
//  Created by Motivity
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "LocationGetter.h"
#import <CoreLocation/CoreLocation.h>

@implementation LocationGetter

@synthesize locationManager, delegate;

BOOL didUpdate = NO;

- (void)startUpdates
{
    NSLog(@"Starting Location Updates");
    
    if (locationManager == nil)
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
    // You have some options here, though higher accuracy takes longer to resolve.
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;  
    [locationManager startUpdatingLocation];    
}



// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manage didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (didUpdate)
        return;
    didUpdate = YES;
	// Disable future updates to save power.
    [locationManager stopUpdatingLocation];
    // let our delegate know we're done
    [delegate newPhysicalLocation:newLocation];
}

- (void)dealloc
{
    [locationManager release];
    [super dealloc];
}

@end
