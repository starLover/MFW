//
//  LZOAuthViewController.m
//  NanYangZiZhuYou
//
//  Created by scjy on 16/3/20.
//  Copyright © 2016年 李志鹏. All rights reserved.
//

#import "LZOAuthViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "HWAccount.h"
#import "HWAccountTool.h"

@interface LZOAuthViewController ()<UIWebViewDelegate>

@end

@implementation LZOAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.创建一个webView
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = self.view.bounds;
    webView.delegate = self;
//    webView.scalesPageToFit = YES;
    [self.view addSubview:webView];
    
    // 2.用webView加载登录页面
    NSURL *url = [NSURL URLWithString:@"https://api.weibo.com/oauth2/authorize?client_id=3036972856&redirect_uri=https://api.weibo.com/oauth2/default.html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
}
//18860233285
//
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // 1.获得url
    NSString *url = request.URL.absoluteString;
//    fSLog(@"%@",url);
    // 2.判断是否为回调地址
    NSRange range = [url rangeOfString:@"code="];
    if (range.length != 0) { // 是回调地址
        // 截取code=后面的参数值
        NSInteger fromIndex = range.location + range.length;
        NSString *code = [url substringFromIndex:fromIndex];
//        fSLog(@"%@",code);
        // 利用code换取一个accessToken
        [self accessTokenWithCode:code];
        return NO;
    }
    
    return YES;
}
- (void)accessTokenWithCode:(NSString *)code
{
    /*
     URL：https://api.weibo.com/oauth2/access_token
     请求参数：
     client_id：申请应用时分配的AppKey
     client_secret：申请应用时分配的AppSecret
     grant_type：使用authorization_code
     redirect_uri：授权成功后的回调地址
     code：授权成功后返回的code
     */
    NSString *URLString = @"https://api.weibo.com/oauth2/access_token";
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"client_id"] = @"3036972856";
    params[@"client_secret"] = @"f14a5b8e1135b7a5267f60698d23a3db";
    params[@"grant_type"] = @"authorization_code";
    params[@"redirect_uri"] = @"https://api.weibo.com/oauth2/default.html";
    params[@"code"] = code;
    
    [sessionManager POST:URLString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 将返回的账号字典数据 --> 模型，存进沙盒
        HWAccount *account = [HWAccount accountWithDict:responseObject];
        // 存储账号信息
        [HWAccountTool saveAccount:account];
        
        //在发一个请求，请求微博用户信息，头像，用户名
        [self setupUserInfo:account];
       
        fSLog(@"成功%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fSLog(@"失败%@",error);
    }];
}

#pragma mark    //[新浪登录]
- (void)setupUserInfo:(HWAccount *)account
{
    
    // 1.请求管理者
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    // 2.拼接请求参数
    NSString *URLString = @"https://api.weibo.com/2/users/show.json?";
    // 3.发送请求
    [sessionManager GET:[NSString stringWithFormat:@"%@access_token=%@&uid=%@",URLString,account.access_token,account.uid] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setValue:responseObject[@"name"] forKey:@"name"];
        [userDefault setValue:responseObject[@"avatar_hd"] forKey:@"avatar_hd"];
        [userDefault synchronize];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        fSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fSLog(@"%@",error);
    }];
    
}

@end


    /*
     {
     "access_token" = "2.00_5tKNE0JUtMxdd6c93c3fevPysXE";
     "expires_in" = 157679999;
     "remind_in" = 157679999;
     uid = 3859219903;
     }

     */
























