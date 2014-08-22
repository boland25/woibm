//
//  WoIBMForecast.m
//  IBMWeatherSensor
//
//  Created by boland on 8/20/14.
//  Copyright (c) 2014 mallocmedia. All rights reserved.
//

#import "WoIBMForecast.h"
#import "WoIBMForecastDay.h"

@implementation WoIBMForecast

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"forecastDay": @"forecastday"};
}

+ (NSValueTransformer *)forecastDayJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[WoIBMForecastDay class]];
}


@end
