//
//  Food2ViewController.m
//  MFW
//
//  Created by scjy on 16/3/29.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import "Food2ViewController.h"

@interface Food2ViewController ()<UIWebViewDelegate>
{
    UIWebView *webView;
}
@property(nonatomic,strong)UIActivityIndicatorView *activityView;

@end

@implementation Food2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"美食";
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIColor orangeColor] forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dic;
    [self showBackBtn];
    //http:www.mafengwo.cn/cy/11527/gonglve.html
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, -145, kScreenWidth, kScreenHeight+130)];
    webView.scrollView.bounces = NO;
    webView.delegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.mafengwo.cn/cy/10094/gonglve.html"]];
    [self.view addSubview:webView];
    [webView loadRequest:request];
    [self.view addSubview:self.activityView];
}
#pragma mark -----------   view
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
