//
//  DestinationViewController.m
//  MFW
//
//  Created by wanghongxiao on 16/3/17.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import "DestinationViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "DestinationTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DestinationModel.h"
#import <MapKit/MKMapView.h>
#import "HeadImageViewController.h"
#import "AlubmViewController.h"
@interface DestinationViewController ()<UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)UIView *tableViewHeaderView;
@property(nonatomic,strong)NSMutableArray *btnArray;
@property(nonatomic,strong)NSMutableArray *listArray;
@property(nonatomic,strong)NSMutableArray *albumArray;
@property(nonatomic,strong)NSMutableArray *mddArray;
@property(nonatomic,strong)NSMutableArray *numUrlArray;
@property(nonatomic,strong)NSMutableArray *titleArray;
@property(nonatomic,strong)NSMutableArray *itemArray;

@property(nonatomic,strong)UIImage *header_img;
@property(nonatomic,strong)UIButton *nameBtn;
@property(nonatomic,strong)MKMapView *mapView;

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
- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}
#pragma mark --------- UITableViewDataSource
- (void)configTableViewHeaderView{
    
    self.tableViewHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, -64, kScreenWidth, kScreenHeight/4*3-20)];
//    self.tableViewHeaderView.backgroundColor = [UIColor cyanColor];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight/4*3/2+20)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.header_img]] placeholderImage:nil];
    UILabel *back = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight/4*3/2+20)];
    back.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.2];
    [imageView addSubview:back];
    
    [self.tableViewHeaderView addSubview:imageView];
    self.tableView.tableHeaderView = self.tableViewHeaderView;
    [self navBarBtn];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DestinationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[DestinationTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    if (indexPath.row == 0) {
        self.mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight/3)];
        self.mapView.delegate = self;
        [cell.contentView addSubview:self.mapView];
    }
//    if (indexPath.row == 1) {
//        <#statements#>
//    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kScreenHeight/3;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.titleArray.count;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    DestinationModel *titleModel = self.titleArray[section];
    return titleModel.title;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}
#pragma mark ---------
#pragma mark --------- 
#pragma mark --------- 
#pragma mark ---------  CustomMethod
- (void)firstCell{
    

}
- (void)secondCell{
    
}

- (void)thirdCell{
    
}

- (void)forthCell{
    
}


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
        for (NSDictionary *itemDic in list) {
            
//            DestinationModel *model = [[DestinationModel alloc]init];
//            [model setValuesForKeysWithDictionary:itemDic];
//            [self.listArray addObject:model];
            NSDictionary *datadic = itemDic[@"data"];
            DestinationModel *model = [[DestinationModel alloc]init];
            [model setValuesForKeysWithDictionary:datadic];
            [self.titleArray addObject:model];
            self.listArray = datadic[@"list"];
            for (NSDictionary *dic in self.listArray) {
                DestinationModel *cmodel = [[DestinationModel alloc]init];
                [cmodel setValuesForKeysWithDictionary:dic];
                [self.itemArray addObject:cmodel];
            }
        }
        NSLog(@"title = %lu",self.titleArray.count);
        NSLog(@"list = %lu",self.listArray.count);
        NSLog(@"item = %lu",self.itemArray.count);
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
        
        [self.tableView reloadData];
        [self configTableViewHeaderView];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
