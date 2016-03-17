//
//  UIViewController+Common.m
//  MFGY
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#import "UIViewController+Common.h"

@implementation UIViewController (Common)

- (void)showBackBtn{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 20, 44);
    [backBtn setImage:[UIImage imageNamed:@"icon_back_nromal"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
}
- (void)goBackAction{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
