//
//  WoIBMForecastVC.h
//  IBMWeatherSensor
//
//  Created by boland on 8/20/14.
//  Copyright (c) 2014 mallocmedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WoIBMForecast.h"

@interface WoIBMForecastVC : UIViewController

@property (nonatomic, copy) NSString *cityStateString;

- (void)getForecast:(NSString *)cityStateString;

@end
