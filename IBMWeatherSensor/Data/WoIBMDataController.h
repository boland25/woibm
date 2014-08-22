//
//  WoIMBDataController.h
//  IBMWeatherSensor
//
//  Created by boland on 8/20/14.
//  Copyright (c) 2014 mallocmedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WoIBMError.h"
#import <CoreLocation/CoreLocation.h>
#import "WoIBMForecast.h"

@interface WoIBMDataController : NSObject

+ (instancetype)sharedData;

- (void)getForecast:(NSString *)placemark success:(void (^)(WoIBMForecast *forecast))success failure:(void (^)(WoIBMError *error))failure;

- (NSString *)createCityString:(NSString *)state city:(NSString *)city;

@end
