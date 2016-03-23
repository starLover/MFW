//
//  AlubmViewController.m
//  MFW
//
//  Created by scjy on 16/3/20.
//  Copyright © 2016年 李志鹏. All rights reserved.
//

#import "AlubmViewController.h"
#import "CollectionViewCell.h"
#import "AoiroSoraLayout.h"
#import "BLImageSize.h"
#import "AlubmModel.h"
#import "ScrollViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
@interface AlubmViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,AoiroSoraLayoutDelegate>
{
    NSInteger _offset;
}
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *heightArray;//存储图片高度
@property(nonatomic,strong)UIImage *image; // 如果计算图片尺寸失败  则下载图片直接计算
//@property(nonatomic,strong)NSMutableArray *simgArray;
@property(nonatomic,strong)NSMutableArray *imageArray;

@end

@implementation AlubmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _offset = 0;
    //注册
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self showBackBtn];
    [self requestModel];
}
#pragma mark ---------
#pragma mark ---------
#pragma mark ---------
#pragma mark --------- 下拉刷新上拉加载
#pragma mark ---------UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.alubmModel = self.imageArray[indexPath.row];
    //加载失败重新加载
    AlubmModel *model = self.imageArray[indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.simg] placeholderImage:nil];
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageArray.count;
}
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        AoiroSoraLayout *layout = [[AoiroSoraLayout alloc] init];
        layout.interSpace = 5; // 每个item 的间隔
        layout.edgeInsets = UIEdgeInsetsMake(kScreenWidth*5/375,kScreenHeight* 5/667, kScreenWidth*5/375,kScreenHeight* 5/667);
        layout.colNum = 2; // 列数;
        layout.delegate = self;
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:layout];
        
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.backgroundColor = [UIColor clearColor];
        [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [self.view addSubview:self.collectionView];
    }
    return _collectionView;
}
#pragma mark --------- 返回每个item的高度
- (CGFloat)itemHeightLayOut:(AoiroSoraLayout *)layOut indexPath:(NSIndexPath *)indexPath{
    if ([self.heightArray[indexPath.row] integerValue] < 0 || !self.heightArray[indexPath.row]) {
        return  kScreenWidth* 150/375;
    }
    else
    {
        NSInteger intger = [self.heightArray[indexPath.row] integerValue];
        return intger;
    }
}

#pragma mark -- 获取 图片 和 图片的比例高度
- (void)getImageWithURL:(NSString *)url
{
    // 获取图片
    CGSize  size = [BLImageSize dowmLoadImageSizeWithURL:url];
    // 获取图片的高度并按比例压缩
    NSInteger itemHeight = size.height * (((self.view.frame.size.width - 20) / 2 / size.width));
    NSNumber * number = [NSNumber numberWithInteger:itemHeight];
    [self.heightArray addObject:number];
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ScrollViewController *scrollView = [[ScrollViewController alloc]init];
//    AlubmModel *model = self.imageArray[indexPath.row];
//    scrollView.data = [NSString stringWithFormat:@"%@,%@",model.bimg,kAlbum];
    scrollView.num = indexPath.row;
    [self.navigationController pushViewController:scrollView animated:NO];
    
}
#pragma mark --------- 网络请求
- (void)requestModel{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
//    NSString *url = [NSString stringWithFormat:@"%@&offset=%lu",kAlbum,(long)_offset];
//    NSString *url = [NSString stringWithFormat:@"%@&%ld",kAlbum,_offset];
    [sessionManager GET:kAlbum parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *resultDic = responseObject;
        NSDictionary *data = resultDic[@"data"];
        NSArray *list = data[@"list"];
        for (NSDictionary *dic in list) {
            AlubmModel *model = [[AlubmModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.imageArray addObject:model];
            [self getImageWithURL:model.simg];
        }
        [self.collectionView reloadData];
        [self.view addSubview:self.collectionView];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}
#pragma mark -------- Lazy
- (NSMutableArray *)heightArray{
    if (!_heightArray) {
        self.heightArray = [NSMutableArray new];
    }
    return _heightArray;
}
- (NSMutableArray *)imageArray{
    if (!_imageArray) {
        self.imageArray = [NSMutableArray new];
    }
    return _imageArray;
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
