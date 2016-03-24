//
//  LZ_MineViewController.m
//  MFW
//
//  Created by scjy on 16/3/17.
//  Copyright © 2016年 李志鹏. All rights reserved.
//

#import "LZ_MineViewController.h"
#import "LZ_Mine_Head.h"
#import "LZ_Mine_Head_DetailViewController.h"
#import "WXApi.h"
#import "MBProgressHUD.h"
#import "ProgressHUD.h"
#import "LZ_Mine_LoginViewController.h"
#import <BmobSDK/Bmob.h>
#import "LZ_Mine_ResignViewController.h"


@interface LZ_MineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** <LIST> */
@property (nonatomic, strong) NSArray *List;
/** <head> */
@property (nonatomic, strong) LZ_Mine_Head *mineHead;
/** <bmob> */
@property (nonatomic, strong) BmobUser *bUser;
@end

@implementation LZ_MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:0 target:self action:@selector(login:)];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.scrollEnabled = NO;
    self.List = @[@"蜜蜂商城",@"我的下载",@"我的收藏",@"我的订单",@"我的优惠券",@"我的点评",@"我的问答",@"我的活动",@"退出登录"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self makeImageWithName];
    
}
- (void)makeImageWithName{
    self.bUser = [BmobUser getCurrentUser];
    self.mineHead.imageView.layer.cornerRadius     = 40;
    self.mineHead.imageView.clipsToBounds          = YES;
    if (!self.bUser) {
        self.mineHead.imageView.image = [UIImage imageNamed:@"2"];
        [self.mineHead.userName setTitle:@"天地自由行的游客" forState:UIControlStateNormal];
    }else{
        self.mineHead.imageView.image = [UIImage imageWithContentsOfFile:kPath];
        [self.mineHead.userName setTitle:_bUser.username forState:UIControlStateNormal];
    }
}
- (void)login:(UIButton *)button{
    /*
     
     //构造SendAuthReq结构体
     SendAuthReq* req =[[SendAuthReq alloc ] init];
     req.scope = @"snsapi_userinfo" ;
     req.state = @"123" ;
     //第三方向微信终端发送一个SendAuthReq消息结构
     [WXApi sendReq:req];
     */
    
    LZ_Mine_LoginViewController *lz = [LZ_Mine_LoginViewController new];
    [self.navigationController pushViewController:lz animated:YES];
}
- (void)headAction{
    if (!self.bUser) {
        LZ_Mine_ResignViewController *lz = [LZ_Mine_ResignViewController new];
        [self.navigationController pushViewController:lz animated:YES];
    }else{
    LZ_Mine_Head_DetailViewController *lz = [LZ_Mine_Head_DetailViewController new];
    [self.navigationController pushViewController:lz animated:YES];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.List.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellidentifier = @"LZ_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellidentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.List[indexPath.row];
    return cell;
    
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    self.mineHead = [[[NSBundle mainBundle] loadNibNamed:@"LZ_Mine_Head" owner:nil options:nil] lastObject];
    
    UIButton *headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    headBtn.frame = self.mineHead.frame;
    [headBtn addTarget:self action:@selector(headAction) forControlEvents:UIControlEventTouchUpInside];
    [self.mineHead addSubview:headBtn];
    
    [self makeImageWithName];
    return self.mineHead;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 8) {
        [BmobUser logout];
        [self viewWillAppear:YES];
        [ProgressHUD show:@"退出成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [ProgressHUD dismiss];
        });
    }else if (!self.bUser) {
        LZ_Mine_ResignViewController *lz = [LZ_Mine_ResignViewController new];
        [self.navigationController pushViewController:lz animated:YES];
    }else{
        LZ_Mine_Head_DetailViewController *lz = [LZ_Mine_Head_DetailViewController new];
        [self.navigationController pushViewController:lz animated:YES];
    }
    
    
}

@end



























