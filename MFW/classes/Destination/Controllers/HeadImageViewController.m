//
//  HeadImageViewController.m
//  MFW
//
//  Created by scjy on 16/3/19.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import "HeadImageViewController.h"
#import "HeadImageTableViewCell.h"
#import "DestinationViewController.h"

#import <AFNetworking/AFHTTPSessionManager.h>

@interface HeadImageViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation HeadImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;

    [self headViewAction];
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:@"HeadImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    [self requestModel];
}

#pragma mark --------- UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 15;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HeadImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}
- (UITableView *)tableView{
    if (!_tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kScreenHeight/4, kScreenWidth, kScreenHeight-108)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = kScreenHeight/6;
    }
    return _tableView;
}
- (void)headViewAction{
    UIView *blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight/4)];
    blackView.backgroundColor = [UIColor blackColor] ;
    [self.view addSubview:blackView];
    
    UIButton *numBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    numBtn.frame = CGRectMake(kScreenWidth-80, 20 , 40, 44);
    [numBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [numBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [blackView addSubview:numBtn];
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, kScreenWidth/3, 40)];
    timeLabel.text = @"过去24小时,";
    timeLabel.textColor = [UIColor whiteColor];
    [blackView addSubview:timeLabel];
    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 50, kScreenWidth/3, 40)];
    numLabel.text = @"626";
    numLabel.textColor = [UIColor whiteColor];
    numLabel.font = [UIFont systemFontOfSize:24];
    [blackView addSubview:numLabel];
    UILabel *placeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 90, kScreenWidth/3, 40)];
    placeLabel.text = @"人，正在%@旅行";
    placeLabel.textColor = [UIColor whiteColor];
    [blackView addSubview:placeLabel];
    
    
    
    

}
- (void)closeAction{
     [self.navigationController popViewControllerAnimated:YES];
}
- (void)requestModel{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
    [sessionManager GET:kHeaderImage parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
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
