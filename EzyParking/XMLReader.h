//
//  XMLReader.h
//  EzyParking
//
//  Created by Ben Zhang on 10/23/14.
//  Copyright (c) 2014 Sunny Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLReader : NSObject

+ (NSDictionary *)dictionaryForXMLData:(NSData *)data error:(NSError **)errorPointer;
+ (NSDictionary *)dictionaryForXMLString:(NSString *)string error:(NSError **)errorPointer;

@end