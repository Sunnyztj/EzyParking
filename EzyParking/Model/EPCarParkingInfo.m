//
//  EPCarParkingInfo.m
//  EzyParking
//
//  Created by Ben Zhang on 10/22/14.
//  Copyright (c) 2014 Sunny Zhou. All rights reserved.
//

#import "EPCarParkingInfo.h"

@implementation EPCarParkingInfo

+ (instancetype)infoWithDictionary:(NSDictionary *)dictionary
{
    EPCarParkingInfo *carParkingInfo = [[self alloc] init];
    carParkingInfo.name = [dictionary objectForKey:@"name"];
    carParkingInfo.address = [dictionary objectForKey:@"address"];
    carParkingInfo.xml = [dictionary objectForKey:@"xml"];
    CLGeocoder *myGeocoder = [[CLGeocoder alloc] init];
    [myGeocoder
     geocodeAddressString:carParkingInfo.address
     completionHandler:^(NSArray *placemarks, NSError *error) {
         if (placemarks.count > 0 && error == nil) {
             NSLog(@"Found %lu placemark(s).",
                   (unsigned long)[placemarks count]);
             CLPlacemark *firstPlacemark = placemarks[0];
             carParkingInfo.coordinate = firstPlacemark.location.coordinate;
         }
         else if (placemarks.count == 0 &&
                  error == nil){
             NSLog(@"Found no placemarks.");
         }
         else if (error != nil){
             NSLog(@"An error occurred = %@", error);
         }
     }];
    return carParkingInfo;
}

@end
