//
//  WoIMBDataController.m
//  IBMWeatherSensor
//
//  Created by boland on 8/20/14.
//  Copyright (c) 2014 mallocmedia. All rights reserved.
//

#import "WoIBMDataController.h"
#import "WoIBMNetworking.h"
#import "WoIBMConstants.h"
#import "WoiBMError.h"

@implementation WoIBMDataController

+ (instancetype)sharedData {
	static WoIBMDataController *sharedData = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
	    sharedData = [[WoIBMDataController alloc] init];
	});
    
	return sharedData;
}

- (void)getForecast:(NSString *)placemark success:(void (^)(WoIBMForecast *forecast))success failure:(void (^)(WoIBMError *))failure{
    
    NSString *forcastEndpoint = [self createForecastEndpoint:placemark];
    [WoIBMNetworking requestWithEndpoint:forcastEndpoint method:WoIBMRequestMethodGET params:nil success: ^(id responseObject){
        WoIBMForecast *forecast = [WoIBMForecast modelFromJSONDictionary:responseObject[@"forecast"][@"txt_forecast"]];
       // NSLog(@"responseObject %@", forecast);
       // NSLog(@"txt forecast %@", responseObject[@"forecast"][@"txt_forecast"]);
        if (success) {
            success(forecast);
        }
	} failure:failure];
}

- (NSString *)createForecastEndpoint:(NSString *)placemark
{
    //@"4350d102eb198b7a/forecast/q/.json";
    return [NSString stringWithFormat:@"%@%@.json", WOIBM_FORECAST, placemark];
}

@end
