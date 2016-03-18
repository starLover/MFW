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
#import "MainModel.h"

@interface MainViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *eightArray;
@property(nonatomic, strong) NSMutableArray *todayArray;
@property(nonatomic, strong) NSMutableArray *noteArray;
@property(nonatomic, strong) NSMutableArray *commonArray;
@property(nonatomic, strong) NSMutableArray *salesArray;
@property(nonatomic, strong) NSMutableArray *mddsArray;
@property(nonatomic, strong) NSMutableArray *userArray;
@property(nonatomic, strong) NSArray *listArray;
@property(nonatomic, strong) UIView *todayView;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self request];
}

#pragma mark    ---------------    UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    if (indexPath.row == 0) {
        [self firstCellView];
        [cell.contentView addSubview:self.todayView];
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count - 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    return view;
}
#pragma mark    ---------------    UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return kScreenHeight / 3 * 2 - 30;
    }
    return 120;
}


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
    //八个按钮
    [self eightButton];
}
//搜索方法
- (void)goToMap{
}

- (void)firstCellView{
    self.todayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight / 3 * 2)];
    UILabel *todayLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, kScreenWidth / 3, 40)];
    MainModel *todayModel = self.todayArray[0];
    todayLabel.text = todayModel.title;
    [self.todayView addSubview:todayLabel];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 60, kScreenWidth - 40, kScreenWidth / 2)];
    MainModel *noteModel = self.noteArray[0];
    [imageView sd_setImageWithURL:[NSURL URLWithString:noteModel.thumbnail]];
    [self.todayView addSubview:imageView];
    
    UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 25, kScreenWidth / 2 + 60, 50, 50)];
    MainModel *userModel = self.userArray[0];
    headImage.layer.cornerRadius = 25;
    headImage.clipsToBounds = YES;
    [headImage sd_setImageWithURL:[NSURL URLWithString:userModel.logo]];
    [self.todayView addSubview:headImage];
    
    UILabel *placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, kScreenWidth / 2 + 125 , kScreenWidth - 40, 30)];
    placeLabel.textAlignment = NSTextAlignmentCenter;
    MainModel *mddsModel = self.mddsArray[0];
    placeLabel.text = [NSString stringWithFormat:@"%@在%@", userModel.name, mddsModel.name];
    [self.todayView addSubview:placeLabel];
    UILabel *lifeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, kScreenWidth / 2 + 160 , kScreenWidth - 40, 60)];
    lifeLabel.text = noteModel.title;
    lifeLabel.textAlignment = NSTextAlignmentCenter;
    [self.todayView addSubview:lifeLabel];
}



#pragma mark       ------------------   Request
- (void)request{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    [manager GET:kButtonList parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDic = responseObject;
        NSDictionary *dataDic = responseDic[@"data"];
        self.listArray = dataDic[@"list"];
        for (NSDictionary *listDic in self.listArray) {
            NSString *style = listDic[@"style"];
            if ([style isEqualToString:@"elite_note"]) {
                //item1
                MainModel *mainModel = [[MainModel alloc] init];
                NSDictionary *dataDic = listDic[@"data"];
                [mainModel setValuesForKeysWithDictionary:dataDic];
                [self.todayArray addObject:mainModel];
                
                MainModel *noteModel = [[MainModel alloc] init];
                NSDictionary *noteDic = dataDic[@"note"];
                [noteModel setValuesForKeysWithDictionary:noteDic];
                [self.noteArray addObject:noteModel];
                
                NSArray *mddsArray = noteDic[@"mdds"];
                MainModel *mddsModel = [[MainModel alloc] init];
                [mddsModel setValuesForKeysWithDictionary:mddsArray[0]];
                [self.mddsArray addObject:mddsModel];
                
                MainModel *userModel = [[MainModel alloc] init];
                [userModel setValuesForKeysWithDictionary:noteDic[@"user"]];
                [self.userArray addObject:userModel];
                
            } else if ([style isEqualToString:@"common_squares"]) {
                //item2 and item4
            } else if ([style isEqualToString:@"sales_mdds"]){
                //item3
            }
            //
            
        }
        
        NSArray *dataArray = self.listArray[0][@"data"];
        for (NSDictionary *dic in dataArray) {
            MainModel *mainModel = [[MainModel alloc] init];
            [mainModel setValuesForKeysWithDictionary:dic];
            [self.eightArray addObject:mainModel];
        }
        [self configHeaderView];
        [self.tableView reloadData];
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
        self.tableView.rowHeight = 120;
    }
    return _tableView;
}
- (NSMutableArray *)eightArray{
    if (_eightArray == nil) {
        self.eightArray = [NSMutableArray new];
    }
    return _eightArray;
}

- (NSMutableArray *)todayArray{
    if (_todayArray == nil) {
        self.todayArray = [NSMutableArray new];
    }
    return _todayArray;
}
- (NSMutableArray *)commonArray{
    if (_commonArray == nil) {
        self.commonArray = [NSMutableArray new];
    }
    return _commonArray;
}
- (NSMutableArray *)salesArray{
    if (_salesArray == nil) {
        self.salesArray = [NSMutableArray new];
    }
    return _salesArray;
}
- (NSMutableArray *)mddsArray{
    if (_mddsArray == nil) {
        self.mddsArray = [NSMutableArray new];
    }
    return _mddsArray;
}
- (NSMutableArray *)userArray{
    if (_userArray == nil) {
        self.userArray = [NSMutableArray new];
    }
    return _userArray;
}
- (NSMutableArray *)noteArray{
    if (_noteArray == nil) {
        self.noteArray = [NSMutableArray new];
    }
    return _noteArray;
}
#pragma mark   -------------   EightButton
- (void)eightButton{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth / 2)];
    
    for (NSInteger i = 0; i < 2; i++) {
        for (NSInteger j = 0; j < 4; j++) {
            MainModel *model = self.eightArray[i * 4 + j];
            //按钮图片
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20 + j * kScreenWidth / 4, 10 + i * kScreenWidth / 4, (kScreenWidth - 40) / 4 - 30, (kScreenWidth - 40) / 4 - 30)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.icon]];
            //按钮标题
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10 + j * kScreenWidth / 4, kScreenWidth / 4 * (i + 1) - 20, (kScreenWidth - 40) / 4 - 20, 20)];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = model.title;
            [view addSubview:imageView];
            [view addSubview:label];
            
            //按钮
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i * 4 + j + 100;
            btn.frame = CGRectMake(j * kScreenWidth / 4, i * kScreenWidth / 4, kScreenWidth / 4, kScreenWidth / 4);
            [btn addTarget:self action:@selector(eightAction:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
        }
    }
    self.tableView.tableHeaderView = view;
}

- (void)eightAction:(UIButton *)btn{
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
