//
//  Find1ViewController.m
//  MFW
//
//  Created by wanghongxiao on 16/3/19.
//  Copyright © 2016年 李志鹏. All rights reserved.
//

#import "Find1ViewController.h"
#import <AFHTTPSessionManager.h>
#import <UIImageView+WebCache.h>
#import "MainModel.h"
#import "SearchCityViewController.h"
#import "DestinationViewController.h"


@interface Find1ViewController ()<UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate>
{
    BOOL theFirst;
    NSInteger select;
}
- (IBAction)searchAction:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *leftTableView;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray *countryArray;
@property(nonatomic, strong) NSMutableArray *NameArray;
@property(nonatomic, strong) NSMutableArray *countryNameArray;
@property(nonatomic, strong) NSMutableArray *topArray;
@property(nonatomic, strong) NSMutableArray *hotNameArray;
@property(nonatomic, strong) NSMutableArray *hotArray;
@property(nonatomic, strong) NSMutableArray *bigArray;

@end

@implementation Find1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"找攻略";
    theFirst = YES;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier1"];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier2"];
    
    
    [self showBackBtn];
    [self request];
}
#pragma mark    --------------   UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
//    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
//    cell.selectedBackgroundView.backgroundColor = [UIColor redColor];
    if (self.countryNameArray.count > 0) {
        MainModel *model = self.countryNameArray[indexPath.row];
        cell.textLabel.text = model.name;
        cell.textLabel.font = [UIFont systemFontOfSize:20.0];
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.countryNameArray.count;
}

#pragma mark    --------------   UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tableView.frame.size.width / 4 * 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        theFirst = YES;
    } else {
        theFirst = NO;
        select = indexPath.row - 1;
    }
    [self.collectionView reloadData];
}

#pragma mark    --------------   UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (theFirst) {
        static NSString *cellIdentifier = @"cellIdentifier1";
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        for (id subview in cell.contentView.subviews) {
            [subview removeFromSuperview];
        }
        cell.layer.borderColor = [UIColor grayColor].CGColor;
        cell.layer.borderWidth = 1.0;
        cell.layer.cornerRadius = 20;
        cell.clipsToBounds = YES;
        NSArray *array = self.hotArray[indexPath.section];
        MainModel *model = array[indexPath.row];
        UILabel *label = [[UILabel alloc] initWithFrame:cell.contentView.frame];
        label.text = model.name;
        label.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:label];
        return cell;
    }
    static NSString *cellIdentifier = @"cellIdentifier2";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    for (id subview in cell.contentView.subviews) {
        [subview removeFromSuperview];
    }
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.width)];
    NSArray *array = self.bigArray[select];
    if (indexPath.row < array.count) {
        MainModel *model = array[indexPath.row];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.thumbnail]];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, cell.frame.size.width, cell.frame.size.width, 20)];
        label.font = [UIFont systemFontOfSize:15.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = model.name;
        [cell.contentView addSubview:imageView];
        [cell.contentView addSubview:label];
    }
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *array = nil;
    if (theFirst) {
        array = self.hotArray[section];
    } else {
        array = self.bigArray[select];
    }
    return array.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (theFirst) {
        return self.hotArray.count;
    }
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (theFirst) {
        return CGSizeMake(collectionView.frame.size.width / 4, 40);
    }
    return CGSizeMake((collectionView.frame.size.width - 60) / 3, (collectionView.frame.size.width - 60) / 3 + 20);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (theFirst) {
        return UIEdgeInsetsMake(20, 20, 20, 20);
    }
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 20;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    for (UIView *subView in headerView.subviews) {
        [subView removeFromSuperview];
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, collectionView.frame.size.width, 44)];
    
    MainModel *model = self.hotNameArray[indexPath.section];
    label.textColor = [UIColor orangeColor];
    label.backgroundColor = [UIColor grayColor];
    label.text = [NSString stringWithFormat:@"    %@", model.name];
    [headerView addSubview:label];
    return headerView;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (theFirst) {
        if (section < self.hotNameArray.count) {
            return CGSizeMake(collectionView.frame.size.width, 30);
        }
    }
    return CGSizeMake(0, 0);
}
#pragma mark    --------------   UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"backTabBar" object:nil userInfo:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)dealloc{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark    --------------      网络请求

- (void)request{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", nil];
    [manager GET:kFindMap parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDic = responseObject;
        NSDictionary *dataDic = responseDic[@"data"];
        //热门
        NSArray *continetsArray = dataDic[@"continents"];
        
        //top
        NSDictionary *topDic = dataDic[@"top"];
        MainModel *topNameModel = [[MainModel alloc] init];
        [topNameModel setValuesForKeysWithDictionary:topDic];
        [self.countryNameArray addObject:topNameModel];
        NSArray *hotArray = topDic[@"groups"];
        for (NSDictionary *hotDic in hotArray) {
            MainModel *hotModel = [[MainModel alloc] init];
            [hotModel setValuesForKeysWithDictionary:hotDic];
            [self.hotNameArray addObject:hotModel];
            NSArray *array = hotDic[@"child_mdds"];
            NSMutableArray *hotCityArray = [NSMutableArray new];
            for (NSDictionary *hotCityDic in array) {
                MainModel *hotCityModel = [[MainModel alloc] init];
                [hotCityModel setValuesForKeysWithDictionary:hotCityDic];
                [hotCityArray addObject:hotCityModel];
            }
            [self.hotArray addObject:hotCityArray];
        }
        
        
        //
        for (NSDictionary *dic in continetsArray) {
            MainModel *model = [[MainModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.countryNameArray addObject:model];
            //每个国家的城市
            NSArray *childArray = dic[@"child_mdds"];
            NSMutableArray *countryArray = [NSMutableArray new];
            for (NSDictionary *detailDic in childArray) {
                MainModel *chlidModel = [[MainModel alloc] init];
                [chlidModel setValuesForKeysWithDictionary:detailDic];
                [countryArray addObject:chlidModel];
            }
            [self.bigArray addObject:countryArray];
        }
        [self.leftTableView reloadData];
        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark      -------------    LazyLoading
- (NSMutableArray *)countryNameArray{
    if (_countryNameArray == nil) {
        self.countryNameArray = [NSMutableArray new];
    }
    return _countryNameArray;
}
- (NSMutableArray *)countryArray{
    if (_countryArray == nil) {
        self.countryArray = [NSMutableArray new];
    }
    return _countryArray;
}
- (NSMutableArray *)topArray{
    if (_topArray == nil) {
        self.topArray = [NSMutableArray new];
    }
    return _topArray;
}
- (NSMutableArray *)hotArray{
    if (_hotArray == nil) {
        self.hotArray = [NSMutableArray new];
    }
    return _hotArray;
}
- (NSMutableArray *)hotNameArray{
    if (_hotNameArray == nil) {
        self.hotNameArray = [NSMutableArray new];
    }
    return _hotNameArray;
}
- (NSMutableArray *)bigArray{
    if (_bigArray == nil) {
        self.bigArray = [NSMutableArray new];
    }
    return _bigArray;
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

- (IBAction)searchAction:(id)sender {
    SearchCityViewController *searchVC = [[SearchCityViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}
@end
