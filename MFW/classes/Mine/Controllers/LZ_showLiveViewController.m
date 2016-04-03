//
//  LZ_showLiveViewController.m
//  MFW
//
//  Created by scjy on 16/3/30.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import "LZ_showLiveViewController.h"
#import "YMTextView.h"
#import <CoreLocation/CoreLocation.h>
#import "LZBuzz.h"
#import "LZBuzzTool.h"
#import "LZ_DetailTableViewController.h"

@interface LZ_showLiveViewController ()//<CLLocationManagerDelegate>
{
    /** 创建定位所需要的类的实例对象 */
    CLLocationManager *_locationManager;
}
@property (nonatomic ,strong) CLGeocoder *geocoder;
@property (nonatomic, strong) CLPlacemark *placeMark;
@property (nonatomic, weak) YMTextView *textView;

@end

@implementation LZ_showLiveViewController
- (CLGeocoder *)geocoder
{
    if (!_geocoder) {
        self.geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    _locationManager = [[CLLocationManager alloc] init];
    if (![CLLocationManager locationServicesEnabled]) {
        fSLog(@"定位服务当前可能尚未打开，请设置打开！");
    }
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [_locationManager requestWhenInUseAuthorization];
    }
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        //设置代理
        _locationManager.delegate = self;
        //设置定位精度,精度越高越耗电
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //定位频率，每隔多少米定位一次
        CLLocationDistance distance = 10.0;
        _locationManager.distanceFilter = distance;
        //启动跟踪定位
        [_locationManager startUpdatingLocation];
    }

    self.tabBarController.tabBar.hidden  =  YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(makeInFmdb)];
    [self setupTextView];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    [self.geocoder reverseGeocodeLocation:[locations lastObject] completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        self.placeMark = [placemarks firstObject];
        
    }];
}

-(void)setupTextView {
    YMTextView *textView = [[YMTextView alloc] init];
    textView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    textView.backgroundColor = [UIColor lightGrayColor];
    textView.font = [UIFont fontWithName:@"FZLTHK--GBK1-0" size:25];
    //设置占位文字
    textView.placeholder = @"发一条NB的嗡嗡";
    [self.view addSubview:textView];
    self.textView = textView;

}
- (void)makeInFmdb{
    if (self.textView.hasText) {
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM-dd HH:mm"];
        
        LZBuzz *buzz = [[LZBuzz alloc] init];
        buzz.time = [formatter stringFromDate:date];
        buzz.content = self.textView.text;
        buzz.locality = self.placeMark.locality;
        buzz.name = self.placeMark.name;
        [LZBuzzTool addBuzz:buzz];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


@end



























