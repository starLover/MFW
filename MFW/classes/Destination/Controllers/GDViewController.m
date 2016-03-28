//
//  GDViewController.m
//  MFW
//
//  Created by scjy on 16/3/25.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import "GDViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
@interface GDViewController ()<MAMapViewDelegate,AMapSearchDelegate>
{
    MAMapView *_mapView;
    AMapSearchAPI *_search;
    
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
    [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:NO];
    [_mapView setZoomLevel:40.1 animated:NO];
    //定位精度
    _mapView.desiredAccuracy = kCLLocationAccuracyBest;
    //周边搜索
    [self searchAction];
}
//- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatin gLocation{
//    if (updatingLocation) {
//        NSLog(@"latitude:%f,lng:%f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
//    }
//}
- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    MAAnnotationView *view = views[0];
    view.enabled = NO;
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]]) {
        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc]init];
        pre.fillColor = [UIColor clearColor];
        pre.strokeColor = [UIColor orangeColor];
        pre.image = [UIImage imageNamed:@"ic_topbar_location"];
       
        pre.showsHeadingIndicator = NO;
        pre.lineWidth = 2;
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
        annotationView.canShowCallout= YES;  //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES; //设置标注动画显示，默认为NO
        annotationView.draggable = YES;  //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
}
- (void)searchAction{
    //配置用户key
    [AMapSearchServices sharedServices].apiKey = kGDKey;
    //初始化检索对象
    _search = [[AMapSearchAPI alloc]init];
    _search.delegate = self;
    //构造AMapPOIAroundSearchRequest对象，设置周边请求参数
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:39.990459 longitude:116.481476];
    request.keywords = self.string;
    // types属性表示限定搜索POI的类别，默认为：餐饮服务|商务住宅|生活服务
    // POI的类型共分为20种大类别，分别为：
    // 汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|
    // 医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|
    // 交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施
    request.types = @"餐饮服务|生活服务|风景名胜";
    request.sortrule = 0;
    request.requireExtension = YES;
    
    //发起周边搜索
    [_search AMapPOIAroundSearch: request];
}
//实现POI搜索对应的回调函数
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if(response.pois.count == 0)
    {
        return;
    }
    
    //通过 AMapPOISearchResponse 对象处理搜索结果
    NSString *strCount = [NSString stringWithFormat:@"count: %d",response.count];
    NSString *strSuggestion = [NSString stringWithFormat:@"Suggestion: %@", response.suggestion];
    NSString *strPoi = @"";
    for (AMapPOI *p in response.pois) {
        strPoi = [NSString stringWithFormat:@"%@\nPOI: %@", strPoi, p.description];
    }
    NSString *result = [NSString stringWithFormat:@"%@ \n %@ \n %@", strCount, strSuggestion, strPoi];
    NSLog(@"Place: %@", result);
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
