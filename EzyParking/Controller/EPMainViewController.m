//
//  EPMainViewController.m
//  EzyParking
//
//  Created by Ben Zhang on 10/22/14.
//  Copyright (c) 2014 Sunny Zhou. All rights reserved.
//

#import "EPMainViewController.h"
#import "EPAnnotation.h"
#import "EPCarParkingInfo.h"
#import "XMLReader.h"

#define SEARCH_RADIUS_IN_M 6000
#define SEARCH_RADIUS_PLUS_BUFFER SEARCH_RADIUS_IN_M * 1.43
@interface EPMainViewController ()
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) MKPlacemark *placemark;
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
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.myLocationManager.location.coordinate, SEARCH_RADIUS_PLUS_BUFFER, SEARCH_RADIUS_PLUS_BUFFER);
    [self loadCouponsWithRegion:region];
}

- (void)setupMainViewController {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"CarParking" withExtension:@"plist"];
    NSDictionary *carParkingDictionary = [[NSDictionary alloc] initWithContentsOfURL:url];
    EPCarParking *carParking = [EPCarParking carParkingWithDictionary:carParkingDictionary];
    if (_carParking != carParking) {
        _carParking = carParking;
    }
    
    // Create a geocoder and save it for later.
    self.geocoder = [[CLGeocoder alloc] init];
    
    self.mapView.delegate = self;
    if ([CLLocationManager locationServicesEnabled]){
        self.myLocationManager = [[CLLocationManager alloc] init];
        self.myLocationManager.delegate = self;
        self.myLocationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;

        [self.myLocationManager startUpdatingLocation];
//        [self.myLocationManager requestAlwaysAuthorization];
        [self.myLocationManager requestWhenInUseAuthorization];
    } else {
        /* Location services are not enabled.
         Take appropriate action: for instance, prompt the
         user to enable the location services */
        NSLog(@"Location services are not enabled");
    }
    [self setupCarParkingAnnotation];
    [self performSelector:@selector(setupCarParkingAnnotation) withObject:nil afterDelay:2.0];
    [NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(setupCarParkingAnnotation) userInfo:nil repeats:YES];
}

- (void)setupCarParkingAnnotation{
    
    NSArray *existingpoints = self.mapView.annotations;
    
    if ([existingpoints count])
        [self.mapView removeAnnotations:existingpoints];
    
    for (id info in _carParking.info) {
        if (info != nil) {
            if ([info isKindOfClass:[EPCarParkingInfo class]]) {
                EPCarParkingInfo *carparkinginfo = (EPCarParkingInfo *)info;
                NSURL *URL = [NSURL URLWithString:carparkinginfo.xml];
                NSData *data = [[NSData alloc] initWithContentsOfURL:URL];
                NSError *error = nil;
                
                NSDictionary *dictionary = [XMLReader dictionaryForXMLData:data error:&error];
                NSString *subTitle = [[[[[dictionary objectForKey:@"Report"] objectForKey:@"table1"] objectForKey:@"CarparkName_Collection"] objectForKey:@"CarparkName"] objectForKey:@"Textbox32"];
                EPAnnotation *annotation = [[EPAnnotation alloc] initWithCoordinates:carparkinginfo.coordinate
                                                                               title:carparkinginfo.name
                                                                            subTitle:subTitle];
                NSNumber *restNumber = [NSNumber numberWithInteger:[subTitle integerValue]];
                if (restNumber <= [NSNumber numberWithInt:60]) {
                    annotation.pinColor = MKPinAnnotationColorRed;
                } else if (restNumber <= [NSNumber numberWithInt:200]) {
                    annotation.pinColor = MKPinAnnotationColorPurple;
                } else {
                    annotation.pinColor = MKPinAnnotationColorGreen;
                }

                [self.mapView addAnnotation:annotation];
            }

            
        }
    }
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

- (void) loadCouponsWithRegion:(MKCoordinateRegion) region
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 500 * NSEC_PER_MSEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
                    [self.mapView setRegion:region animated:YES];
                    }
                );
}

// Wait for location callbacks
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
//    NSLog(@"%@", [locations lastObject]);
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    // Center the map the first time we get a real location change.
    static dispatch_once_t centerMapFirstTime;
    
    if ((userLocation.coordinate.latitude != 0.0) && (userLocation.coordinate.longitude != 0.0)) {
        dispatch_once(&centerMapFirstTime, ^{
            [self.mapView setCenterCoordinate:userLocation.coordinate animated:YES];
        });
    }
    
    // Lookup the information for the current location of the user.
    [self.geocoder reverseGeocodeLocation:self.mapView.userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        if ((placemarks != nil) && (placemarks.count > 0)) {
            // If the placemark is not nil then we have at least one placemark. Typically there will only be one.
            _placemark = [placemarks objectAtIndex:0];
            
            // we have received our current location, so enable the "Get Current Address" button
//            [self.getAddressButton setEnabled:YES];
        }
        else {
            // Handle the nil case if necessary.
        }
    }];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    MKAnnotationView *result = nil;
    if ( ![annotation isKindOfClass:[EPAnnotation class]]) {
        return result;
    }
    
    if (![mapView isEqual: self.mapView]) {
        return result;
    }
    
    EPAnnotation *senderAnnotation = (EPAnnotation *)annotation;
    
    /* First typecast the annotation for which the Map View has
     fired this delegate message */
    /* Using the class method we have defined in our custom
     annotation class, we will attempt to get a reusable
     identifier for the pin we are about
     to create */
    NSString *pinReusableIdentifier = [EPAnnotation reusableIdentifierforPinColor:senderAnnotation.pinColor];
    
    /* Using the identifier we retrieved above, we will
     attempt to reuse a pin in the sender Map View */
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pinReusableIdentifier];
    
    if (annotationView == nil){
        /* If we fail to reuse a pin, then we will create one */
        annotationView = [[MKPinAnnotationView alloc]
                          initWithAnnotation:senderAnnotation
                          reuseIdentifier:pinReusableIdentifier];
        /* Make sure we can see the callouts on top of
         each pin in case we have assigned title and/or
         subtitle to each pin */
        [annotationView setCanShowCallout:YES];
    }
    /* Now make sure, whether we have reused a pin or not, that
     the color of the pin matches the color of the annotation */
    annotationView.pinColor = senderAnnotation.pinColor;
    
    result = annotationView;
    
    return result;
}



@end
