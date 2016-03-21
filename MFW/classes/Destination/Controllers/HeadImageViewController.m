//
//  HeadImageViewController.m
//  MFW
//
//  Created by scjy on 16/3/19.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import "HeadImageViewController.h"
#import "HeadImageTableViewCell.h"
#import "DestinationViewController.h"
#import "DestinationModel.h"

#import <AFNetworking/AFHTTPSessionManager.h>

@interface HeadImageViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UISegmentedControl *segmentControl;
@property(nonatomic,strong)NSMutableArray *poiArray;
@property(nonatomic,strong)NSMutableArray *areaArray;
@property(nonatomic,strong)NSMutableArray *itemArray;
@property(nonatomic,strong)NSMutableArray *otherArray;
@property(nonatomic,strong)NSMutableArray *userArray;
@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation HeadImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;

    [self headViewAction];
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:@"HeadImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    [self requestModel];
}

#pragma mark --------- UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
       return self.itemArray.count;
//    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HeadImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//    DestinationModel *itemModel = self.itemArray[indexPath.row];
//    DestinationModel *poiModel = self.poiArray[indexPath.row];
//    DestinationModel *areaModel = self.areaArray[indexPath.row];
//    if (indexPath.row < self.itemArray.count && indexPath.row < self.poiArray.count && indexPath.row < self.areaArray.count) {
//        
//        cell.nameLabel.text = poiModel.name;
//        cell.placeName.text = [NSString stringWithFormat:@"位于%@，距离nkm",areaModel.name];
//    cell.userNum.text = [NSString stringWithFormat:@"今天有%@人浏览",itemModel.user_number];
//    }
//    NSLog(@"%@",poiModel.name);
//    NSLog(@"%@",areaModel.name);
//    NSLog(@"%@",itemModel.user_number);
    
    return cell;
}
- (UITableView *)tableView{
    if (!_tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kScreenHeight/4, kScreenWidth, kScreenHeight-kScreenHeight/4)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = kScreenHeight/6;
    }
    return _tableView;
}
#pragma mark --------- 自定义BlackView
- (void)headViewAction{
    UIView *blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight/4)];
    blackView.backgroundColor = [UIColor blackColor] ;
    [self.view addSubview:blackView];
    
    UIButton *numBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    numBtn.frame = CGRectMake(kScreenWidth-80, 20 , 40, 44);
    [numBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [numBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [blackView addSubview:numBtn];
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, kScreenWidth/3, 40)];
    timeLabel.text = @"过去24小时,";
    timeLabel.textColor = [UIColor whiteColor];
    [blackView addSubview:timeLabel];
    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 50, kScreenWidth/3, 50)];
//    DestinationModel *numModel = self.dataArray[0];
//    numLabel.text = numModel.user_number;
    numLabel.textColor = [UIColor whiteColor];
    numLabel.font = [UIFont systemFontOfSize:26];
    [blackView addSubview:numLabel];
    UILabel *placeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20,80, kScreenWidth/2, 40)];
//    DestinationModel *placeModel = self.otherArray[0];
//    placeLabel.text = [NSString stringWithFormat:@"人，正在%@旅行",placeModel.name];
    placeLabel.textColor = [UIColor grayColor];
    placeLabel.font = [UIFont systemFontOfSize:14];
    [blackView addSubview:placeLabel];
    [blackView addSubview:self.segmentControl];
    
}
- (void)closeAction{
     [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ---------  网络请求
- (void)requestModel{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
    [sessionManager GET:kHeaderImage parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *resultDic = responseObject;
        NSDictionary *dataDic = resultDic[@"data"];
        DestinationModel *numModel = [[DestinationModel alloc]init];
        [numModel setValuesForKeysWithDictionary:dataDic];
        [self.dataArray addObject:numModel];
        NSArray *blocks = dataDic[@"blocks"];
        for (NSDictionary *dic in blocks) {
//            NSDictionary *item = dic[@"item0"];
            NSArray *listArray = dic[@"list"];
            for (NSDictionary *dit in listArray) {
                NSDictionary *poi = dit[@"poi"];
                NSDictionary *area = poi[@"area"];
                NSArray *user_list = dit[@"user_list"];
                
                DestinationModel *model = [[DestinationModel alloc]init];
                [model setValuesForKeysWithDictionary:poi];
                [self.poiArray addObject:model];
                
                DestinationModel *model1 = [[DestinationModel alloc]init];
                [model1 setValuesForKeysWithDictionary:area];
                [self.areaArray addObject:model1];
                
                for (NSDictionary *dict in user_list) {
                    DestinationModel *bModel = [[DestinationModel alloc]init];
                    [bModel setValuesForKeysWithDictionary:dict];
                    [self.userArray addObject:bModel];
                }
            }
        }
        NSDictionary *mdd = dataDic[@"mdd"];
        DestinationModel *model = [[DestinationModel alloc]init];
        [model setValuesForKeysWithDictionary:mdd];
        [self.otherArray addObject:model];
        
        NSLog(@"%lu",self.areaArray.count);
        NSLog(@"%lu",self.poiArray.count);
        NSLog(@"%lu",self.userArray.count);
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}
#pragma mark --------- segmentControl
- (UISegmentedControl *)segmentControl{
    if (!_segmentControl) {
        self.segmentControl = [[UISegmentedControl alloc]initWithItems:@[@"餐厅",@"景点",@"购物"]];
        self.segmentControl.frame = CGRectMake(40, 120, kScreenWidth-80, 40);
        self.segmentControl.tintColor = [UIColor orangeColor];
        [self.segmentControl addTarget:self action:@selector(segmentControlChangeAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentControl;
}
- (void)segmentControlChangeAction:(UISegmentedControl *)segment{
    switch (segment.selectedSegmentIndex) {
        case 0:
        {
        }
            break;
        case 1:
        {
        }
            break;
        case 2:
        {
        }
            break;
        default:
            break;
    }
}
#pragma mark --------- Lazy
- (NSMutableArray *)poiArray{
    if (!_poiArray) {
        self.poiArray = [NSMutableArray new];
    }
    return _poiArray;
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
- (NSMutableArray *)otherArray{
    if (!_otherArray) {
        self.otherArray = [NSMutableArray new];
    }
    return _otherArray;
}
- (NSMutableArray *)userArray{
    if (!_userArray) {
        self.userArray = [NSMutableArray new];
    }
    return _userArray;
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray new];
    }
    return _dataArray;
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
