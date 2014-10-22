//
//  EPCarParking.m
//  EzyParking
//
//  Created by Ben Zhang on 10/22/14.
//  Copyright (c) 2014 Sunny Zhou. All rights reserved.
//

#import "EPCarParking.h"
#import "EPCarParkingInfo.h"

@implementation EPCarParking
+ (instancetype)carParkingWithDictionary:(NSDictionary *)dictionary
{
    EPCarParking *carparking = [[self alloc] init];
    NSArray *addressDictionaries = [dictionary objectForKey:@"carparkinginfos"];
    NSMutableArray *carParkingInfos = [NSMutableArray array];
    
    for (NSDictionary *addressDictionary in addressDictionaries) {

        EPCarParkingInfo *info = [EPCarParkingInfo infoWithDictionary:addressDictionary];
        [carParkingInfos addObject:info];
    }
    
    carparking.info = carParkingInfos;
    
    return carparking;
}
@end
