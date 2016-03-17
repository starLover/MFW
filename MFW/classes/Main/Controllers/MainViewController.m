//
//  MainViewController.m
//  MFW
//
//  Created by wanghongxiao on 16/3/17.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#import "MainViewController.h"
#import <UIImageView+WebCache.h>
#import <AFHTTPSessionManager.h>

@interface MainViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) UITableView *tableView;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self configHeaderView];
    [self request];
}

#pragma mark    ---------------    UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor blueColor];
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    return view;
}
#pragma mark    ---------------    UITableViewDelegate




#pragma mark   -----------------          自定义table头部

- (void)configHeaderView{
    //导航栏搜索
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44)];
    [self.navigationController.view addSubview:view];
    UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 34, 34)];
    headImageView.image = [UIImage imageNamed:@"common_loading_logo"];
    [view addSubview:headImageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, kScreenWidth / 4, 44)];
    label.text = @"小蜜蜂";
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 3 - 10, 0, kScreenWidth / 3 * 2, 44)];
    imageView.image = [UIImage imageNamed:@"5E0492E0-20B3-46C8-8E56-8BB964210ECC"];
    [view addSubview:imageView];
    
    UIButton *bigBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bigBtn.frame = view.frame;
    [bigBtn addTarget:self action:@selector(goToMap) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:bigBtn];
    //
    
}
//搜索方法
- (void)goToMap{
}





#pragma mark       ------------------   Request
- (void)request{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    [manager GET:kButtonList parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}



#pragma mark      ---------- LazyLoading
- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 44)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = [UIColor redColor];
        self.tableView.rowHeight = 120;
    }
    return _tableView;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = NO;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
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
