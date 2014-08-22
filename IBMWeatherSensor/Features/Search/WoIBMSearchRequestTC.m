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

static NSString *const kSearchRequestCellIdentifier = @"kSearchRequestCellIdentifier";

typedef NS_ENUM (NSInteger, WoIBMSearchAddressTableViewSection) {
    WoIBMSearchAddressTableViewSectionCurrentLocation = 0,
    WoIBMSearchAddressTableViewSectionSearchAsYouTypeResult
};

@interface WoIBMSearchRequestTC () <CLLocationManagerDelegate>

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) BOOL locationUpdated;

@end

@implementation WoIBMSearchRequestTC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.locationUpdated = NO;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSearchRequestCellIdentifier forIndexPath:indexPath];
    if (indexPath.section == WoIBMSearchAddressTableViewSectionCurrentLocation) {
        cell.textLabel.text = @"Use Current Location";
    }

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == WoIBMSearchAddressTableViewSectionSearchAsYouTypeResult) {
       //TODO: pull the info out of the object and use that instewad of current location
    }
    else if (indexPath.section == WoIBMSearchAddressTableViewSectionCurrentLocation)
    {
        [self selectCurrentLocation];
    }

    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)selectCurrentLocation
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    [self showActivityIndicator];
}

- (void)getForecast:(CLPlacemark *)placemark
{
    [[WoIBMDataController sharedData] getForecast:placemark success:^(NSArray *feeds) {
        NSLog(@"got a successful forecast back");
    } failure:^(WoIBMError *error) {
        //TODO: Show error
    }];
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
                [self didObtainLocationPlacemark:placemark];
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
    NSLog(@"error %@", error.localizedDescription);
    [self.locationManager stopUpdatingLocation];
    [self hideActivityIndicator];
}

- (void)didObtainLocationPlacemark:(CLPlacemark *)placemark
{
    NSDictionary *addressDict = placemark.addressDictionary;
    NSLog(@"address Dict %@", addressDict);
    //placemark.location.coordinate;
    [self getForecast:placemark];
   // [self configureForecastView];
}

- (void)didFailToObtainLocation
{
    //TODO: show errors in window
    
}

- (void)configureForecastView
{
    WoIBMForecastVC *forecastVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WoIBMForecastVC"];

    [self.navigationController pushViewController:forecastVC animated:YES];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
