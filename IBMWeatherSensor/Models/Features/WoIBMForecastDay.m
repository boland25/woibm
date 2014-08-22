//
//  WoIBMForecastDay.m
//  IBMWeatherSensor
//
//  Created by boland on 8/20/14.
//  Copyright (c) 2014 mallocmedia. All rights reserved.
//

#import "WoIBMForecastDay.h"

@implementation WoIBMForecastDay

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"forecastDescription" : @"fcttext",
             @"icon_url" : @"icon_url",
             @"title"    : @"title"
            };
}

@end
