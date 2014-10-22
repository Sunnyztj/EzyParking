//
//  EPMainViewController.h
//  EzyParking
//
//  Created by Ben Zhang on 10/22/14.
//  Copyright (c) 2014 Sunny Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "EPCarParking.h"
#import <CoreLocation/CoreLocation.h>

@interface EPMainViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate>

@property BOOL hasSetUserLocation;
@property (strong, nonatomic) EPCarParking *carParking;
@property (nonatomic, retain) CLLocationManager *myLocationManager;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
