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
#import "ProgressHUD.h"
#import "HWAccountTool.h"

#import <BmobSDK/Bmob.h>
#import "LZ_Mine_ResignViewController.h"
#import "LZ_DetailTableViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <SDWebImage/SDImageCache.h>
#import <UIImageView+WebCache.h>


@interface LZ_MineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** <LIST> */
@property (nonatomic, strong) NSArray *List;
/** <head> */
@property (nonatomic, strong) LZ_Mine_Head *mineHead;
/** <bmob> */
@property (nonatomic, strong) BmobUser *bUser;
/** <微博用户> */
@property (nonatomic, strong) HWAccount *account;
@end

@implementation LZ_MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.tableView.scrollEnabled = NO;
    self.List = @[@"蜜蜂商城",@"我的下载",@"我的收藏",@"我的订单",@"我的优惠券",@"我的点评",@"我的问答",@"我的活动",@"退出登录"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat sectionHeaderHeight = 100;
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y > 0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }else
        if(scrollView.contentOffset.y >= sectionHeaderHeight){
            
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self makeImageWithName];
    
}
- (void)makeImageWithName{
    self.bUser = [BmobUser getCurrentUser];
    self.mineHead.imageView.layer.cornerRadius     = 50;
    self.mineHead.imageView.clipsToBounds          = YES;
    if (!self.bUser) {
        self.mineHead.imageView.image = [UIImage imageNamed:@"phloder"];
        [self.mineHead.userName setTitle:@"天地自由行的游客" forState:UIControlStateNormal];
    }else{
        UIImage *image = [UIImage imageWithContentsOfFile:kPath];
        NSString *avatar_hd = [[NSUserDefaults standardUserDefaults] valueForKey:@"avatar_hd"];
        if (image) {
            self.mineHead.imageView.image = image;
        }else{
            if (avatar_hd) {
                [self.mineHead.imageView sd_setImageWithURL:[NSURL URLWithString:avatar_hd] placeholderImage:[UIImage imageNamed:@"phloder"]];
            }else{
                self.mineHead.imageView.image = [UIImage imageNamed:@"phloder"];
                
            }
        }

        [self.mineHead.userName setTitle:_bUser.username forState:UIControlStateNormal];
    }
}
- (void)headAction{
    if (!self.bUser) {
        LZ_Mine_ResignViewController *lz = [LZ_Mine_ResignViewController new];
        [self.navigationController pushViewController:lz animated:YES];
    }else{
//    LZ_Mine_Head_DetailViewController *lz = [LZ_Mine_Head_DetailViewController new];
        //    [self.navigationController pushViewController:lz animated:YES];
        LZ_DetailTableViewController *lz = [LZ_DetailTableViewController new];
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
        self.bUser = [BmobUser getCurrentUser];
        [BmobUser logout];
        NSUserDefaults *userDefatluts = [NSUserDefaults standardUserDefaults];
        [userDefatluts removeObjectForKey:@"name"];
        [userDefatluts removeObjectForKey:@"avatar_hd"];
        [userDefatluts synchronize];

        self.account = [HWAccountTool account];
        if (self.account) {
            fSLog(@"%@",self.account);
            [self userlogout];
        }
        
        [ProgressHUD show:@"退出成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [ProgressHUD dismiss];
        });
        [self makeImageWithName];
    }else if (!self.bUser) {
        LZ_Mine_ResignViewController *lz = [LZ_Mine_ResignViewController new];
        [self.navigationController pushViewController:lz animated:YES];
    }else{
//        LZ_Mine_Head_DetailViewController *lz = [LZ_Mine_Head_DetailViewController new];
//        [self.navigationController pushViewController:lz animated:YES];
        
        LZ_DetailTableViewController *lz = [LZ_DetailTableViewController new];
        [self.navigationController pushViewController:lz animated:YES];
    }
    
    
}
- (void)userlogout{
    // 1.请求管理者
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    // 2.拼接请求参数
    NSString *URLString = @"https://api.weibo.com/oauth2/revokeoauth2?";
    // 3.发送请求
    [sessionManager GET:[NSString stringWithFormat:@"%@access_token=%@",URLString,self.account.access_token] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        fSLog(@"%@",responseObject);
        if ([responseObject[@"result"] isEqualToString:@"true"]) {
            fSLog(@"移除授权成功");
        }
        [ProgressHUD showSuccess:@"退出成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [ProgressHUD dismiss];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fSLog(@"%@",error);
    }];
}
@end



























