//
//  LZ_Mine_ResignViewController.m
//  MFW
//
//  Created by scjy on 16/3/22.
//  Copyright © 2016年 李志鹏. All rights reserved.
//

#import "LZ_Mine_ResignViewController.h"
#import <BmobSDK/Bmob.h>

@interface LZ_Mine_ResignViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *passWord;


@end

@implementation LZ_Mine_ResignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
}
- (BOOL)checkout {
    //用户名不能为空且不能为空格
    if (self.phoneNumber.text.length <= 0 || [self.phoneNumber.text stringByReplacingOccurrencesOfString:@" " withString:@""].length <= 0) {
        //alert提示框
        
        return NO;
    }
    
    //两次输入密码一直
    if (self.passWord.text.length <= 0 || [self.passWord.text stringByReplacingOccurrencesOfString:@" " withString:@""].length <= 0) {
        //alert提示框
        
        return NO;
    }
    
    return YES;
}

   

- (IBAction)resign:(id)sender {
    if (![self checkout]) {
    return;
        }
    [BmobUser loginInbackgroundWithAccount:self.phoneNumber.text andPassword:self.passWord.text block:^(BmobUser *user, NSError *error) {
        if (user) {
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            
        }
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
