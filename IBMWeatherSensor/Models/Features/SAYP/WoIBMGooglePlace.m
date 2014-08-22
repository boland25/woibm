//
//  WoIBMGooglePlace.m
//  IBMWeatherSensor
//
//  Created by boland on 8/21/14.
//  Copyright (c) 2014 mallocmedia. All rights reserved.
//

#import "WoIBMGooglePlace.h"
#import "WoIBMGoogleTerms.h"

@implementation WoIBMGooglePlace

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"gaDescription":@"description",
             @"gaID":@"id"
             };
}

+ (NSValueTransformer *)termsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[WoIBMGoogleTerms class]];
}

@end
