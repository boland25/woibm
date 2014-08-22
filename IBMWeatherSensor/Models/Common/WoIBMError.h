//
//  WoIBMError.h
//  IBMWeatherSensor
//
//  Created by boland on 8/20/14.
//  Copyright (c) 2014 mallocmedia. All rights reserved.
//

#import "WoIBMModel.h"

@interface WoIBMError : WoIBMModel

@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) NSNumber *code;
@property (nonatomic, copy) NSString *errorType;
@property (nonatomic, strong) NSError *error;

@end
