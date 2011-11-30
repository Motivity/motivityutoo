//
//  LocationGetter.h
//  CoreLocationExample
//
//  Created by Motivity
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol LocationGetterDelegate <NSObject>
@required
- (void) newPhysicalLocation:(CLLocation *)location;
@end

@interface LocationGetter : NSObject <CLLocationManagerDelegate> { 
    CLLocationManager *locationManager;
    id delegate;
}

- (void)startUpdates;

@property (nonatomic, retain) CLLocationManager *locationManager;
@property(nonatomic , retain) id delegate;
@end