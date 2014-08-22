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
#import "WoIBMForecastCell.h"

static NSString *const WoIBMForecastCollectionCell = @"WoIBMForecastCell";

@interface WoIBMForecastVC ()

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) WoIBMForecast *forecast;

@end

@implementation WoIBMForecastVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getForecast:self.cityStateString];
}

- (void)getForecast:(NSString *)cityStateString
{
    [self showActivityIndicator];
    [[WoIBMDataController sharedData] getForecast:cityStateString success:^(WoIBMForecast *forecast) {
        self.forecast = forecast;
        [self configureForecastView];
        [self hideActivityIndicator];
    } failure:^(WoIBMError *error) {
        //TODO: Show error
        [self hideActivityIndicator];
    }];
}

- (void)configureForecastView
{
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource methods

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WoIBMForecastCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:WoIBMForecastCollectionCell forIndexPath:indexPath];
    [cell layoutWithForecastDay:self.forecast.forecastDay[indexPath.row]];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.forecast.forecastDay count];
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
