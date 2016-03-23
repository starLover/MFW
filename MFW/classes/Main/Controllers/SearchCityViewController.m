//
//  SearchCityViewController.m
//  MFW
//
//  Created by wanghongxiao on 16/3/19.
//  Copyright © 2016年 李志鹏. All rights reserved.
//

#import "SearchCityViewController.h"
#import <AFHTTPSessionManager.h>
#import "MainModel.h"
#import <UIImageView+WebCache.h>

@interface SearchCityViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *array;
@end

@implementation SearchCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    NSString *value = [@"北京" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self.view addSubview:self.tableView];
    [self request];
}

#pragma mark      -----------       UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    if (indexPath.row < self.array.count) {
        MainModel *model = self.array[indexPath.row];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 20, 20)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.icon]];
        [cell.contentView addSubview:imageView];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 100, cell.contentView.frame.size.height)];
        label.text = model.name;
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, 100, cell.contentView.frame.size.height)];
        label1.text = model.name;
        label1.font = [UIFont systemFontOfSize:15.0];
        [cell.contentView addSubview:label];
        [cell.contentView addSubview:label1];
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}

#pragma mark      -----------       UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}


- (void)request{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    [manager GET:kSearchPlace parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%@", downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDic = responseObject;
        NSDictionary *dataDic = responseDic[@"data"];
        NSArray *listArray = dataDic[@"list"];
        for (NSDictionary *dic in listArray) {
            MainModel *model = [[MainModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.array addObject:model];
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}
#pragma mark     ----------   LazyLoading
- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return _tableView;
}
- (NSMutableArray *)array{
    if (!_array) {
        self.array = [NSMutableArray new];
    }
    return _array;
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
