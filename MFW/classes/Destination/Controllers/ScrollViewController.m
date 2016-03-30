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
{
    UIWebView *webView;
}

@property(nonatomic,strong)NSMutableArray *imageArray;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIImageView *imageV;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *autherLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *pageLabel;
@property(nonatomic,strong)UIButton *cilckBtn;

@end

@implementation ScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    [self showBackBtn];
    self.tabBarController.tabBar.hidden = YES;
    [self requestModel];
    
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    
}
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-150)];
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
    
    NSInteger offset = self.scrollView.contentOffset.x/kScreenWidth;
    AlubmModel *alubmModel = self.imageArray[offset];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, kScreenHeight-140, kScreenWidth-80, 30)];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.textColor = [UIColor orangeColor];
    [self.view addSubview:self.titleLabel];
    
    self.autherLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, kScreenHeight-120, 130, 40)];
    self.autherLabel.textColor = [UIColor whiteColor];
    self.autherLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.autherLabel];
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, kScreenHeight-120, kScreenWidth-130, 40)];
    self.timeLabel.font = [UIFont systemFontOfSize:13];
    self.timeLabel.textColor = [UIColor grayColor];
    [self.view addSubview:self.timeLabel];
    
    self.pageLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-60, kScreenHeight-120, 60, 40)];
    self.pageLabel.font = [UIFont systemFontOfSize:14];
    self.pageLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.pageLabel];
    
    self.cilckBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cilckBtn.frame = CGRectMake(20, kScreenHeight-140, kScreenWidth - 40, 76);
    [self.cilckBtn addTarget:self action:@selector(detailAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cilckBtn];
    
    
    if (alubmModel.tn_title.length > 1) {
        self.titleLabel.text = [NSString stringWithFormat:@"来自游记《%@》",alubmModel.tn_title];
        self.autherLabel.text = alubmModel.tn_uname;
        self.timeLabel.text = [NSString stringWithFormat:@"摄于 %@",alubmModel.ptime];
        self.pageLabel.text = [NSString stringWithFormat:@" %lu/20",(long)offset+1];
    }else{
//        AlubmModel *alubmModel = self.imageArray[offset-1];
//        self.titleLabel.text = [NSString stringWithFormat:@"来自游记《%@》",alubmModel.tn_title];
        self.titleLabel.text = @"该游记不存在或已经删除";
        self.autherLabel.text = alubmModel.tn_uname;
        self.timeLabel.text = [NSString stringWithFormat:@"摄于 %@",alubmModel.ptime];
        self.pageLabel.text = [NSString stringWithFormat:@" %lu/20",(long)offset+1];
    }
}
- (void)detailAction{
    
    NSInteger offset = self.scrollView.contentOffset.x/kScreenWidth;
    AlubmModel *detailModel = self.imageArray[offset];
    if (detailModel.tn_title.length > 1) {
        self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
        self.view.backgroundColor = [UIColor whiteColor];
        webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, -140, kScreenWidth, kScreenHeight+152)];
        webView.scrollView.bounces = NO;
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:detailModel.tn_url]];
        [self.view addSubview:webView];
        [webView loadRequest:request];
    }else{
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//        self.titleLabel
    NSInteger offset = scrollView.contentOffset.x/kScreenWidth;
    AlubmModel *model = self.imageArray[offset];
    if (model.tn_title.length > 1) {
        self.titleLabel.text = [NSString stringWithFormat:@"来自游记《%@》",model.tn_title];
        self.autherLabel.text = model.tn_uname;
        self.timeLabel.text = [NSString stringWithFormat:@"摄于 %@",model.ptime];
        self.pageLabel.text = [NSString stringWithFormat:@" %lu/20",(long)offset+1];
    }else{
        self.titleLabel.text = @"该游记不存在或已经删除";
        self.autherLabel.text = model.tn_uname;
        self.timeLabel.text = [NSString stringWithFormat:@"摄于 %@",model.ptime];
        self.pageLabel.text = [NSString stringWithFormat:@" %lu/20",(long)offset+1];
    }
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
