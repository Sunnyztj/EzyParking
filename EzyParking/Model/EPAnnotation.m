//
//  EPAnnotation.m
//  EzyParking
//
//  Created by Ben Zhang on 10/23/14.
//  Copyright (c) 2014 Sunny Zhou. All rights reserved.
//

#import "EPAnnotation.h"

NSString *const kReusablePinRed = @"Red";
NSString *const kReusablePinGreen = @"Green";
NSString *const kReusablePinPurple = @"Purple";

@implementation EPAnnotation

+ (NSString *) reusableIdentifierforPinColor:(MKPinAnnotationColor)paramColor{
    NSString *result = nil;
    switch (paramColor){
        case MKPinAnnotationColorRed:{
            result = kReusablePinRed;
            break;
        }
        case MKPinAnnotationColorGreen:{
            result = kReusablePinGreen;
            break;
        }
        case MKPinAnnotationColorPurple:{
            result = kReusablePinPurple;
            break;
        }
    }
    return result;
}

- (instancetype) initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates
                               title:(NSString *)paramName
                            subTitle:(NSString *)paramRestNumber{
    self = [super init];
    if (self != nil){
        _coordinate = paramCoordinates;
        _title = paramName;
        _subtitle = paramRestNumber;
        _pinColor = MKPinAnnotationColorGreen;
        
    }
    return self;
}
@end
