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
#import <SystemConfiguration/CaptiveNetwork.h>
#import <MessageUI/MessageUI.h>

@interface LZ_MineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** <List> */
@property (nonatomic, strong) NSMutableArray *List;
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
    self.List = [NSMutableArray arrayWithObjects:@"未连接WIFI",@"打开WIFI",@"清除缓存",@"用户反馈", @"退出登录",nil];;
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
- (NSString *)GetCurrentWifiHotSpotName {
    NSString *wifiName = nil;
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    for (NSString *ifnam in ifs) {
        NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info[@"SSID"]) {
            wifiName = info[@"SSID"];
            return wifiName;
        }
    }
    
    return nil;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([self GetCurrentWifiHotSpotName] != nil) {
        fSLog(@"%@",[self GetCurrentWifiHotSpotName]);
        [self.List replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"已连接 %@",[self GetCurrentWifiHotSpotName]]];
    }else{
        [self.List replaceObjectAtIndex:0 withObject:@"未连接WIFI"];
        
    }
    NSIndexPath *indexPathWifi = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPathWifi] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    SDImageCache *cache = [SDImageCache sharedImageCache];
    NSInteger cacheSize = [cache getSize];
    NSString *cacheStr = [NSString stringWithFormat:@"清除图片缓存(%.02fM)", (double)cacheSize / 1024 / 1024];
    [self.List replaceObjectAtIndex:2 withObject:cacheStr];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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
    if (indexPath.row == 0) {
        
    }
    else if (indexPath.row == 1) {
        NSURL *url = [NSURL URLWithString:@"prefs:root=WIFI"];
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication] openURL:url];
        }
        else
        {
            NSURL *url2 = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:url2];
        }
    }
    else if (indexPath.row == 2) {
        //清除缓存
        SDImageCache *cache = [SDImageCache sharedImageCache];
        [cache clearDisk];
        [self.List replaceObjectAtIndex:2 withObject:@"清除缓存"];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
    else if (indexPath.row == 3) {
        [self sendEmail];
    }
    else  {
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
    }
    
    
}
- (void)sendEmail{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil) {
        if ([MFMailComposeViewController canSendMail]) {
            //初始化
            MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
            //设置代理
            picker.mailComposeDelegate = self;
            //设置主题
            [picker setSubject:@"用户反馈"];
            //设置收件人
            NSArray *recive = [NSArray arrayWithObjects:@"1713396133@qq.com", nil];
            [picker setToRecipients:recive];
            //设置发送内容
            NSString *text = @"请留下您宝贵的意见";
            [picker setMessageBody:text isHTML:NO];
            //推出视图
            [self presentViewController:picker animated:YES completion:nil];
        } else {
            fSLog(@"未配置邮箱账号");
        }
    } else {
        fSLog(@"当前设备不能发送");
    }
    
}
//邮件发送完成调用的方法
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result)
    {
        case MFMailComposeResultCancelled: //取消
            fSLog(@"MFMailComposeResultCancelled-取消");
            break;
        case MFMailComposeResultSaved: // 保存
            fSLog(@"MFMailComposeResultSaved-保存邮件");
            break;
        case MFMailComposeResultSent: // 发送
            fSLog(@"MFMailComposeResultSent-发送邮件");
            break;
        case MFMailComposeResultFailed: // 尝试保存或发送邮件失败
            fSLog(@"MFMailComposeResultFailed: %@...",[error localizedDescription]);
            break;
    }
    //关闭邮件发送窗口
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)userlogout{
    // 1.请求管理者
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    // 2.拼接请求参数
    NSString *URListring = @"https://api.weibo.com/oauth2/revokeoauth2?";
    // 3.发送请求
    [sessionManager GET:[NSString stringWithFormat:@"%@access_token=%@",URListring,self.account.access_token] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
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



























