//
//  LookNoteViewController.m
//  MFW
//
//  Created by wanghongxiao on 16/3/23.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import "LookNoteViewController.h"
#import "MainViewController.h"
#import "MainModel.h"
#import <AFHTTPSessionManager.h>
#import "LookNoteTableViewCell.h"
#import "HeadViewController.h"

@interface LookNoteViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *listArray;
@property(nonatomic, strong) NSMutableArray *userNameArray;
@property(nonatomic, strong) NSMutableArray *idArray;
@end

@implementation LookNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"看游记";
    [self showBackBtn];
    [self request];
    [self.view addSubview:self.tableView];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"LookNoteTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellIdentifier"];
}
#pragma mark  ---------------  UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LookNoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    if (indexPath.row < self.listArray.count) {
        MainModel *model1 = self.listArray[indexPath.row];
        cell.mainModel = model1;
        MainModel *model2 = self.userNameArray[indexPath.row];
        cell.placeLabel.text = [NSString stringWithFormat:@"%@在 %@", model1.name, model2.name];
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}
#pragma mark  ---------------  UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HeadViewController *headVC = [[HeadViewController alloc] init];
    MainModel *model = self.idArray[indexPath.row];
    NSLog(@"%@", model.myId);
    headVC.urlString = [NSString stringWithFormat:@"http://m.mafengwo.cn/i/%@.html", model.myId];
    [self.navigationController pushViewController:headVC animated:YES];
}

#pragma mark  ---------------  request

- (void)request{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    [manager GET:lookNoteList parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%@", downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDic = responseObject;
        NSDictionary *dataDic = responseDic[@"data"];
        NSArray *list1Array = dataDic[@"list"];
        for (NSDictionary *dic in list1Array) {
            MainModel *idModel = [[MainModel alloc] init];
            [idModel setValuesForKeysWithDictionary:dic];
            [self.idArray addObject:idModel];
            
            MainModel *model = [[MainModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            //mdds
            NSDictionary *userDic = dic[@"user"];
            [model setValuesForKeysWithDictionary:userDic];
            [self.listArray addObject:model];
            
            //user
            NSDictionary *mddsDic = dic[@"mdds"][0];
            MainModel *mddsModel = [[MainModel alloc] init];
            [mddsModel setValuesForKeysWithDictionary:mddsDic];
            [self.userNameArray addObject:mddsModel];
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}
#pragma mark  ---------------  LazyLoading

- (UITableView *)tableView{
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 300;
    }
    return _tableView;
}
- (NSMutableArray *)listArray{
    if (!_listArray) {
        self.listArray = [NSMutableArray new];
    }
    return _listArray;
}
- (NSMutableArray *)userNameArray{
    if (!_userNameArray) {
        self.userNameArray = [NSMutableArray new];
    }
    return _userNameArray;
}
- (NSMutableArray *)idArray{
    if (!_idArray) {
        self.idArray = [NSMutableArray new];
    }
    return _idArray;
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
