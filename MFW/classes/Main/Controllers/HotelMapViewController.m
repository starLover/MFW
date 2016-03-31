//
//  HotelMapViewController.m
//  MFW
//
//  Created by wanghongxiao on 16/3/23.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import "HotelMapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AFHTTPSessionManager.h>
#import "MainModel.h"

@interface HotelMapViewController ()<MAMapViewDelegate, AMapSearchDelegate, UIGestureRecognizerDelegate>
{
    MAMapView *_mapView;
    AMapSearchAPI *_search;
    UILongPressGestureRecognizer *_longPress;
    MAPointAnnotation *_destinationPoint;
}
@property(nonatomic, strong) NSMutableArray *hotelTitle;
@property(nonatomic, strong) NSMutableArray *outlineArray;
@property(nonatomic, strong) NSMutableArray *locationArray;
@property(nonatomic, strong) UIView *navigationView;
@property(nonatomic, strong) UITextField *startTF;
@property(nonatomic, strong) UITextField *destationTF;
@end

@implementation HotelMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self request];
    [self showBackBtn];
    //配置用户Key
    [AMapSearchServices sharedServices].apiKey = @"347a662a9e7129f224a9840c18e3f744";
    
    [self searchAction];
    [MAMapServices sharedServices].apiKey = @"347a662a9e7129f224a9840c18e3f744";
    
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    //地图跟着位置移动
    [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:NO];
    //    [_mapView setZoomLevel:16.1 animated:NO];
    //定位精度
    //    _mapView.desiredAccuracy = kCLLocationAccuracyBest;
    //导航栏搜索
    [self.navigationController.view addSubview:self.navigationView];
    [self navigationSearch];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    [self.view addSubview:_mapView];
    
    //初始化检索对象
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
}


#pragma mark    ------------ 从上一界面传的city
- (void)searchAction{
    //构造AMapGeocodeSearchRequest对象，address为必选项，city为可选项
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    geo.address = self.cityName;
    //发起正向地理编码
    [_search AMapGeocodeSearch: geo];
    
    //长按手势
    _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongpress:)];
    _longPress.delegate = self;
    [_mapView addGestureRecognizer:_longPress];
}

- (void)handleLongpress:(UILongPressGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        CLLocationCoordinate2D coordinate = [_mapView convertPoint:[gesture locationInView:_mapView] toCoordinateFromView:_mapView];
        if (_destinationPoint != nil) {
            //清理
            [_mapView removeAnnotation:_destinationPoint];
            _destinationPoint = nil;
        }
        _destinationPoint = [[MAPointAnnotation alloc] init];
        _destinationPoint.coordinate = coordinate;
        _destinationPoint.title = @"终点";
        [_mapView addAnnotation:_destinationPoint];
    }
}


#pragma mark   ----------  MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    if (annotation == _destinationPoint) {
        static NSString *reuseIdentifier = @"startIdentifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
        if (annotationView == nil) {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
        }
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = YES;
        return annotationView;
    }
    
    
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

#pragma mark    ------------     路线规划


//驾车
- (void)pathPlanning{
    //获取输入框起始路径

    [AMapSearchServices sharedServices].apiKey = @"347a662a9e7129f224a9840c18e3f744";
    //初始化检索对象
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    //构造AMapDrivingRouteSearchRequest对象，设置驾车路径规划请求参数
    AMapDrivingRouteSearchRequest *request = [[AMapDrivingRouteSearchRequest alloc] init];
    request.originId = self.startTF.text;
    request.destinationId = self.destationTF.text;
    request.strategy = 2;//距离优先
    request.requireExtension = YES;
    
    //发起路径搜索
    [_search AMapDrivingRouteSearch: request];
}




//实现路径搜索的回调函数
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    if(response.route == nil)
    {
        return;
    }
    
    //通过AMapNavigationSearchResponse对象处理搜索结果
    NSString *route = [NSString stringWithFormat:@"Navi: %@", response.route];
    NSLog(@"%@", route);
    
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
- (UIView *)navigationView{
    if (!_navigationView) {
        self.navigationView = [[UIView alloc] initWithFrame:CGRectMake(45, 20, kScreenWidth - 50, 44)];
    }
    return _navigationView;
}
- (UITextField *)startTF{
    if (!_startTF) {
        self.startTF = [[UITextField alloc] initWithFrame:CGRectMake(2, 2, (kScreenWidth - 50 - 60) / 2, 40)];
        self.startTF.placeholder = @"起点";
        self.startTF.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _startTF;
}
- (UITextField *)destationTF{
    if (!_destationTF) {
        self.destationTF = [[UITextField alloc] initWithFrame:CGRectMake((kScreenWidth - 50 - 60) / 2 + 4, 2, (kScreenWidth - 50 - 60) / 2, 40)];
        self.destationTF.placeholder = @"终点";
        self.destationTF.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _destationTF;
}
- (NSMutableArray *)locationArray{
    if (!_locationArray) {
        self.locationArray = [NSMutableArray new];
    }
    return _locationArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationView removeFromSuperview];
}

- (void)navigationSearch{
    //导航栏上搜索路线
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(kScreenWidth - 100, 8, 44, 30);
    btn.layer.cornerRadius = 2;
    [btn setTitle:@"查询" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pathPlanning) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor orangeColor];
    [self.navigationView addSubview:btn];
    [self.navigationView addSubview:self.startTF];
    [self.navigationView addSubview:self.destationTF];
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
