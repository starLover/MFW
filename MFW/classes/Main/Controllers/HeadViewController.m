//
//  HeadViewController.m
//  MFW
//
//  Created by wanghongxiao on 16/3/17.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#import "HeadViewController.h"

@interface HeadViewController ()<UIWebViewDelegate>
@property(nonatomic, strong) UIWebView *webView;
@property(nonatomic, retain) UIActivityIndicatorView *activityView;
@end

@implementation HeadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.webView];
    [self.view addSubview:self.activityView];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self.activityView startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.activityView stopAnimating];
}


#pragma mark     ----------- LazyLoading
- (UIWebView *)webView{
    if (_webView == nil) {
        self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
        self.webView.delegate = self;
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
        [request setTimeoutInterval:10.0];
        [self.webView loadRequest:request];
    }
    return _webView;
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
