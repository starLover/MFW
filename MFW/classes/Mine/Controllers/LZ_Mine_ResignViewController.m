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


@interface LZ_Mine_ResignViewController ()
{
    LZPPooCodeView *_pooCodeView;
    
}
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UITextField *validate;
@property (weak, nonatomic) IBOutlet UIView *vailDateView;

@end

@implementation LZ_Mine_ResignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    _pooCodeView = [[LZPPooCodeView alloc] initWithFrame:CGRectMake(0, 0, 82, 34)];
    [self.vailDateView addSubview:_pooCodeView];
    //    self.vailDateView = _pooCodeView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [_pooCodeView addGestureRecognizer:tap];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.phoneNumber becomeFirstResponder];
    
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
