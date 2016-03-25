//
//  HotelMapViewController.m
//  MFW
//
//  Created by wanghongxiao on 16/3/23.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import "HotelMapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AFHTTPSessionManager.h>
#import "MainModel.h"

@interface HotelMapViewController ()<MAMapViewDelegate>
{
    MAMapView *_mapView;
}
@property(nonatomic, strong) NSMutableArray *hotelTitle;
@property(nonatomic, strong) NSMutableArray *outlineArray;
@end

@implementation HotelMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self request];
    //配置用户Key
    [MAMapServices sharedServices].apiKey = @"347a662a9e7129f224a9840c18e3f744";
    
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _mapView.delegate = self;
    //    _mapView.showsUserLocation = YES;
    //    _mapView.showTraffic = YES;
    [self.view addSubview:_mapView];
}
#pragma mark   ----------  MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
}



- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolygon class]])
    {
        MAPolygonView *polygonView = [[MAPolygonView alloc] initWithPolygon:overlay];
        
        polygonView.lineWidth = 1.f;
        polygonView.strokeColor = [[UIColor cyanColor] colorWithAlphaComponent:0.5];
        polygonView.fillColor = [[UIColor orangeColor] colorWithAlphaComponent:0.5];
        polygonView.lineJoin = kCGLineJoinMiter;//连接类型
        
        return polygonView;
    }
    return nil;
}

#pragma mark      -------------    request
- (void)request{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    [manager GET:myMapList parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%@", downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDic = responseObject;
        NSDictionary *dataDic = responseDic[@"data"];
        NSArray *listArray = dataDic[@"list"];
        for (NSDictionary *dic in listArray) {
            MainModel *model = [[MainModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.hotelTitle addObject:model];
            //覆盖物轮廓
            NSArray *regionArray = dic[@"region_gps"];
            NSMutableArray *newArray = [NSMutableArray new];
            for (NSDictionary *regionDic in regionArray) {
                MainModel *model1 = [[MainModel alloc] init];
                [model1 setValuesForKeysWithDictionary:regionDic];
                [newArray addObject:model1];
            }
            [self.outlineArray addObject:newArray];
        }
        
        [self addPinAnnotation];
        [self coverAction];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}
//大头针标注MAPinAnnotationView
- (void)addPinAnnotation{
    if (self.hotelTitle.count > 0) {
        for (MainModel *model in self.hotelTitle) {
            MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
            pointAnnotation.coordinate = CLLocationCoordinate2DMake([model.lat floatValue], [model.lng floatValue]);
            pointAnnotation.title = model.name;
            pointAnnotation.subtitle = [NSString stringWithFormat:@"%@家酒店", model.num_pois];
            [_mapView addAnnotation:pointAnnotation];
        }
    }
}
//覆盖物
- (void)coverAction{
    
    for (NSArray *array in self.outlineArray) {
        //构造多边形数据对象
        CLLocationCoordinate2D coordinates[array.count];
        for (NSInteger i = 0; i < array.count; i++) {
            MainModel *model = array[i];
            coordinates[i].latitude = [model.lat floatValue];
            coordinates[i].longitude = [model.lng floatValue];

        }
        MAPolygon *polygon = [MAPolygon polygonWithCoordinates:coordinates count:array.count];
        //在地图上添加多边形对象
        [_mapView addOverlay: polygon];
    }
}

#pragma mark     ---------------     LazyLoading
- (NSMutableArray *)hotelTitle{
    if (!_hotelTitle) {
        self.hotelTitle = [NSMutableArray new];
    }
    return _hotelTitle;
}
- (NSMutableArray *)outlineArray{
    if (!_outlineArray) {
        self.outlineArray = [NSMutableArray new];
    }
    return _outlineArray;
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
