//
//  HotelViewController.m
//  MFW
//
//  Created by wanghongxiao on 16/3/21.
//
//

#import "HotelViewController.h"
#import "HotelMapViewController.h"
//#import <AMapLocationKit/AMapLocationKit.h>

@interface HotelViewController ()


- (IBAction)locationAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *cityBtn;
//@property(nonatomic, strong) AMapLocationManager *locationManager;
- (IBAction)mapAction:(id)sender;

@end

@implementation HotelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"订酒店";
    [self showBackBtn];
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
//    self.locationManager = [[AMapLocationManager alloc] init];
//    // 带逆地理信息的一次定位（返回坐标和地址信息）
//    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
//    //   定位超时时间，可修改，最小2s
//    self.locationManager.locationTimeout = 3;
//    //   逆地理请求超时时间，可修改，最小2s
//    self.locationManager.reGeocodeTimeout = 3;
//    
//    // 带逆地理（返回坐标和地址信息）
//    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
//        
//        if (error)
//        {
//            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
//            
//            if (error.code == AMapLocationErrorLocateFailed)
//            {
//                return;
//            }
//        }
//        NSLog(@"location:%@", location);
//        
//        if (regeocode)
//        {
//            NSLog(@"reGeocode:%@", regeocode);
//            [self.cityBtn setTitle:regeocode.city forState:UIControlStateNormal];
//        }
//    }];
}
- (IBAction)mapAction:(id)sender {
    HotelMapViewController *hotelMapVC = [[HotelMapViewController alloc] init];
    [self.navigationController pushViewController:hotelMapVC animated:YES];
}
@end
