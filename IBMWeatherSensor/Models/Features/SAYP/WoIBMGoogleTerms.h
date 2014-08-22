//
//  WoIBMGoogleTerms.h
//  IBMWeatherSensor
//
//  Created by boland on 8/22/14.
//  Copyright (c) 2014 mallocmedia. All rights reserved.
//

#import "WoIBMModel.h"

@interface WoIBMGoogleTerms : WoIBMModel

@property (nonatomic, copy) NSString *value;
@property (nonatomic, strong) NSNumber *offset;

@end
