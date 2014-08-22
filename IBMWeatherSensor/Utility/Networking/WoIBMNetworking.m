//
//  WoIBMNetworking.m
//  IBMWeatherSensor
//
//  Created by boland on 8/20/14.
//  Copyright (c) 2014 mallocmedia. All rights reserved.
//

#import "WoIBMNetworking.h"
#import "WOIBMConstants.h"
#import "NSDictionary+NilValue.h"

@implementation WoIBMNetworking

+ (void)requestWithEndpoint:(NSString *)endpoint
                     method:(WoIBMRequestHandlerMethod)method
                     params:(NSDictionary *)params
                    success:(void (^)(id))success
                    failure:(void (^)(WoIBMError *))failure {
	[[WoIBMNetworking alloc] initRequestWithEndpoint:endpoint method:method params:params success:success failure:failure];
}

- (void)initRequestWithEndpoint:(NSString *)endpoint method:(WoIBMRequestHandlerMethod)method params:(NSDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(WoIBMError *error))failure {
	AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:WOIBM_BASE_URL]];
    
	manager.requestSerializer = [AFHTTPRequestSerializer serializer];
	manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
	NSMutableURLRequest *request = [self requestWithEndpoint:endpoint method:[self requestMethodString:method] params:params sessionManager:manager];
    
    
	NSLog(@"Request: %@ \n%@\n", request.HTTPMethod, request.URL.absoluteString);
    
	if (request.HTTPBody) {
		NSString *postBodyStr = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
        
		NSLog(@"Body: %@", postBodyStr);
	}
	__block NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler: ^(NSURLResponse *__unused response, id responseObject, NSError *error) {
	    if (error || ([responseObject isKindOfClass:[NSDictionary class]] && [responseObject hasValueForKey:@"errorMessage"])) {
	        if (failure) {
	            NSLog(@"Response(failure):\n%@\nerror:%@\n", responseObject, error);
	            failure([self createErrorModelFromResponse:responseObject error:error]);
			}
		}
	    else {
	        if (success) {
	            NSLog(@"Response(success):\n%@\n", responseObject);
	            success(responseObject);
			}
		}
	}];
    
	[task resume];
}

- (NSMutableURLRequest *)requestWithEndpoint:(NSString *)endpoint method:(NSString *)method params:(id)params sessionManager:(AFHTTPSessionManager *)sessionManager {
	NSMutableURLRequest *request = [sessionManager.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:endpoint relativeToURL:sessionManager.baseURL] absoluteString] parameters:params error:nil];
    
	[request setValue:@"application/rss+xml" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/rss+xml" forHTTPHeaderField:@"Content-Type"];
    
	return request;
}

#pragma mark Private methods

- (NSString *)requestMethodString:(WoIBMRequestHandlerMethod)method {
	switch (method) {
		case WoIBMRequestMethodDELETE:
			return @"DELETE";
			break;
            
		case WoIBMRequestMethodGET:
			return @"GET";
			break;
            
		case WoIBMRequestMethodPOST:
			return @"POST";
			break;
            
		case WoIBMRequestMethodPUT:
			return @"PUT";
			break;
            
		default:
			break;
	}
}

- (WoIBMError *)createErrorModelFromResponse:(id)errorResponse error:(NSError *)error {
	WoIBMError *customError = [WoIBMError modelFromJSONDictionary:[self transformErrorJSON:errorResponse ? errorResponse:@{}]];
	customError.error = error;
	return customError;
}

- (NSDictionary *)transformErrorJSON:(NSDictionary *)dict {
	return @{
             @"errorType" : [dict contains:@"status"],
             @"message"   : [dict contains:@"message"],
             };
}


@end
