//
//  WoIBMGooglePlace.h
//  IBMWeatherSensor
//
//  Created by boland on 8/21/14.
//  Copyright (c) 2014 mallocmedia. All rights reserved.
//

#import "WoIBMModel.h"

@interface WoIBMGooglePlace : WoIBMModel

@property (nonatomic, copy) NSString *gaDescription;
@property (nonatomic, copy) NSString *gaID;
@property (nonatomic, strong) NSArray *terms;

@end
