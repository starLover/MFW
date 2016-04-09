//
//  TravelogueViewController.m
//  MFW
//
//  Created by scjy on 16/3/24.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import "TravelogueViewController.h"
#import "TravelTableViewCell.h"
#import "ScenicModel.h"
#import "TravelDetailViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
@interface TravelogueViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *mainArray;
@property(nonatomic,strong)NSMutableArray *logoArray;

@end

@implementation TravelogueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"游记";
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIColor orangeColor] forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dic;
    [self showBackBtn];
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:@"TravelTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    [self loadData];
}
#pragma mark ----------
#pragma mark ----------
#pragma mark ----------
#pragma mark ----------UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TravelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.row < self.logoArray.count) {
        ScenicModel *model = self.mainArray[indexPath.row];
        cell.headImage.layer.masksToBounds = YES;
        cell.headImage.layer.cornerRadius = 20;
        [cell.headImage sd_setImageWithURL:[NSURL URLWithString:self.logoArray[indexPath.row]] placeholderImage:nil];
        cell.headImage.contentMode = UIViewContentModeScaleAspectFit;
        cell.titleLabel.text = model.title;
        cell.numLabel.text = [NSString stringWithFormat:@"%@人浏览",model.num_visit];
        [cell.mainImage sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:nil];
     }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mainArray.count;
}
- (UITableView *)tableView{
    if (!_tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight =  160;
    }
    return _tableView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TravelDetailViewController *detailVC = [[TravelDetailViewController alloc]init];
    ScenicModel *scModel = self.mainArray[indexPath.row];
    detailVC.url = scModel.url;
    [self.navigationController pushViewController:detailVC animated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}
#pragma mark ---------- 网络请求
- (void)loadData{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
    [sessionManager POST:kTravelogue parameters:@{@"oauth_nonce":@"e8e6cac9-cd5b-4bae-8544-ca8478626c65",@"oauth_consumer_key":@"5",@"screen_scale":@"2.0",@"device_type":@"android",@"hardware_model":@"vivo Y29L",@"type":@"1",@"oauth_signature":@"Ags+aUy3KDY1ajIi+EEj8mBE6EM=",@"travelnote_type":@"1",@"x_auth_mode":@"client_auth",@"o_lng":@"112.420377",@"oauth_signature_method":@"HMAC-SHA1",@"oauth_token":@"0_0969044fd4edf59957f4a39bce9200c6",@"app_code":@"com.mfw.roadbook",@"o_lat":@"34.612419",@"oauth_version":@"1.0",@"mddid":@"10094",@"mfwsdk_ver":@"20140507",@"screen_width":@"720",@"device_id":@"e4:5a:a2:24:b6:24",@"sys_ver":@"4.4.4",@"channel_id":@"SLL",@"start":@"0",@"open_udid":@"e4:5a:a2:24:b6:24",@"app_ver":@"6.4.2",@"oauth_timestamp":@"1458812767",@"screen_height":@"1280"} progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *resultDic = responseObject;
        NSDictionary *data = resultDic[@"data"];
        NSArray *list = data[@"list"];
        for (NSDictionary *dic in list) {
            ScenicModel *model = [[ScenicModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.mainArray addObject:model];
            NSDictionary *user = dic[@"user"];
            [self.logoArray addObject:user[@"logo"]];
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}
- (NSMutableArray *)mainArray{
    if (!_mainArray) {
        self.mainArray = [NSMutableArray new];
    }
    return _mainArray;
}
- (NSMutableArray *)logoArray{
    if (!_logoArray) {
        self.logoArray = [NSMutableArray new];
    }
    return _logoArray;
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
