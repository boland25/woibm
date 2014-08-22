//
//  WoIBMForecastCell.h
//  IBMWeatherSensor
//
//  Created by boland on 8/22/14.
//  Copyright (c) 2014 mallocmedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WoIBMForecastDay.h"

@interface WoIBMForecastCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel *forecastDescription;
@property (nonatomic, weak) IBOutlet UILabel *title;

- (void)layoutWithForecastDay:(WoIBMForecastDay *)forecastDay;

@end
