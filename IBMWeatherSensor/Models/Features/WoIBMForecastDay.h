//
//  WoIBMForecastDay.h
//  IBMWeatherSensor
//
//  Created by boland on 8/20/14.
//  Copyright (c) 2014 mallocmedia. All rights reserved.
//

#import "WoIBMModel.h"

@interface WoIBMForecastDay : WoIBMModel

@property (nonatomic, copy) NSString *forecastDescription;
@property (nonatomic, copy) NSString *icon_url;
@property (nonatomic, copy) NSString *title;

@end
