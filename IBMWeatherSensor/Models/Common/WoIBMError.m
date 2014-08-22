//
//  WoIBMError.m
//  IBMWeatherSensor
//
//  Created by boland on 8/20/14.
//  Copyright (c) 2014 mallocmedia. All rights reserved.
//

#import "WoIBMError.h"

@implementation WoIBMError

+ (WoIBMError *)createError:(NSString *)message {
	return [WoIBMError modelFromJSONDictionary:@{ @"message":message }];
}

@end