- (void)navBarBtn{
    //左边栏按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 30, 44);
    [backBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    backBtn.tag = 100;
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    //收藏按钮
    UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    collectBtn.frame = CGRectMake(30, 0, 30, 44);
    [collectBtn setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
    [collectBtn addTarget:self action:@selector(goAction:) forControlEvents:UIControlEventTouchUpInside];
    collectBtn.tag = 101;
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc]initWithCustomView:collectBtn];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    
    self.nameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nameBtn.frame = CGRectMake(20, collectBtn.frame.size.height+30, 50, 40);
    [self.nameBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    DestinationModel *model = self.mddArray[0];
    [self.nameBtn setTitle:model.name forState:UIControlStateNormal];
    self.nameBtn.titleLabel.font = [UIFont systemFontOfSize:25];
    [self.tableViewHeaderView addSubview:self.nameBtn];
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, collectBtn.frame.size.height+60, 100, 35)];
    DestinationModel *numModel = self.numUrlArray[0];
    timeLabel.text = numModel.title;
    timeLabel.font = [UIFont systemFontOfSize:14];
    timeLabel.textColor = [UIColor whiteColor];
    [self.tableViewHeaderView addSubview:timeLabel];
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, collectBtn.frame.size.height+85, 120, 40)];
    textLabel.text = @"人正在这里旅行";
    textLabel.textColor = [UIColor whiteColor];
    [self.tableViewHeaderView addSubview:textLabel];
    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, collectBtn.frame.size.height+85, 60, 40)];
    numLabel.text = [numModel.num stringValue];
    numLabel.textColor = [UIColor whiteColor];
    numLabel.font = [UIFont systemFontOfSize:24];
    [self.tableViewHeaderView addSubview:numLabel];
    //地方按钮
    UIButton *numBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    numBtn.frame = CGRectMake(20, self.tableViewHeaderView.frame.size.height/8, kScreenWidth,  self.tableViewHeaderView.frame.size.height/8+20);
    numBtn.tag = 102;
    [numBtn addTarget:self action:@selector(goAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableViewHeaderView addSubview:numBtn];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-40, self.tableViewHeaderView.frame.size.height/5, 40, 50)];
    imageView.image = [UIImage imageNamed:@"icon_back_nromal"];
    [self.tableViewHeaderView addSubview:imageView];
    
    //图片集
    for (int i = 0; i < self.albumArray.count; i++) {
            UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(20+(((kScreenWidth-60)/3)+10)*i, collectBtn.frame.size.height+130, (kScreenWidth-60)/3,(kScreenHeight-40)/7)];
            [imageV sd_setImageWithURL:[NSURL URLWithString:self.albumArray[i]] placeholderImage:nil];
            [self.tableViewHeaderView addSubview:imageV];
        UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        imageBtn.frame = CGRectMake(20+(((kScreenWidth-60)/3)+10)*i, collectBtn.frame.size.height+130, (kScreenWidth-60)/3,(kScreenHeight-40)/7);
        imageBtn.tag = 103+i;
        [imageBtn addTarget:self action:@selector(goAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.tableViewHeaderView addSubview:imageBtn];
        
    }
    UILabel *more = [[UILabel alloc]initWithFrame:CGRectMake(20+(((kScreenWidth-60)/3)+10)*2, collectBtn.frame.size.height+130, (kScreenWidth-60)/3,(kScreenHeight-40)/7)];
    more.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    DestinationModel *moreModel = self.mddArray[0];
    more.text = [moreModel.num_album stringValue];
    more.textAlignment = NSTextAlignmentCenter;
    more.textColor = [UIColor whiteColor];
    [self.tableViewHeaderView addSubview:more];
    UILabel *much = [[UILabel alloc]initWithFrame:CGRectMake(20+(((kScreenWidth-60)/3)+10)*2, collectBtn.frame.size.height+130+65, (kScreenWidth-60)/3,15)];
    much.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    much.textAlignment = NSTextAlignmentCenter;
    much.textColor = [UIColor whiteColor];
    much.text = @"张照片";
    [self.tableViewHeaderView addSubview:much];

    
    
    for (NSInteger i = 0; i < 2; i++) {
        for (NSInteger j = 0; j < 4; j++) {
            DestinationModel *btnModel = self.btnArray[i * 4 + j];
            //按钮图片
            UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(20 + j * kScreenWidth / 4, 10 + i * kScreenWidth / 4+self.tableViewHeaderView.frame.size.height/2+40, (kScreenWidth - 40) / 4 - 30, (kScreenWidth - 40) / 4 - 30)];
            [imageview sd_setImageWithURL:[NSURL URLWithString:btnModel.icon]];
            //按钮标题
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15 + j * kScreenWidth / 4, kScreenWidth / 4 * (i + 1) - 20+self.tableViewHeaderView.frame.size.height/2+40, (kScreenWidth - 40) / 4 - 20, 20)];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = btnModel.title;
            [self.tableViewHeaderView addSubview:imageview];
            [self.tableViewHeaderView addSubview:label];
            
            //按钮
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i * 4 + j + 100;
            btn.frame = CGRectMake(j * kScreenWidth / 4, i * kScreenWidth / 4+self.tableViewHeaderView.frame.size.height/2+40, kScreenWidth / 4, kScreenWidth / 4);
            [btn addTarget:self action:@selector(eightAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.tableViewHeaderView addSubview:btn];
        }
    }
    
}
- (void)goAction:(UIButton *)btn{
    switch (btn.tag-100) {
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
            HeadImageViewController *headVC = [[HeadImageViewController alloc]init];
            [self.navigationController pushViewController:headVC animated:YES];
        }
            break;
        case 3:
        {
            AlubmViewController *alubmVC = [[AlubmViewController alloc]init];
            [self.navigationController pushViewController:alubmVC animated:YES];
        }
            break;
        case 4:
        {
            AlubmViewController *alubmVC = [[AlubmViewController alloc]init];
            [self.navigationController pushViewController:alubmVC animated:YES];
        }
            break;
        case 5:
        {
            AlubmViewController *alubmVC = [[AlubmViewController alloc]init];
            [self.navigationController pushViewController:alubmVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}
- (void)eightAction:(UIButton *)btn{
    switch (btn.tag - 100) {
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
        case 3:
        {
            
        }
            break;
        case 4:
        {
            
        }
            break;
        case 5:
        {
            
        }
            break;
        case 6:
        {
            
        }
            break;
        case 7:
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
- (NSMutableArray *)titleArray{
    if (!_titleArray) {
        self.titleArray = [NSMutableArray new];
    }
    return _titleArray;
}
- (NSMutableArray *)itemArray{
    if (!_itemArray) {
        self.itemArray = [NSMutableArray new];
    }
    return _itemArray;
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
