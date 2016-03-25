//
//  GDViewController.m
//  MFW
//
//  Created by scjy on 16/3/25.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import "GDViewController.h"
#import <MAMapKit/MAMapKit.h>

@interface GDViewController ()<MAMapViewDelegate>
{
    MAMapView *_mapView;
}
@end

@implementation GDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackBtn];
    [MAMapServices sharedServices].apiKey = kGDKey;
    _mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    //定位,YES为打开定位，NO为关闭定位
    _mapView.showsUserLocation = YES;
    [self.view.superview addSubview:_mapView];
    //地图跟着位置移动
    [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    [_mapView setZoomLevel:16.1 animated:YES];
}
//- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
//    if (updatingLocation) {
//        NSLog(@"latitude:%f,lng:%f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
//    }
//}
- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    MAAnnotationView *view = views[0];
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]]) {
        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc]init];
        pre.fillColor = [UIColor colorWithRed:0.9 green:0.1 blue:0.1 alpha:0.3];
        pre.strokeColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.9 alpha:1.0];
        pre.image = [UIImage imageNamed:@"ic_topbar_location"];
        pre.lineWidth = 3;
        pre.lineDashPattern = @[@6,@3];
        [_mapView updateUserLocationRepresentation:pre];
        view.calloutOffset = CGPointMake(0, 0);
    }
}
- (void)viewDidAppear:(BOOL)animated{
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc]init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(39.989631, 116.48);
    pointAnnotation.title = @"洛阳";
    pointAnnotation.subtitle = @"龙门";
    [_mapView addAnnotation:pointAnnotation];
}
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *pointReuseIndentifier = @"";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil) {
            annotationView = [[MAPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;  //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES; //设置标注动画显示，默认为NO
        annotationView.draggable = YES;  //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
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

@end
