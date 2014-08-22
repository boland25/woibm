//
//  WoIBMModel.m
//  IBMWeatherSensor
//
//  Created by boland on 8/20/14.
//  Copyright (c) 2014 mallocmedia. All rights reserved.
//

#import "WoIBMModel.h"

@implementation WoIBMModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{};
}

+ (instancetype)modelFromJSONDictionary:(NSDictionary *)JSONDictionary {
	NSError *error = nil;
	return [MTLJSONAdapter modelOfClass:[self class] fromJSONDictionary:JSONDictionary error:&error];
}

+ (NSArray *)arrayFromJSONArray:(NSArray *)array {
	NSValueTransformer *valueTransformer = [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[self class]];
	NSMutableArray *objects = [valueTransformer transformedValue:array];
    
	return objects;
}

@end
