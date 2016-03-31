//
//  HotelViewController.m
//  MFW
//
//  Created by wanghongxiao on 16/3/21.
//
//

#import "HotelViewController.h"
#import "HotelMapViewController.h"
#import "LZ_Mine_ResignViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ZFChooseTimeViewController.h"


@interface HotelViewController ()<CLLocationManagerDelegate, UIGestureRecognizerDelegate>
{
    CLLocationManager *_locationManager;
    CLGeocoder *_geocoder;
}


- (IBAction)locationAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *cityBtn;
- (IBAction)managerHotel:(id)sender;

- (IBAction)mapAction:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *startDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *endDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *startweekLabel;
@property (strong, nonatomic) IBOutlet UILabel *endweekLabel;
@property (strong, nonatomic) IBOutlet UILabel *allTimeLabel;

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
    //添加触摸手势
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
    tap.delegate = self;
    self.startDateLabel.userInteractionEnabled = YES;
    [self.startDateLabel addGestureRecognizer:tap];
}

- (void)handleSingleTap{
    ZFChooseTimeViewController *zmVC = [[ZFChooseTimeViewController alloc] init];
    __weak typeof(self)weekSelf = self;
    
    [zmVC backDate:^(NSArray *goDate, NSArray *backDate) {
        weekSelf.startDateLabel.text = [NSString stringWithFormat:@"%@", [goDate componentsJoinedByString:@"-"]];
        weekSelf.endDateLabel.text = [NSString stringWithFormat:@"%@", [backDate componentsJoinedByString:@"-"]];
        
        //计算天数差
        NSCalendar *gregoria = [[NSCalendar alloc]
                                 initWithCalendarIdentifier:NSGregorianCalendar];
        [gregoria setFirstWeekday:2];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *fromDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@ 00:00:00", weekSelf.startDateLabel.text]];
        NSDate *toDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@ 00:00:00", weekSelf.endDateLabel.text]];
        NSDateComponents *dayComponents = [gregoria components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
        self.allTimeLabel.text = [NSString stringWithFormat:@"%ld天", (long)dayComponents.day];
        //计算星期几
        NSDateComponents *_comps = [[NSDateComponents alloc] init];
        [_comps setDay:[goDate[2] integerValue]];
        [_comps setMonth:[goDate[1] integerValue]];
        [_comps setYear:[goDate[0] integerValue]];
        NSCalendar *gregorian = [[NSCalendar alloc]                                 initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *_date = [gregorian dateFromComponents:_comps];
        NSDateComponents *weekdayComponents =
        [gregorian components:NSWeekdayCalendarUnit fromDate:_date];
        NSInteger _weekday = [weekdayComponents weekday] - 1;
        self.startweekLabel.text = [self getWeek:_weekday];
        
        //结束日期
        NSDateComponents *_comps1 = [[NSDateComponents alloc] init];
        [_comps1 setDay:[backDate[2] integerValue]];
        [_comps1 setMonth:[backDate[1] integerValue]];
        [_comps1 setYear:[backDate[0] integerValue]];
        NSCalendar *gregorian1 = [[NSCalendar alloc]                                 initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *_date1 = [gregorian1 dateFromComponents:_comps1];
        NSDateComponents *weekdayComponents1 =
        [gregorian components:NSWeekdayCalendarUnit fromDate:_date1];
        NSInteger _weekday1 = [weekdayComponents1 weekday] - 1;
        self.endweekLabel.text = [self getWeek:_weekday1];
    }];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:zmVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (NSString *)getWeek:(NSInteger)week{
    NSString *myWeek;
    switch (week) {
        case 1:
            myWeek = @"周一";
            break;
        case 2:
            myWeek = @"周二";
            break;
        case 3:
            myWeek = @"周三";
            break;
        case 4:
            myWeek = @"周四";
            break;
        case 5:
            myWeek = @"周五";
            break;
        case 6:
            myWeek = @"周六";
            break;
        case 7:
            myWeek = @"周日";
            break;
            
        default:
            break;
    }
    return myWeek;
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


- (IBAction)managerHotel:(id)sender {
    LZ_Mine_ResignViewController *lzVC = [[LZ_Mine_ResignViewController alloc] init];
    [self.navigationController pushViewController:lzVC animated:YES];
}

- (IBAction)mapAction:(id)sender {
    HotelMapViewController *hotelMapVC = [[HotelMapViewController alloc] init];
    hotelMapVC.cityName = self.cityBtn.titleLabel.text;
    [self.navigationController pushViewController:hotelMapVC animated:YES];
}
@end
