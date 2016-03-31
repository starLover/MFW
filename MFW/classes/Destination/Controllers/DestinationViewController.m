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
#import "StrategyViewController.h"
#import "Scenic2ViewController.h"
#import "Grogshop2ViewController.h"
#import "Food2ViewController.h"
#import "Shopping2ViewController.h"
#import "Entertain2ViewController.h"
#import "TravelogueViewController.h"
#import "GDViewController.h"
#import "AnswerViewController.h"
@interface DestinationViewController ()<UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)UIImageView *imageview;
@property(nonatomic,retain)UIActivityIndicatorView *activityView;
@property(nonatomic,strong)UITextField *searchFiled;
@property(nonatomic,strong)UIImageView *searchImage;
@property(nonatomic,assign)CGFloat lat;
@property(nonatomic,assign)CGFloat lng;
@property(nonatomic,copy)NSString *url;
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
//    //设置导航栏为全透明，且去掉边框黑线
//    [self.navigationController.navigationBar setTranslucent:YES];
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    //去黑线
//    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    //导航栏的view
//    UILabel *label = [[UILabel alloc]initWithFrame:self.navigationController.navigationBar.frame];
//    label.backgroundColor = [UIColor yellowColor];
//    [self.navigationController.view addSubview:label];
    //添加UIsearchBar

    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    [self requestModel];
    
}
- (void)searchAction{
    self.searchFiled = [[UITextField alloc]initWithFrame:CGRectMake(60, 30, kScreenWidth-120, 30)];
    self.searchFiled.placeholder = @"搜周边";
    self.searchFiled.keyboardType = UIKeyboardTypeWebSearch;
    self.searchFiled.borderStyle = UITextBorderStyleRoundedRect;
    self.searchFiled.delegate = self;
    [self.navigationController.view addSubview:self.searchFiled];
    self.searchImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-90, 35, 20, 20)];
    self.searchImage.image = [UIImage imageNamed:@"cityselect_search_icon"];
    [self.navigationController.view addSubview:self.searchImage];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self.view resignFirstResponder];
    GDViewController *cgVC = [[GDViewController alloc]init];
    cgVC.string = self.searchFiled.text;
    if (cgVC.string.length > 0) {
    [self.navigationController pushViewController:cgVC animated:YES];
    }
    return YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [self searchAction];
}
- (void)viewWillDisappear:(BOOL)animated{
    [self.searchFiled removeFromSuperview];
    [self.searchImage removeFromSuperview];
}
#pragma mark --------- UITableViewDataSource
- (void)configTableViewHeaderView{
    
    self.tableViewHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight*3/4-20)];
