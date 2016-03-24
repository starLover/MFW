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
#import "CommonCollectionViewCell.h"
#import "SalesCollectionViewCell.h"
#import "HeadViewController.h"
#import "SearchCityViewController.h"
#import "Find1ViewController.h"
#import "HotelViewController.h"
#import "LookNoteViewController.h"
#import "TravelWorldViewController.h"

@interface MainViewController ()<UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    NSInteger section1;
}
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *eightArray;
@property(nonatomic, strong) NSMutableArray *todayArray;
@property(nonatomic, strong) NSMutableArray *noteArray;
@property(nonatomic, strong) NSMutableArray *commonArray;
@property(nonatomic, strong) NSMutableArray *salesArray;
@property(nonatomic, strong) NSMutableArray *salesArray318;
@property(nonatomic, strong) NSArray *saleArray;
@property(nonatomic, strong) NSMutableArray *mddsArray;
@property(nonatomic, strong) NSMutableArray *userArray;
@property(nonatomic, strong) NSMutableArray *listArray318;
@property(nonatomic, strong) NSArray *listArray;
@property(nonatomic, strong) NSArray *commonArray318;
@property(nonatomic, strong) NSMutableArray *common4Array318;
@property(nonatomic, strong) NSMutableArray *common4Array;
@property(nonatomic, strong) UIView *todayView;
@property(nonatomic, strong) UIView *searchView;
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
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    //
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 60, kScreenWidth, kScreenWidth + 20) collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor whiteColor];
    //设置每一行的间距
    flowLayout.minimumLineSpacing = 10;
    //设置item的间距
    flowLayout.minimumInteritemSpacing = 5;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.scrollEnabled = NO;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, kScreenWidth - 40, 30)];
    UIButton *lookMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    lookMoreBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    if (indexPath.row > 0) {
        MainModel *mainModel = self.listArray318[0];
        label.text = mainModel.title;
        [cell.contentView addSubview:label];
        lookMoreBtn.frame = CGRectMake(kScreenWidth / 3, kScreenHeight / 4 * 3 - 50, kScreenWidth / 3, 44);
        [lookMoreBtn setTitle:mainModel.sub_title_text forState:UIControlStateNormal];
        [lookMoreBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        lookMoreBtn.layer.cornerRadius = 5;
        lookMoreBtn.layer.borderWidth = 1;
        lookMoreBtn.layer.borderColor = [UIColor orangeColor].CGColor;
        lookMoreBtn.clipsToBounds = YES;
        [cell.contentView addSubview:lookMoreBtn];
    }
    
    switch (indexPath.row) {
        case 0:
        {
            [self firstCellView];
            [cell.contentView addSubview:self.todayView];
            
        }
            break;
        case 1:
        {
            section1 = 1;
            [collectionView registerNib:[UINib nibWithNibName:@"CommonCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"collectionCell1"];
            collectionView.tag = 1;
            [cell.contentView addSubview:collectionView];
        }
            break;
        case 2:
        {
            MainModel *mainModel = self.salesArray318[0];
            label.text = mainModel.title;
            [lookMoreBtn setTitle:mainModel.sub_title_text forState:UIControlStateNormal];
            section1 = 2;
            collectionView.tag = 2;
            [collectionView registerNib:[UINib nibWithNibName:@"SalesCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"collectionCell2"];
            [cell.contentView addSubview:collectionView];
        }
            break;
        case 3:
        {
            
            MainModel *mainModel = self.common4Array318[0];
            label.text = mainModel.title;
            [lookMoreBtn setTitle:mainModel.sub_title_text forState:UIControlStateNormal];
            section1 = 3;
            collectionView.tag = 3;
            [collectionView registerNib:[UINib nibWithNibName:@"CommonCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"collectionCell3"];
            [cell.contentView addSubview:collectionView];
        }
            break;
            
        default:
            break;
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

#pragma mark     --------------     UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (section1 == 1) {
        CommonCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell1" forIndexPath:indexPath];
        cell.mainModel = self.commonArray[indexPath.row + 1];
        return cell;
    } else if (section1 == 3) {
        CommonCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell3" forIndexPath:indexPath];
        
        cell.mainModel = self.common4Array[indexPath.row];
        return cell;
    }
    SalesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell2" forIndexPath:indexPath];
    cell.mainModel = self.salesArray[indexPath.row];
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section1 == 1 || section1 == 3) {
        return self.commonArray318.count;
    }
    return self.saleArray.count;
}

#pragma mark     -------------------     UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kScreenWidth - 40) / 3, (kScreenWidth + 20 - 30) / 2);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MainModel *mainModel = nil;
    
    switch (collectionView.tag) {
        case 1:
        {
            mainModel = self.commonArray[indexPath.row + 1];
        }
            break;
        case 2:
        {
            mainModel = self.salesArray[indexPath.row];
        }
            break;
        case 3:
        {
            mainModel = self.common4Array[indexPath.row];
        }
            break;
            
        default:
            break;
    }
    HeadViewController *headVC = [[HeadViewController alloc] init];
    headVC.urlString = mainModel.jump_url;
    [self.navigationController pushViewController:headVC animated:YES];
}

#pragma mark    ---------------    UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return kScreenHeight / 3 * 2 - 30;
    }
    return kScreenHeight / 4 * 3;
}


#pragma mark   -----------------          自定义table头部

- (void)configHeaderView{
    //导航栏搜索
    self.searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    [self.navigationController.navigationBar addSubview:self.searchView];
    UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 34, 34)];
    headImageView.image = [UIImage imageNamed:@"common_loading_logo"];
    [self.searchView addSubview:headImageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, kScreenWidth / 4, 44)];
    label.text = @"小蜜蜂";
    label.textAlignment = NSTextAlignmentCenter;
    [self.searchView addSubview:label];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 3 - 10, 0, kScreenWidth / 3 * 2, 44)];
    imageView.image = [UIImage imageNamed:@"5E0492E0-20B3-46C8-8E56-8BB964210ECC"];
    [self.searchView addSubview:imageView];
    
    UIButton *bigBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bigBtn.frame = self.searchView.frame;
    [bigBtn addTarget:self action:@selector(goToMap) forControlEvents:UIControlEventTouchUpInside];
    [self.searchView addSubview:bigBtn];
    //八个按钮
    [self eightButton];
}
//搜索方法
- (void)goToMap{
    SearchCityViewController *searchVC = [[SearchCityViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
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
    placeLabel.textColor = [UIColor orangeColor];
    placeLabel.textAlignment = NSTextAlignmentCenter;
    MainModel *mddsModel = self.mddsArray[0];
    placeLabel.text = [NSString stringWithFormat:@"%@在%@", userModel.name, mddsModel.name];
    [self.todayView addSubview:placeLabel];
    
    UILabel *lifeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, kScreenWidth / 2 + 160 , kScreenWidth - 40, 60)];
    lifeLabel.text = noteModel.title;
    lifeLabel.textAlignment = NSTextAlignmentCenter;
    [self.todayView addSubview:lifeLabel];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = 100;
    btn.frame = self.todayView.frame;
    [btn addTarget:self action:@selector(jumpToFirst:) forControlEvents:UIControlEventTouchUpInside];
    [self.todayView addSubview:btn];
}



