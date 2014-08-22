//
//  WoIBMModel.h
//  IBMWeatherSensor
//
//  Created by boland on 8/20/14.
//  Copyright (c) 2014 mallocmedia. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface WoIBMModel : MTLModel <MTLJSONSerializing>

+ (instancetype)modelFromJSONDictionary:(NSDictionary *)JSONDictionary;
+ (NSArray *)arrayFromJSONArray:(NSArray *)array;

@end
