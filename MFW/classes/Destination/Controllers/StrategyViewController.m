//
//  StrategyViewController.m
//  MFW
//
//  Created by scjy on 16/3/22.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import "StrategyViewController.h"
#import "RightTableViewCell.h"
#import "RightModel.h"
#import <AFNetworking/AFHTTPSessionManager.h>
@interface StrategyViewController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
{
    UIWebView *webV;
}
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *itemArray;

@end

@implementation StrategyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    UIView *rightView = [UIView alloc]initWithFrame:CGRectMake(, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    
    [self showBackBtn];
    [self.view addSubview:self.tableView];

    [self loadData];
}
#pragma mark ----------- UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[RightTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        
        RightModel *urlModel = self.itemArray[indexPath.row];
        webV = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//        webV.delegate = self;
//        webV.scrollView.bounces = NO;
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlModel.url]];
        webV.backgroundColor = [UIColor yellowColor];
        [cell.contentView addSubview:webV];
        [webV loadRequest:request];
        NSLog(@"%@",urlModel.url);
        
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemArray.count;
}
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return self.itemArray.count;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //通过webView代理获取到高度后，将内容高度设置为cell的高
    return webV.frame.size.height;
}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    RightModel *titleModel = self.itemArray[section];
//    return titleModel.title;
//}
- (UITableView *)tableView{
    if (!_tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight+60)];
        self.tableView.backgroundColor = [UIColor cyanColor];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
//        self.tableView.rowHeight = 500;
    }
    return _tableView;
}
#pragma mark ----------- webView Delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //获取到webView的高度
    CGFloat height = [[webV stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    webV.frame = CGRectMake(webView.frame.origin.x,webView.frame.origin.y, kScreenWidth, height);
    [self.tableView reloadData];
}
#pragma mark -----------
#pragma mark -----------
- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}
- (void)loadData{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
    [sessionManager GET:kStrategy parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *resultDic = responseObject;
        NSDictionary *data  = resultDic[@"data"];
        NSArray *catalog = data[@"catalog"];
        for (NSDictionary *dic in catalog) {
            RightModel *titleModel = [[RightModel alloc]init];
            [titleModel setValuesForKeysWithDictionary:dic];
            [self.itemArray addObject:titleModel];
        }
        
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}
- (NSMutableArray *)itemArray{
    if (!_itemArray) {
        self.itemArray = [NSMutableArray new];
    }
    return _itemArray;
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