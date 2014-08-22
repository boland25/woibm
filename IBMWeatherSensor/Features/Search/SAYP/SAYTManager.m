//
//  SAYTManager.m
//  IBMWeatherSensor
//
//  Created by boland on 8/21/14.
//  Copyright (c) 2014 mallocmedia. All rights reserved.
//

#import "SAYTManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "WoIBMGooglePlace.h"
#import "NSDictionary+NilValue.h"

static CGFloat const WoIBMTypingCheckInterval = 0.35;
static NSString *const GooglePlacesAPIURLString = @"https://maps.googleapis.com/maps/api/place/autocomplete/json";
//API Key registered with the places api
static NSString *const GooglePlacesAPIKey = @"AIzaSyCnwAOO6pXBzt_CGDWgd-Tcvs1RSM-5Si4";

@interface SAYTManager ()

@property (nonatomic, assign) BOOL isTimerRun;
@property (nonatomic, strong) NSTimer *typingTimer;
@property (nonatomic, copy) NSString *searchFieldText;
@property (nonatomic, copy) NSString *typedResultToCompare;

@end

@implementation SAYTManager

+ (instancetype)sharedManager
{
    static SAYTManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[SAYTManager alloc] init];
    });
    return sharedManager;
}

#pragma mark - Public Methods

- (void)cancel
{
    [self stopTypingTimer];
}

- (void)setAddressInput:(NSString *)addressInput
{
    self.searchFieldText = addressInput;
    [self startTypingTimer];
}

#pragma mark - Private Methods

- (BOOL)isTimerRunning
{
    return self.isTimerRun;
}

- (void)setIsTimerRunning:(BOOL)isTimerRunning
{
    self.isTimerRun = isTimerRunning;
}

- (void)startTypingTimer
{
    if (self.typingTimer) {
        [self stopTypingTimer];
    }
    self.typingTimer = [NSTimer scheduledTimerWithTimeInterval:WoIBMTypingCheckInterval target:self selector:@selector(checkForTypingGapsAndSendSearchRequest:) userInfo:nil repeats:YES];
    [self setIsTimerRunning:YES];
}

- (void)stopTypingTimer
{
    [self.typingTimer invalidate];
    [self setIsTimerRunning:NO];
    self.typingTimer = nil;
}

- (void)checkForTypingGapsAndSendSearchRequest:(id)sender
{
    NSLog(@"timer is started");
    if (self.typedResultToCompare) {
        if ([self.typedResultToCompare isEqualToString:self.searchFieldText] && self.typedResultToCompare.length > 0) {
            [self getAddressResults:self.typedResultToCompare];
            [self stopTypingTimer];
        }
    }
    self.typedResultToCompare = self.searchFieldText;
}

#pragma mark - API Methods

- (void)getAddressResults:(NSString *)queryString
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:GooglePlacesAPIURLString parameters:[self createParams:queryString] success: ^(AFHTTPRequestOperation *operation, id responseObject) {
        //parse the locations stuff
      //  NSLog(@"respsonse Object %@", responseObject);
        if (self.successBlock) {
            NSArray *predictions = [WoIBMGooglePlace arrayFromJSONArray:[(NSDictionary *)responseObject contains : @"predictions"]];
            self.successBlock(predictions);
        }
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        // Fail silently
        //TODO: if this does fail, I probably need to make sure there is a fail block to trigger to put the view back
    }];
}

- (NSDictionary *)createParams:(NSString *)queryString
{
    return @{
             @"input":queryString,
             @"key" : GooglePlacesAPIKey
             };
}



@end
