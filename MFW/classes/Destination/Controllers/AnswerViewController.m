//
//  AnswerViewController.m
//  
//
//  Created by scjy on 16/3/29.
//
//

#import "AnswerViewController.h"

@interface AnswerViewController ()
{
    UIWebView *webView;
}
@end

@implementation AnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackBtn];
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, -95, kScreenWidth, kScreenHeight+130)];
    webView.scrollView.bounces = NO;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.mafengwo.cn/wenda/area-10094.html?sFrom=mdd"]];
    [self.view addSubview:webView];
    [webView loadRequest:request];
}
#pragma mark -----------   view
- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
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