//    self.tableViewHeaderView.backgroundColor = [UIColor cyanColor];
    
    self.imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, self.tableViewHeaderView.frame.size.height/2)];
    [self.imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.header_img]] placeholderImage:nil];
    UILabel *back = [[UILabel alloc]initWithFrame:self.imageview.frame];
    back.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.2];
    [self.imageview addSubview:back];
    
    [self.tableViewHeaderView addSubview:self.imageview];
    self.tableView.tableHeaderView = self.tableViewHeaderView;
    [self navBarBtn];
}
-(void)latlng{

    CLLocation *location = [[CLLocation alloc] initWithLatitude:self.lat longitude:self.lng];
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DestinationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[DestinationTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    if (indexPath.row == 0) {
        self.mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight/2)];
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
    return kScreenHeight/2;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    DestinationModel *titleModel = self.titleArray[section];
    return @"附近地图";
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        GDViewController *gdVC = [[GDViewController alloc]init];
        
        [self.navigationController pushViewController:gdVC animated:YES];
    }
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
        NSDictionary *item5 = icons[5];
        self.url = item5[@"jump_url"];
        
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
//        NSLog(@"title = %lu",self.titleArray.count);
//        NSLog(@"list = %lu",self.listArray.count);
//        NSLog(@"item = %lu",self.itemArray.count);
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
    backBtn.frame = CGRectMake(0, 30, 30, 30);
    [backBtn setBackgroundColor:[UIColor orangeColor]];
    [backBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    backBtn.tag = 100;
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    //收藏按钮
    UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    collectBtn.frame = CGRectMake(30, 30, 30, 30);
    [collectBtn setBackgroundColor:[UIColor orangeColor]];
    [collectBtn setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
    [collectBtn addTarget:self action:@selector(goAction:) forControlEvents:UIControlEventTouchUpInside];
    collectBtn.tag = 101;
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc]initWithCustomView:collectBtn];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    
    self.nameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nameBtn.frame = CGRectMake(20, self.imageview.frame.size.height/10, 50, 20);
    [self.nameBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    DestinationModel *model = self.mddArray[0];
    [self.nameBtn setTitle:model.name forState:UIControlStateNormal];
    self.nameBtn.titleLabel.font = [UIFont systemFontOfSize:25];
    [self.imageview addSubview:self.nameBtn];
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, self.imageview.frame.size.height/10+20, kScreenWidth/3, 30)];
    DestinationModel *numModel = self.numUrlArray[0];
    timeLabel.text = numModel.title;
    timeLabel.font = [UIFont systemFontOfSize:14];
    timeLabel.textColor = [UIColor whiteColor];
    [self.imageview addSubview:timeLabel];
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(75, self.imageview.frame.size.height / 10 + 40, 120, 30)];
    textLabel.text = @"人正在这里旅行";
    textLabel.textColor = [UIColor whiteColor];
    [self.imageview addSubview:textLabel];
    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, self.imageview.frame.size.height / 10+40, 60, 30)];
    numLabel.text = [numModel.num stringValue];
    numLabel.textColor = [UIColor whiteColor];
    numLabel.font = [UIFont systemFontOfSize:24];
    [self.imageview addSubview:numLabel];
    //背景图按钮
    UIButton *numBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    numBtn.frame = CGRectMake(20, 0, kScreenWidth-40,self.imageview.frame.size.height/2-10);
    numBtn.tag = 102;
    [numBtn addTarget:self action:@selector(goAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableViewHeaderView addSubview:numBtn];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-40, 40, 40, 40)];
    imageView.image = [UIImage imageNamed:@"icon_back_nromal"];
    [self.imageview addSubview:imageView];
    
    //图片集
    for (int i = 0; i < self.albumArray.count; i++) {
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(20+(((kScreenWidth-60)/3)+10)*i,self.imageview.frame.size.height*1/2, (kScreenWidth-60)/3,self.imageview.frame.size.height/2-10)];
        [imageV sd_setImageWithURL:[NSURL URLWithString:self.albumArray[i]] placeholderImage:nil];
        [self.imageview addSubview:imageV];
        UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        imageBtn.frame = CGRectMake(20+(((kScreenWidth-60)/3)+10)*i,self.imageview.frame.size.height*1/2, (kScreenWidth-60)/3,self.imageview.frame.size.height/2-10);
        imageBtn.tag = 103+i;
        [imageBtn addTarget:self action:@selector(goAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.tableViewHeaderView addSubview:imageBtn];
        
    }
    UILabel *more = [[UILabel alloc]initWithFrame:CGRectMake(20+(((kScreenWidth-60)/3)+10)*2, self.imageview.frame.size.height/2, (kScreenWidth-60)/3+2,self.imageview.frame.size.height/2-10)];
    more.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    DestinationModel *moreModel = self.mddArray[0];
    more.text = [moreModel.num_album stringValue];
    more.textAlignment = NSTextAlignmentCenter;
    more.textColor = [UIColor whiteColor];
    [self.imageview addSubview:more];
    UILabel *much = [[UILabel alloc]initWithFrame:CGRectMake(20+(((kScreenWidth-60)/3)+10)*2, self.imageview.frame.size.height/2+40, (kScreenWidth-60)/3+2,self.imageview.frame.size.height/4+5)];
    much.backgroundColor = [UIColor clearColor] ;
    much.textAlignment = NSTextAlignmentCenter;
    much.textColor = [UIColor whiteColor];
    much.text = @"张照片";
    [self.imageview addSubview:much];
    
        
    for (NSInteger i = 0; i < 2; i++) {
        for (NSInteger j = 0; j < 4; j++) {
            DestinationModel *btnModel = self.btnArray[i * 4 + j];
            //按钮图片
            UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(20 + j * kScreenWidth / 4, 10 + i * kScreenWidth / 4+self.tableViewHeaderView.frame.size.height/2+self.imageview.frame.size.height/15, (kScreenWidth - 40) / 4 - 30, (kScreenWidth - 40) / 4 - 30)];
            [imageview sd_setImageWithURL:[NSURL URLWithString:btnModel.icon]];
            //按钮标题
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(6 + j * kScreenWidth / 4, kScreenWidth / 4 * (i + 1) - 20+self.tableViewHeaderView.frame.size.height/2+self.imageview.frame.size.height/18, (kScreenWidth - 40) / 4 , 20)];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = btnModel.title;
            [self.tableViewHeaderView addSubview:imageview];
            [self.tableViewHeaderView addSubview:label];
            
            //按钮
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i * 4 + j + 100;
            btn.frame = CGRectMake(j * kScreenWidth / 4, i * kScreenWidth / 4+self.tableViewHeaderView.frame.size.height/2+self.imageview.frame.size.height/11, kScreenWidth / 4, kScreenWidth / 4);
            [btn addTarget:self action:@selector(eightAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.tableViewHeaderView addSubview:btn];
        }
    }
    
}
- (void)goAction:(UIButton *)btn{
    switch (btn.tag-100) {
        case 0:
        {
            GDViewController *gdVC = [[GDViewController alloc]init];
            [self.navigationController pushViewController:gdVC animated:YES];
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
            StrategyViewController *stategyVC = [[StrategyViewController alloc]init];
            [self.navigationController pushViewController:stategyVC animated:YES];
        }
            break;
        case 1:
        {
            Scenic2ViewController *scenicVC = [[Scenic2ViewController alloc]init];
            [self.navigationController pushViewController:scenicVC animated:YES];
            
        }
            break;
        case 2:
        {
            Grogshop2ViewController *hotelVC = [[Grogshop2ViewController alloc]init];
            [self.navigationController pushViewController:hotelVC animated:YES];
        }
            break;
        case 3:
        {
            Food2ViewController *foodVC = [[Food2ViewController alloc]init];
            [self.navigationController pushViewController:foodVC animated:YES];
        }
            break;
        case 4:
        {
            TravelogueViewController *traverVC = [[TravelogueViewController alloc]init];
            [self.navigationController pushViewController:traverVC animated:YES];
            
        }
            break;
        case 5:
        {
            AnswerViewController *answerVC = [[AnswerViewController alloc]init];
            [self.navigationController pushViewController:answerVC animated:YES];
//            TravelDetailViewController *travelVC = [[TravelDetailViewController alloc]init];
//            travelVC.url = self.url;
//            [self.navigationController pushViewController:travelVC animated:YES];
            
        }
            break;
        case 6:
        {
            Shopping2ViewController *shopVC = [[Shopping2ViewController alloc]init];
            [self.navigationController pushViewController:shopVC animated:YES];
            
        }
            break;
        case 7:
        {
            Entertain2ViewController *entertainmentVC = [[Entertain2ViewController alloc]init];
            [self.navigationController pushViewController:entertainmentVC animated:YES];
            
        }
            break;
            
        default:
            break;
    }

}


#pragma mark --------- Lazy
//菊花初始化
- (UIActivityIndicatorView *)activityView{
    if (!_activityView) {
        self.activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.activityView.backgroundColor = [UIColor grayColor];
        self.activityView.center = self.view.center;
    }
    return _activityView;
}
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
