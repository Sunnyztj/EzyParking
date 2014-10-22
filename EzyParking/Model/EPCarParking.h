//
//  EPCarParking.h
//  EzyParking
//
//  Created by Ben Zhang on 10/22/14.
//  Copyright (c) 2014 Sunny Zhou. All rights reserved.
//

@import Foundation;

@interface EPCarParking : NSObject


+ (instancetype)carParkingWithDictionary:(NSDictionary *)dictionary;

@property (copy, nonatomic) NSArray *info;
@property (copy, nonatomic) NSString *name;

@end
