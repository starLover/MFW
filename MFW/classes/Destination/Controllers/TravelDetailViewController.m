//
//  TravelDetailViewController.m
//  MFW
//
//  Created by scjy on 16/3/24.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import "TravelDetailViewController.h"

@interface TravelDetailViewController ()<UIWebViewDelegate>
{
    UIWebView *webView;
}
@property(nonatomic,strong)UIActivityIndicatorView *activityView;

@end

@implementation TravelDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackBtn];
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, -140, kScreenWidth, kScreenHeight+195)];
    webView.scrollView.bounces = NO;
    webView.delegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
//    NSLog(@"###########%@",self.url);
    [self.view addSubview:webView];
    [webView reload];
    [webView loadRequest:request];
    [self.view addSubview:self.activityView];
    
}
- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self.activityView startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.activityView stopAnimating];
}
- (UIActivityIndicatorView *)activityView{
    if (_activityView == nil) {
        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.activityView.backgroundColor = [UIColor grayColor];
        self.activityView.center = self.view.center;
    }
    return _activityView;
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
