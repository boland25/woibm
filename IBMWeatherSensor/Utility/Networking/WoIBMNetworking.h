//
//  WoIBMNetworking.h
//  IBMWeatherSensor
//
//  Created by boland on 8/20/14.
//  Copyright (c) 2014 mallocmedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WoIBMError.h"
#import "AFHTTPSessionManager.h"

static NSString *const GET  = @"GET";
static NSString *const POST = @"POST";

typedef NS_ENUM (NSInteger, WoIBMRequestHandlerMethod)
{
	WoIBMRequestMethodPOST,
	WoIBMRequestMethodGET,
	WoIBMRequestMethodDELETE,
	WoIBMRequestMethodPUT
};


@interface WoIBMNetworking : NSObject

- (WoIBMError *)createErrorModelFromResponse:(id)errorResponse error:(NSError *)error;

+ (void)requestWithEndpoint:(NSString *)endpoint method:(WoIBMRequestHandlerMethod)method params:(NSDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(WoIBMError *error))failure;


@end
