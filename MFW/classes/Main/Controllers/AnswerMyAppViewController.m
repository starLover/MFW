//
//  AnswerMyAppViewController.m
//  MFW
//
//  Created by wanghongxiao on 16/3/24.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import "AnswerMyAppViewController.h"
#import <AFHTTPSessionManager.h>
#import "AnswerMyappTableViewCell.h"
#import "MainModel.h"
#import <UIImageView+WebCache.h>

@interface AnswerMyAppViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *listArray;
@property(nonatomic, strong) NSMutableArray *answerArray;
@property(nonatomic, strong) NSMutableArray *mddArray;
@property(nonatomic, strong) NSMutableArray *anUserArray;

@end

@implementation AnswerMyAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"问答人";
    [self showBackBtn];
    [self request];
    [self.view addSubview:self.tableView];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"AnswerMyappTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellIdentifier"];
}

#pragma mark  ---------------  UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AnswerMyappTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    if (indexPath.row < self.listArray.count) {
        //list
        MainModel *listModel = self.listArray[indexPath.row];
        cell.mainModel = listModel;
        //answer
        MainModel *answerModel = self.answerArray[indexPath.row];
        cell.contentLabel.text = answerModel.content;
        //anUser
        MainModel *anUserModel = self.anUserArray[indexPath.row];
        [cell.authorImage sd_setImageWithURL:[NSURL URLWithString:anUserModel.logo]];
        //mdd
        MainModel *mddModel = self.mddArray[indexPath.row];
        cell.placeLabel.text = mddModel.name;
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}
#pragma mark  ---------------  UITableViewDelegate



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

#pragma mark  ---------------  request

- (void)request{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    [manager GET:kAnswerMyapp parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%@", downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDic = responseObject;
        NSDictionary *dataDic = responseDic[@"data"];
        NSArray *array = dataDic[@"list"];
        for (NSDictionary *dic in array) {
            //listArray
            MainModel *model = [[MainModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.listArray addObject:model];
            //answer
            NSDictionary *answerDic = dic[@"answer"];
            MainModel *answerModel = [[MainModel alloc] init];
            [answerModel setValuesForKeysWithDictionary:answerDic];
            [self.answerArray addObject:answerModel];
            //answerUser
            NSDictionary *anUserDic = answerDic[@"user"];
            MainModel *anUserModel = [[MainModel alloc] init];
            [anUserModel setValuesForKeysWithDictionary:anUserDic];
            [self.anUserArray addObject:anUserModel];
            //mdd
            NSDictionary *mddDic = dic[@"mdd"];
            MainModel *mddModel = [[MainModel alloc] init];
            [mddModel setValuesForKeysWithDictionary:mddDic];
            [self.mddArray addObject:mddModel];
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

#pragma mark  ---------------  LazyLoading

- (UITableView *)tableView{
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 24)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 200;
    }
    return _tableView;
}
- (NSMutableArray *)listArray{
    if (!_listArray) {
        self.listArray = [NSMutableArray new];
    }
    return _listArray;
}

- (NSMutableArray *)answerArray{
    if (!_answerArray) {
        self.answerArray = [NSMutableArray new];
    }
    return _answerArray;
}
- (NSMutableArray *)mddArray{
    if (!_mddArray) {
        self.mddArray = [NSMutableArray new];
    }
    return _mddArray;
}
- (NSMutableArray *)anUserArray{
    if (!_anUserArray) {
        self.anUserArray = [NSMutableArray new];
    }
    return _anUserArray;
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
