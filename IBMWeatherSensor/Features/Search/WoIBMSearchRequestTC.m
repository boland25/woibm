//
//  WoIBMSearchRequestTC.m
//  IBMWeatherSensor
//
//  Created by boland on 8/20/14.
//  Copyright (c) 2014 mallocmedia. All rights reserved.
//

#import "WoIBMSearchRequestTC.h"
#import <CoreLocation/CoreLocation.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "WoIBMDataController.h"
#import "WoIBMForecastVC.h"
#import "WoIBMGooglePlace.h"
#import "WOIBMGoogleTerms.h"
#import "SAYTManager.h"

static NSString *const kSearchRequestCellIdentifier = @"kSearchRequestCellIdentifier";

typedef NS_ENUM (NSInteger, WoIBMSearchAddressTableViewSection) {
    WoIBMSearchAddressTableViewSectionCurrentLocation = 0,
    WoIBMSearchAddressTableViewSectionSearchAsYouTypeResult
};

@interface WoIBMSearchRequestTC () <CLLocationManagerDelegate, UISearchBarDelegate>

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) BOOL locationUpdated;
@property (nonatomic, strong) NSArray *predictionsArray;

@end

@implementation WoIBMSearchRequestTC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.locationUpdated = NO;
    [self configureSearchAsYouType];
    
}

- (void)selectCurrentLocation
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    [self showActivityIndicator];
}

- (NSString *)setLocationFromPrediction:(WoIBMGooglePlace *)place
{
    WoIBMGoogleTerms *cityTerms = place.terms[place.terms.count-3];
    WoIBMGoogleTerms *stateTerms = place.terms[place.terms.count-2];
    return [[WoIBMDataController sharedData] createCityString:stateTerms.value city:cityTerms.value];
    
}


- (void)configureForecastView:(NSString *)cityStateString
{
    WoIBMForecastVC *forecastVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WoIBMForecastVC"];
    forecastVC.cityStateString = cityStateString;
    [self.navigationController pushViewController:forecastVC animated:YES];
}

- (void)configureSearchAsYouType
{
    [SAYTManager sharedManager].successBlock = ^void (NSArray *predictions) {
        self.predictionsArray = predictions;
        [self.tableView reloadData];
    };
    [SAYTManager sharedManager].failureBlock = ^void (NSArray *predictions) {
        [self resetToDefault];
    };
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == WoIBMSearchAddressTableViewSectionCurrentLocation) {
        return 1;
    }else {
        return self.predictionsArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSearchRequestCellIdentifier forIndexPath:indexPath];
    if (indexPath.section == WoIBMSearchAddressTableViewSectionCurrentLocation) {
        cell.textLabel.text = @"Use Current Location";
    } else {
        WoIBMGooglePlace *place = self.predictionsArray[indexPath.row];
        cell.textLabel.text = place.gaDescription;
    }

    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == WoIBMSearchAddressTableViewSectionSearchAsYouTypeResult) {
       //TODO: pull the info out of the object and use that instewad of current location
        [self configureForecastView:[self setLocationFromPrediction:self.predictionsArray[indexPath.row]]];
    }
    else if (indexPath.section == WoIBMSearchAddressTableViewSectionCurrentLocation)
    {
        [self selectCurrentLocation];
    }

    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:location completionHandler: ^(NSArray *placemarks, NSError *error) {
        if (error) {
            [self didFailToObtainLocation];
        }
        else {
            if (!self.locationUpdated) {
                CLPlacemark *placemark = [placemarks lastObject];
                [self configureForecastView:[self didObtainLocationPlacemark:placemark]];
                self.locationUpdated = YES;
            }
           
        
        }
        [self.locationManager stopUpdatingLocation];
        [self hideActivityIndicator];
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self didFailToObtainLocation];
    [self.locationManager stopUpdatingLocation];
    [self hideActivityIndicator];
}

- (NSString *)didObtainLocationPlacemark:(CLPlacemark *)placemark
{
    NSDictionary *addressDict = placemark.addressDictionary;
    return [[WoIBMDataController sharedData] createCityString:addressDict[@"State"] city:addressDict[@"City"]];
}

- (void)didFailToObtainLocation
{
    //TODO: show errors in window
    
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

- (void)resetToDefault
{
    [self.tableView reloadData];
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    [[SAYTManager sharedManager] setAddressInput:self.searchBar.text];
    if (range.length == 1 && range.location == 0) {
        [[SAYTManager sharedManager] cancel];
        [self resetToDefault];
    }
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //NOTE: this handles what happens when a user clears the text, its stops and clears the timer
    if ([searchText isEqualToString:@""]) {
        [self resetToDefault];
    }
}

@end
