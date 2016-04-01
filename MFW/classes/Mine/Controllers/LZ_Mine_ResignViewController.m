//
//  LZ_Mine_ResignViewController.m
//  MFW
//
//  Created by scjy on 16/3/22.
//  Copyright © 2016年 李志鹏. All rights reserved.
//

#import "LZ_Mine_ResignViewController.h"
#import <BmobSDK/Bmob.h>
#import "LZPPooCodeView.h"
#import "ProgressHUD.h"
#import "LZ_Mine_LoginViewController.h"
#import "LZOAuthViewController.h"
#import "HWAccountTool.h"
#import <BmobSDK/Bmob.h>

@interface LZ_Mine_ResignViewController ()
{
    LZPPooCodeView *_pooCodeView;
    
}
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UITextField *validate;
@property (weak, nonatomic) IBOutlet UIView *vailDateView;
@property (weak, nonatomic) IBOutlet UIImageView *shareButton;

@end

@implementation LZ_Mine_ResignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    self.shareButton.userInteractionEnabled = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:0 target:self action:@selector(login:)];
    _pooCodeView = [[LZPPooCodeView alloc] initWithFrame:CGRectMake(0, 0, 82, 34)];
    [self.vailDateView addSubview:_pooCodeView];
    //    self.vailDateView = _pooCodeView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [_pooCodeView addGestureRecognizer:tap];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = self.shareButton.frame;
    [shareButton addTarget:self action:@selector(sharelogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareButton];
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
- (void)sharelogin{
    LZOAuthViewController *lz = [LZOAuthViewController new];
    [self.navigationController pushViewController:lz animated:YES];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *name = [userDefault valueForKey:@"name"];
    if (name) {
        BOOL isFirst =  [[userDefault objectForKey:@"isfirstlzc"] boolValue];
        if(!isFirst) {
            BmobUser *bUser = [[BmobUser alloc] init];
            bUser.username = name;
            bUser.password = @"mfw123";
            [bUser signUpInBackgroundWithBlock:^ (BOOL isSuccessful, NSError *error){
                //注册成功返回mineVC
                [self.navigationController popViewControllerAnimated:YES];
                if (isSuccessful){
                    [ProgressHUD showSuccess:@"注册成功"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [ProgressHUD dismiss];
                    });
                } else {
                    [ProgressHUD showError:@"授权失败，请重新授权"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [ProgressHUD dismiss];
                    });
                }
            }];
            [userDefault setObject:@"YES"forKey:@"isfirstlzc"];
            [userDefault synchronize];

        }else{
            [BmobUser loginInbackgroundWithAccount:name andPassword:@"mfw123" block:^(BmobUser *user, NSError *error) {
                if (user) {
                    [self.navigationController popViewControllerAnimated:YES];
                    
                } else {
                    [ProgressHUD show:@"授权失败，请重新授权"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [ProgressHUD dismiss];
                    });
                    
                }
            }];

        }
        
    }else{
//        [self.phoneNumber becomeFirstResponder];
    }
}
- (void)tapClick:(UITapGestureRecognizer*)tap{
    [_pooCodeView changeCode];
}
- (BOOL)checkout {
    //用户名不能为空且不能为空格
    if (self.phoneNumber.text.length <= 0 || [self.phoneNumber.text stringByReplacingOccurrencesOfString:@" " withString:@""].length <= 0) {
        //alert提示框
        
        return NO;
    }
    
    //输入密码不为空
    if (self.passWord.text.length <= 0 || [self.passWord.text stringByReplacingOccurrencesOfString:@" " withString:@""].length <= 0) {
        //alert提示框
        
        return NO;
    }
    
    if (![self.validate.text isEqualToString:_pooCodeView.changeString]){
        return NO;
    }
    return YES;
}

   

- (IBAction)resign:(id)sender {
    if (![self checkout]) {
        [ProgressHUD show:@"请注意大小写!"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [ProgressHUD dismiss];
        });
        return;
        }
    [BmobUser loginInbackgroundWithAccount:self.phoneNumber.text andPassword:self.passWord.text block:^(BmobUser *user, NSError *error) {
        if (user) {
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            [ProgressHUD show:@"用户名或密码不正确"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [ProgressHUD dismiss];
            });

        }
    }];

}

//点击右下角回收键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
//点击页面空白处回收键盘
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    
}

@end
