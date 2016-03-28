//
//  ShoppingViewController.m
//  MFW
//
//  Created by scjy on 16/3/24.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import "ShoppingViewController.h"
#import "ScenicTableViewCell.h"
#import "JSDropDownMenu.h"
#import "ScenicModel.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <CoreLocation/CoreLocation.h>
@interface ShoppingViewController ()<JSDropDownMenuDelegate,JSDropDownMenuDataSource,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_data1;
    NSMutableArray *_data2;
    NSInteger _currentData1Index;
    NSInteger _currentData2Index;
    NSInteger _currentDataSelectedIndex;
    JSDropDownMenu *menu;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *itemArray;
@property(nonatomic,strong)NSMutableArray *areaArray;
@property(nonatomic,strong)NSMutableArray *commentArray;


@end

@implementation ShoppingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackBtn];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ScenicTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    _currentData1Index = 0;
    _currentDataSelectedIndex = 1;
    
    _data1 = [NSMutableArray arrayWithObjects:@"不限",@"点评最多",@"离我最近", nil];
    _data2 = [NSMutableArray arrayWithObjects:@"必游TOP10",@"博物馆",@"历史古迹",@"免费景点", nil];
    menu = [[JSDropDownMenu alloc]initWithOrigin:CGPointMake(0, 0) andHeight:45];
    menu.indicatorColor = [UIColor orangeColor];
    menu.separatorColor = [UIColor blackColor];
    menu.textColor = [UIColor blackColor];
    menu.dataSource = self;
    menu.delegate = self;
    [self.view addSubview:menu];
    
    [self.view addSubview:self.tableView];
    [self loadData];
}
#pragma mark ----------- UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ScenicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    //    cell.backgroundColor = [UIColor cyanColor];
    if (indexPath.row < self.itemArray.count && indexPath.row < self.areaArray.count && indexPath.row < self.commentArray.count) {
        
        ScenicModel *model = self.itemArray[indexPath.row];
        ScenicModel *areaModel = self.areaArray[indexPath.row];
        ScenicModel *commentModel = self.commentArray[indexPath.row];
        [cell.imageV sd_setImageWithURL:[NSURL URLWithString:model.thumbnail] placeholderImage:[UIImage imageNamed:@"coffee"]];
        cell.imageV.contentMode = UIViewContentModeScaleAspectFit;
        cell.placeLabel.text = model.name;
        cell.commentLabel.text = [NSString stringWithFormat:@"%@条蜂评，%@篇游记提及",model.num_comment,model.num_travelnote];
        cell.location.text = [NSString stringWithFormat:@"位于%@",areaModel.name];
        cell.information.text = [NSString stringWithFormat:@"%@ ：%@",commentModel.name,commentModel.comment];
        //计算两个经纬度之间的距离
        double origLat = [[[NSUserDefaults standardUserDefaults] valueForKey:@"o_lat"] doubleValue];
        double origLng = [[[NSUserDefaults standardUserDefaults]valueForKey:@"o_lng"] doubleValue];
        CLLocation *origloc = [[CLLocation alloc]initWithLatitude:origLat longitude:origLng];
        CLLocation *disLoc = [[CLLocation alloc]initWithLatitude:[model.lat doubleValue] longitude:[model.lng doubleValue]];
        CLLocationDistance distance = [origloc distanceFromLocation:disLoc];
        cell.distanceLabel.text = [NSString stringWithFormat:@"%.fkm",distance];
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemArray.count;
}
- (UITableView *)tableView{
    if (!_tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, kScreenWidth, kScreenHeight-108)];
        self.tableView.delegate =self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 220;
    }
    return _tableView;
}
#pragma mark ----------- JSDropDownMenuDataSource
- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu{
    return 2;
}
- (BOOL)displayByCollectionViewInColumn:(NSInteger)column{
    return NO;
}
- (BOOL)haveRightTableViewInColumn:(NSInteger)column{
    return NO;
}
//* 返回当前菜单左边表选中行
-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
    return 1;
}
-(NSInteger)currentLeftSelectedRow:(NSInteger)column{
    if (column==0) {
        return _currentData1Index;
    }
    if (column == 1) {
        return _currentData2Index;
    }
    return 0;
}
- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    if (column==0) {
        return _data1.count;
    } else if (column == 1){
        return _data2.count;
    }
    return 0;
}
- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    switch (column) {
        case 0: return _data1[_currentData1Index] ;
            break;
        case 1: return _data2[_currentData2Index];
            break;
        default:
            return nil;
            break;
    }
}
- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column==0) {
        return _data1[indexPath.row];
    } else {
        return _data2[indexPath.row];
    }
}
- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column == 0) {
        _currentData1Index = indexPath.row;
        
    } else{
        _currentData2Index = indexPath.row;
    }
}
#pragma mark -----------   网络请求
- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}
- (void)loadData{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
    
    [sessionManager GET:kShopping parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *resultDic = responseObject;
        NSDictionary *data = resultDic[@"data"];
        NSArray *list = data[@"list"];
        for (NSDictionary *dic in list) {
            //list
            ScenicModel *scenicModel = [[ScenicModel alloc]init];
            [scenicModel setValuesForKeysWithDictionary:dic];
            [self.itemArray addObject:scenicModel];
            NSDictionary *area = dic[@"area"];
            //area(name)
            ScenicModel *areaModel = [[ScenicModel alloc]init];
            [areaModel setValuesForKeysWithDictionary:area];
            [self.areaArray addObject:areaModel];
            //comment
            NSDictionary *comment = dic[@"comments"][0];
            ScenicModel *commentModel = [[ScenicModel alloc]init];
            [commentModel setValuesForKeysWithDictionary:comment];
            //owner(name)
            NSDictionary *owner = comment[@"owner"];
            [commentModel setValuesForKeysWithDictionary:owner];
            //honors(title)
            NSArray *title = dic[@"honors"];
            if (title.count > 0) {
                [commentModel setValuesForKeysWithDictionary:title[0]];
                [self.commentArray addObject:commentModel];
            }
        }
        
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}
- (NSMutableArray *)itemArray{
    if (!_itemArray) {
        self.itemArray = [NSMutableArray new];
    }
    return _itemArray;
}
- (NSMutableArray *)areaArray{
    if (!_areaArray) {
        self.areaArray = [NSMutableArray new];
    }
    return _areaArray;
}
- (NSMutableArray *)commentArray{
    if (!_commentArray) {
        self.commentArray = [NSMutableArray new];
    }
    return _commentArray;
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
