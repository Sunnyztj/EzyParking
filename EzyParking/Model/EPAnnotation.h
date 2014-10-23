//
//  EPAnnotation.h
//  EzyParking
//
//  Created by Ben Zhang on 10/23/14.
//  Copyright (c) 2014 Sunny Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

extern NSString *const kReusablePinRed;
extern NSString *const kReusablePinGreen;
extern NSString *const kReusablePinPurple;

@interface EPAnnotation : NSObject <MKAnnotation>

@property (nonatomic, unsafe_unretained, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *subtitle;

@property (nonatomic, unsafe_unretained) MKPinAnnotationColor pinColor;

- (instancetype) initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates
                               title:(NSString *)paramName
                            subTitle:(NSString *)paramRestNumber;

+ (NSString *) reusableIdentifierforPinColor:(MKPinAnnotationColor)paramColor;

@end