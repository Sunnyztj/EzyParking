//
//  EPMainViewController.m
//  EzyParking
//
//  Created by Ben Zhang on 10/22/14.
//  Copyright (c) 2014 Sunny Zhou. All rights reserved.
//

#import "EPMainViewController.h"

#define SEARCH_RADIUS_IN_M 6000
#define SEARCH_RADIUS_PLUS_BUFFER SEARCH_RADIUS_IN_M * 1.43
@interface EPMainViewController ()

@end

@implementation EPMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hasSetUserLocation = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupMainViewController];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.myLocationManager startUpdatingLocation];
}

- (void)setupMainViewController {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"CarParking" withExtension:@"plist"];
    NSDictionary *carParkingDictionary = [[NSDictionary alloc] initWithContentsOfURL:url];
    EPCarParking *carParking = [EPCarParking carParkingWithDictionary:carParkingDictionary];
    if (_carParking != carParking) {
        _carParking = carParking;
    }
    
    self.mapView.delegate = self;
    if ([CLLocationManager locationServicesEnabled]){
        self.myLocationManager = [[CLLocationManager alloc] init];
        self.myLocationManager.delegate = self;
        self.myLocationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;

        [self.myLocationManager startUpdatingLocation];
    } else {
        /* Location services are not enabled.
         Take appropriate action: for instance, prompt the
         user to enable the location services */
        NSLog(@"Location services are not enabled");
    }
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.myLocationManager.location.coordinate, SEARCH_RADIUS_PLUS_BUFFER, SEARCH_RADIUS_PLUS_BUFFER);
    [self loadCouponsWithRegion:region];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    NSLog(@"regionWillChangeAnimated Region %f %f", mapView.region.center.latitude, mapView.region.center.longitude);
}

- (void) mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"Changing Region %f %f", mapView.region.center.latitude, mapView.region.center.longitude);
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
    if(self.hasSetUserLocation == NO)
    {
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, SEARCH_RADIUS_PLUS_BUFFER, SEARCH_RADIUS_PLUS_BUFFER);
        
        self.hasSetUserLocation = YES;
        
//        [self.mapView setRegion:region animated:YES];
        [self loadCouponsWithRegion:region];
    }
}

- (void) loadCouponsWithRegion:(MKCoordinateRegion) region
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 500 * NSEC_PER_MSEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
                    [self.mapView setRegion:region animated:YES];
                    }
                );
}
@end
