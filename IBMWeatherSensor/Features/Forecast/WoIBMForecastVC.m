//
//  WoIBMForecastVC.m
//  IBMWeatherSensor
//
//  Created by boland on 8/20/14.
//  Copyright (c) 2014 mallocmedia. All rights reserved.
//

#import "WoIBMForecastVC.h"
#import "WoIBMDataController.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface WoIBMForecastVC ()

@property (nonatomic, strong) WoIBMForecast *forecast;

@end

@implementation WoIBMForecastVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)getForecast:(NSString *)cityStateString
{
    [self showActivityIndicator];
    [[WoIBMDataController sharedData] getForecast:cityStateString success:^(WoIBMForecast *forecast) {
        [self configureForecastView];
        [self hideActivityIndicator];
    } failure:^(WoIBMError *error) {
        //TODO: Show error
        [self hideActivityIndicator];
    }];
}

- (void)configureForecastView
{
    
}

#pragma mark - Activity Indictators

- (void)showActivityIndicator
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
}

- (void)hideActivityIndicator
{
    [SVProgressHUD dismiss];
}



@end
