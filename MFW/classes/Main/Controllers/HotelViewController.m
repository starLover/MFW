//
//  HotelViewController.m
//  MFW
//
//  Created by wanghongxiao on 16/3/21.
//
//

#import "HotelViewController.h"
#import "HotelMapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface HotelViewController ()<CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
    CLGeocoder *_geocoder;
}

- (IBAction)locationAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *cityBtn;

- (IBAction)mapAction:(id)sender;

@end

@implementation HotelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"订酒店";
    [self showBackBtn];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _geocoder = [[CLGeocoder alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)locationAction:(id)sender {
    if (!([CLLocationManager locationServicesEnabled])) {
        NSLog(@"用户位置服务不可用");
    }
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [_locationManager requestWhenInUseAuthorization];
    } else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse){
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        CLLocationDistance distance = 100.0;
        _locationManager.distanceFilter = distance;
        [_locationManager startUpdatingLocation];
        [self.cityBtn setTitle:@"定位中..." forState:UIControlStateNormal];
    }
    
}

#pragma mark  -------- CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:[NSNumber numberWithDouble:coordinate.latitude] forKey:@"lat"];
    [userDefault setValue:[NSNumber numberWithDouble:coordinate.longitude] forKey:@"lng"];
    
    NSLog(@"纬度:%f 经度:%f 海拔:%f 航向:%f 行走速度:%f", coordinate.latitude, coordinate.longitude, location.altitude, location.course, location.speed);
    
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placeMark = [placemarks lastObject];
        
        [[NSUserDefaults standardUserDefaults] setValue:placeMark.addressDictionary[@"City"] forKey:@"city"];
        //保存
        [userDefault synchronize];
        [self.cityBtn setTitle:placeMark.addressDictionary[@"City"] forState:UIControlStateNormal];
    }];
    //如果不需要使用定位服务的时候,及时关闭定位服务
    [manager stopUpdatingLocation];

}


- (IBAction)mapAction:(id)sender {
    HotelMapViewController *hotelMapVC = [[HotelMapViewController alloc] init];
    [self.navigationController pushViewController:hotelMapVC animated:YES];
}
@end
