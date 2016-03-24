//
//  TravelWorldViewController.m
//  MFW
//
//  Created by wanghongxiao on 16/3/23.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import "TravelWorldViewController.h"
#import "MainModel.h"
#import <AFHTTPSessionManager.h>
#import "TravelWorldTableViewCell.h"

@interface TravelWorldViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *listArray;
@property(nonatomic, strong) NSMutableArray *placeNameArray;
@property(nonatomic, strong) NSArray *tagsArray;
@property(nonatomic, strong) TravelWorldTableViewCell *travelCell;
@end

@implementation TravelWorldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self request];
    [self.view addSubview:self.tableView];
    [self showBackBtn];
}


#pragma mark  ---------------  UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifier";
    TravelWorldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    for (id subviews in cell.contentView.subviews) {
        [subviews removeFromSuperview];
    }
    if (cell == nil) {
        cell = [[TravelWorldTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.row < self.listArray.count) {
        cell.mainModel = self.listArray[indexPath.row];
        MainModel *model = self.placeNameArray[indexPath.row];
        cell.placeLabel.text = model.name;
    }
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}
#pragma mark  ---------------  UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainModel *model = self.listArray[indexPath.row];
    CGFloat imageHeight = kScreenWidth * [model.height floatValue] / [model.width floatValue];
    return [self.travelCell getCellHeight:model.content imageHeight:imageHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

#pragma mark  ---------------  request

- (void)request{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    [manager GET:kTravelmyStar1 parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%@", downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *responseDic = responseObject;
        NSDictionary *dataDic = responseDic[@"data"];
       //list
        NSArray *listArray = dataDic[@"list"];
        for (NSDictionary *dic in listArray) {
            MainModel *model1 = [[MainModel alloc] init];
            [model1 setValuesForKeysWithDictionary:dic];
            //img
            NSDictionary *imgDic = dic[@"img"];
            [model1 setValuesForKeysWithDictionary:imgDic];
            //owner
            [model1 setValuesForKeysWithDictionary:dic[@"owner"]];
            
            [self.listArray addObject:model1];
            //mdd
            NSDictionary *mddsDic = dic[@"mdd"];
            MainModel *mddModel = [[MainModel alloc] init];
            [mddModel setValuesForKeysWithDictionary:mddsDic];
            [self.placeNameArray addObject:mddModel];
        }
        //tags
        self.tagsArray = dataDic[@"tags"];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}
#pragma mark  ---------------  LazyLoading
- (TravelWorldTableViewCell *)travelCell{
    if (!_travelCell) {
        self.travelCell = [[TravelWorldTableViewCell alloc] init];
    }
    return _travelCell;
}
- (UITableView *)tableView{
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 24)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    
    return _tableView;
}
- (NSMutableArray *)listArray{
    if (!_listArray) {
        self.listArray = [NSMutableArray new];
    }
    return _listArray;
}

- (NSMutableArray *)placeNameArray{
    if (!_placeNameArray) {
        self.placeNameArray = [NSMutableArray new];
    }
    return _placeNameArray;
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
