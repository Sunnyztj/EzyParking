//
//  EPCarParkingInfo.h
//  EzyParking
//
//  Created by Ben Zhang on 10/22/14.
//  Copyright (c) 2014 Sunny Zhou. All rights reserved.
//

@import Foundation;
#import <CoreLocation/CoreLocation.h>

@interface EPCarParkingInfo : NSObject
+ (instancetype)infoWithDictionary:(NSDictionary *)dictionary;

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *xml;
@property (copy, nonatomic) NSString *address;
@property (readwrite, nonatomic) CLLocationCoordinate2D coordinate;

@end
