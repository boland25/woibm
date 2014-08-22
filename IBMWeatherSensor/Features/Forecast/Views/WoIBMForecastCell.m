//
//  WoIBMForecastCell.m
//  IBMWeatherSensor
//
//  Created by boland on 8/22/14.
//  Copyright (c) 2014 mallocmedia. All rights reserved.
//

#import "WoIBMForecastCell.h"
#import "UIColor+RandomColor.h"

@implementation WoIBMForecastCell

- (void)layoutWithForecastDay:(WoIBMForecastDay *)forecastDay
{
    self.title.text = forecastDay.title;
    self.forecastDescription.text = forecastDay.forecastDescription;
    //todo: layout info here
    NSLog(@"a forecast day %@", forecastDay);
    self.backgroundColor = [UIColor randomColor];
}

@end
