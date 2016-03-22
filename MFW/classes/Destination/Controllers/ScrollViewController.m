//
//  ScrollViewController.m
//  MFW
//
//  Created by scjy on 16/3/21.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import "ScrollViewController.h"
#import "AlubmModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AFNetworking/AFHTTPSessionManager.h>

@interface ScrollViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,strong)NSMutableArray *imageArray;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIImageView *imageV;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *autherLabel;
@property(nonatomic,strong)UILabel *timeLabel;

@end

@implementation ScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    [self showBackBtn];
    self.tabBarController.tabBar.hidden = YES;
    [self requestModel];
    NSLog(@"%lu",self.num);
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-150)];
//        self.scrollView.backgroundColor = [UIColor cyanColor];//self.scrollView.frame.size.height
        AlubmModel *model = self.imageArray[0];
        self.scrollView.contentSize = CGSizeMake(kScreenWidth*self.imageArray.count, [model.height integerValue]);
        self.scrollView.pagingEnabled = YES;
        self.scrollView.scrollEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = YES;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.delegate = self;
        [self gesture];
    }
    return _scrollView;
}
- (void)gesture{
    for (int i = 0; i < self.imageArray.count; i++) {
        AlubmModel *model = self.imageArray[i];
        UIScrollView *scrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(kScreenWidth*i ,0,kScreenWidth, kScreenHeight)];
        scrollV.minimumZoomScale = 1.0;
        scrollV.maximumZoomScale = 2.0;
        scrollV.delegate = self;
        
        self.imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0,-74, kScreenWidth, kScreenHeight)];
        self.imageV.tag = 100;
    
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.bimg] placeholderImage:[UIImage imageNamed:@"coffee"]];
        self.imageV.contentMode = UIViewContentModeScaleAspectFit;
        self.imageV.userInteractionEnabled = YES;
        
        //捏合手势
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchAction:)];
        
        [self.scrollView addSubview:scrollV];
        [scrollV addSubview:self.imageV];
        [self.imageV addGestureRecognizer:pinch];
        
    }
    
    NSInteger page = self.num;
    self.scrollView.contentOffset = CGPointMake(page*kScreenWidth, 0);
}
//捏合手势缩放图片方法
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    UIView *view = [scrollView viewWithTag:100];
    return view;
}

- (void)labelTextAndBtn{
    
    AlubmModel *model = self.imageArray[0];
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, kScreenHeight-76, kScreenWidth-80, 30)];
    self.titleLabel.text = [NSString stringWithFormat:@"来自游记《%@》",model.tn_title];
    
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.textColor = [UIColor orangeColor];
    [self.view addSubview:self.titleLabel];
    self.autherLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, kScreenHeight-56, 60, 40)];
    self.autherLabel.text = model.tn_uname;
    self.autherLabel.textColor = [UIColor whiteColor];
    self.autherLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.autherLabel];
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, kScreenHeight-56, kScreenWidth-130, 40)];
    self.timeLabel.text = [NSString stringWithFormat:@"摄于 %@",model.ptime];
    self.timeLabel.font = [UIFont systemFontOfSize:13];
    self.timeLabel.textColor = [UIColor grayColor];
    [self.view addSubview:self.timeLabel];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//        self.titleLabel
    NSInteger offset = scrollView.contentOffset.x;
    AlubmModel *model = self.imageArray[offset];
    
    self.titleLabel.text = model.tn_title;
    
}
- (void)pinchAction:(UIPinchGestureRecognizer *)pinch{
    self.imageV.transform = CGAffineTransformScale(self.imageV.transform, pinch.scale, pinch.scale);
    pinch.scale = 1.0;
}

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
//            [self getImageWithURL:model.simg];
//            [self.titleArray addObject:model.tn_title];
        }
        [self.view addSubview:self.scrollView];
        [self labelTextAndBtn];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];

    
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
