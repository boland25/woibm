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

@interface WoIBMDataController : NSObject

+ (instancetype)sharedData;

- (void)getForecast:(CLPlacemark *)placemark success:(void (^)(NSArray *feeds))success failure:(void (^)(WoIBMError *error))failure;


@end