#pragma mark       ------------------   Request
- (void)request{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    [manager GET:kButtonList parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BOOL item3 = NO;
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
                if (item3 && self.commonArray.count > 0) {
                    NSDictionary *dataDic1 = listDic[@"data"];
                    MainModel *model318 = [[MainModel alloc] init];
                    [model318 setValuesForKeysWithDictionary:dataDic1];
                    [self.common4Array318 addObject:model318];
                    
                    self.commonArray318 = dataDic1[@"list"];
                    for (NSDictionary *dic in self.commonArray318) {
                        MainModel *listModel = [[MainModel alloc] init];
                        [listModel setValuesForKeysWithDictionary:dic];
                        [self.common4Array addObject:listModel];
                    }
                    
                }
                NSDictionary *dataDic1 = listDic[@"data"];
                MainModel *model318 = [[MainModel alloc] init];
                [model318 setValuesForKeysWithDictionary:dataDic1];
                [self.commonArray addObject:model318];
                [self.listArray318 addObject:model318];
                
                self.commonArray318 = dataDic1[@"list"];
                for (NSDictionary *dic in self.commonArray318) {
                    MainModel *listModel = [[MainModel alloc] init];
                    [listModel setValuesForKeysWithDictionary:dic];
                    [self.commonArray addObject:listModel];
                }
                item3 = YES;
            } else if ([style isEqualToString:@"sales_mdds"]){
                //item3
                NSDictionary *dataDic = listDic[@"data"];
                MainModel *model318 = [[MainModel alloc] init];
                [model318 setValuesForKeysWithDictionary:dataDic];
                [self.salesArray318 addObject:model318];
                self.saleArray = dataDic[@"list"];
                for (NSDictionary *dic in self.saleArray) {
                    MainModel *model = [[MainModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [self.salesArray addObject:model];
                }
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
#pragma mark     -------------   Jump To OtherViewController
- (void)jumpToFirst:(UIButton *)btn{
    MainModel *model = nil;
    switch (btn.tag - 100) {
        case 0:
        {
            model = self.noteArray[0];
        }
            break;
        default:
            break;
    }
    HeadViewController *headVC = [[HeadViewController alloc] init];
    headVC.urlString = model.jump_url;
    [self.navigationController pushViewController:headVC animated:YES];
}


#pragma mark      ---------- LazyLoading
- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
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
- (NSMutableArray *)listArray318{
    if (_listArray318 == nil) {
        self.listArray318 = [NSMutableArray new];
    }
    return _listArray318;
}
- (NSMutableArray *)salesArray318{
    if (_salesArray318 == nil) {
        self.salesArray318 = [NSMutableArray new];
    }
    return _salesArray318;
}
- (NSMutableArray *)common4Array{
    if (_common4Array == nil) {
        self.common4Array = [NSMutableArray new];
    }
    return _common4Array;
}
- (NSMutableArray *)common4Array318{
    if (_common4Array318 == nil) {
        self.common4Array318 = [NSMutableArray new];
    }
    return _common4Array318;
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
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15 + j * kScreenWidth / 4, kScreenWidth / 4 * (i + 1) - 20, (kScreenWidth - 40) / 4 - 20, 20)];
            label.font = [UIFont systemFontOfSize:16.0];
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
    self.tabBarController.tabBar.hidden = YES;
    switch (btn.tag - 100) {
        case 0:
        {
            UIStoryboard *storboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            Find1ViewController *find1VC = [storboard instantiateViewControllerWithIdentifier:@"Find1"];
            [self.navigationController pushViewController:find1VC animated:YES];
        }
            break;
        case 1:
        {
            UIStoryboard *storboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            HotelViewController *hotelVC = [storboard instantiateViewControllerWithIdentifier:@"Hotel"];
            [self.navigationController pushViewController:hotelVC animated:YES];
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
            LookNoteViewController *lookVC = [[LookNoteViewController alloc] init];
            [self.navigationController pushViewController:lookVC animated:YES];
        }
            break;
        case 5:
        {
            TravelWorldViewController *travelVC = [[TravelWorldViewController alloc] init];
            [self.navigationController pushViewController:travelVC animated:YES];
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
        case 8:
        {
            
        }
            break;
            
            
        default:
            break;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.searchView removeFromSuperview];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:self.searchView];
    self.tabBarController.tabBar.hidden = NO;
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
