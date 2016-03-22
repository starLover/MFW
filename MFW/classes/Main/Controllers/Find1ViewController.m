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
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier1"];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier2"];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    
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
    if (self.countryArray.count > 0) {
        MainModel *model = self.countryNameArray[indexPath.row];
        cell.textLabel.text = model.name;
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.countryNameArray.count;
}
#pragma mark    --------------   UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        theFirst = YES;
    } else {
        theFirst = NO;
        select = indexPath.row + 1;
    }
}

#pragma mark    --------------   UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (theFirst) {
        static NSString *cellIdentifier = @"cellIdentifier1";
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.layer.borderColor = [UIColor grayColor].CGColor;
        cell.layer.borderWidth = 1.0;
        cell.layer.cornerRadius = 20;
        cell.clipsToBounds = YES;
        cell.backgroundColor = [UIColor greenColor];
    }
    static NSString *cellIdentifier = @"cellIdentifier2";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.width)];
//    NSArray *array = self.bigArray[select];
//    MainModel *model = array[indexPath.row];
//    [imageView sd_setImageWithURL:[NSURL URLWithString:model.thumbnail]];
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, cell.frame.size.width, cell.frame.size.width, 20)];
//    label.text = model.name;
//    [cell.contentView addSubview:imageView];
//    [cell.contentView addSubview:label];
    
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    NSArray *array = self.hotArray[section];
    return 10;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
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
    
    UICollectionReusableView *headerView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
    UILabel *label = [[UILabel alloc] initWithFrame:headerView.frame];
    if (indexPath.section == 0) {
        label.text = @"国内热门城市";
    } else if(indexPath.section == 1) {
        label.text = @"国外热门城市";
        NSLog(@"ddd");
    }
    [headerView addSubview:label];
    headerView.backgroundColor = [UIColor redColor];
    return headerView;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(collectionView.frame.size.width, 30);
}
#pragma mark    --------------   UICollectionViewDelegate


#pragma mark    --------------      网络请求

- (void)request{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", nil];
    NSLog(@"%@",kFindMap);
    [manager GET:kFindMap parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"52");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject); 
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
            
            for (NSDictionary *detailDic in childArray) {
                MainModel *chlidModel = [[MainModel alloc] init];
                [chlidModel setValuesForKeysWithDictionary:detailDic];
                [self.countryArray addObject:chlidModel];
            }
            [self.bigArray addObject:self.countryArray];
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
}
@end
