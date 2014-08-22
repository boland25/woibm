//
//  SAYTManager.h
//  IBMWeatherSensor
//
//  Created by boland on 8/21/14.
//  Copyright (c) 2014 mallocmedia. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SAYTReturnAddressActionBlock)(NSArray *);

@interface SAYTManager : NSObject

@property (nonatomic, copy) SAYTReturnAddressActionBlock successBlock;
@property (nonatomic, copy) SAYTReturnAddressActionBlock failureBlock;

- (BOOL)isTimerRunning;
- (void)cancel;
- (void)setAddressInput:(NSString *)addressInput;
+ (instancetype)sharedManager;


@end
