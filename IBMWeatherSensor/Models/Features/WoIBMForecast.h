//
//  WoIBMForecast.h
//  IBMWeatherSensor
//
//  Created by boland on 8/20/14.
//  Copyright (c) 2014 mallocmedia. All rights reserved.
//

#import "WoIBMModel.h"

@interface WoIBMForecast : WoIBMModel

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, copy) NSArray *forecastDay;

@end
