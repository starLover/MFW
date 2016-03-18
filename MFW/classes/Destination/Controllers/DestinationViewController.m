//
//  DestinationViewController.m
//  MFW
//
//  Created by wanghongxiao on 16/3/17.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#import "DestinationViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "DestinationTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DestinationModel.h"
@interface DestinationViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)UIView *tableViewHeaderView;
@property(nonatomic,strong)NSMutableArray *btnArray;
@property(nonatomic,strong)NSMutableArray *listArray;
@property(nonatomic,strong)NSMutableArray *albumArray;
@property(nonatomic,strong)NSMutableArray *mddArray;
@property(nonatomic,strong)NSMutableArray *numUrlArray;
@property(nonatomic,strong)UIImage *header_img;
@property(nonatomic,strong)UIButton *nameBtn;

@end

@implementation DestinationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置导航栏为全透明，且去掉边框黑线
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //去黑线
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    //导航栏的view
//    UILabel *label = [[UILabel alloc]initWithFrame:self.navigationController.navigationBar.frame];
//    label.backgroundColor = [UIColor yellowColor];
//    [self.navigationController.view addSubview:label];
    
    
    
 
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self requestModel];
    
    
}
#pragma mark --------- UITableViewDataSource
- (void)configTableViewHeaderView{
    
    self.tableViewHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, -64, kScreenWidth, kScreenHeight/4*3-40)];
//    self.tableViewHeaderView.backgroundColor = [UIColor cyanColor];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight/4*3/2)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.header_img]] placeholderImage:nil];
//    imageView.alpha = 0.3;
    
    [self.tableViewHeaderView addSubview:imageView];
    self.tableView.tableHeaderView = self.tableViewHeaderView;
    [self navBarBtn];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DestinationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[DestinationTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}
#pragma mark ---------
#pragma mark --------- 
#pragma mark --------- 
#pragma mark --------- 

#pragma mark --------- 网络请求
- (void)requestModel{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
    [sessionManager GET:kDestination parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
       
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *resulltDic = responseObject;
        NSDictionary *dataDic = resulltDic[@"data"];
        NSArray *icons = dataDic[@"icons"];
        for (NSDictionary *dic in icons) {
             DestinationModel *model = [[DestinationModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.btnArray addObject:model];
        }
        NSArray *list = dataDic[@"list"];
        for (NSDictionary *dic in list) {
            DestinationModel *model = [[DestinationModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.listArray addObject:model];
        }
      
        NSDictionary *mdd = dataDic[@"mdd"];
        self.albumArray = mdd[@"album_example"];
        self.header_img = mdd[@"header_img"];
        DestinationModel *model = [[DestinationModel alloc]init];
        [model setValuesForKeysWithDictionary:mdd];
        [self.mddArray addObject:model];
        NSDictionary *num = mdd[@"num_url"];
        DestinationModel *numModel = [[DestinationModel alloc]init];
        [numModel setValuesForKeysWithDictionary:num];
        [self.numUrlArray addObject:numModel];

        
        [self configTableViewHeaderView];
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
- (void)navBarBtn{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 20, 44);
    [backBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    backBtn.tag = 1;
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    
    UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    collectBtn.frame = CGRectMake(kScreenWidth-30, 0, 20, 44);
    [collectBtn setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
    [collectBtn addTarget:self action:@selector(goAction:) forControlEvents:UIControlEventTouchUpInside];
    collectBtn.tag = 2;
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc]initWithCustomView:collectBtn];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    
    self.nameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nameBtn.frame = CGRectMake(20, 70, 50, 40);
    DestinationModel *model = self.mddArray[0];
    [self.nameBtn setTitle:model.name forState:UIControlStateNormal];
    self.nameBtn.titleLabel.font = [UIFont systemFontOfSize:25];
    self.nameBtn.tag = 3;
    [self.nameBtn addTarget:self action:@selector(goAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableViewHeaderView addSubview:self.nameBtn];
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 110, 70, 35)];
    DestinationModel *numModel = self.numUrlArray[0];
    timeLabel.text = numModel.title;
    timeLabel.font = [UIFont systemFontOfSize:13];
    timeLabel.textColor = [UIColor whiteColor];
    [self.tableViewHeaderView addSubview:timeLabel];
    
    
}
- (void)goAction:(UIButton *)btn{
    switch (btn.tag) {
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
- (NSMutableArray *)btnArray{
    if (_btnArray == nil) {
        self.btnArray = [NSMutableArray new];
    }
    return _btnArray;
}
- (NSMutableArray *)listArray{
    if (_listArray == nil) {
        self.listArray = [NSMutableArray new];
    }
    return _listArray;
}
- (NSMutableArray *)albumArray{
    if (!_albumArray) {
        self.albumArray = [NSMutableArray new];
    }
    return _albumArray;
}
- (NSMutableArray *)mddArray{
    if (!_mddArray) {
        self.mddArray = [NSMutableArray new];
    }
    return _mddArray;
}
-(NSMutableArray *)numUrlArray{
    if (!_numUrlArray) {
        self.numUrlArray = [NSMutableArray new];
    }
    return _numUrlArray;
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
